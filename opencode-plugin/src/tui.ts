import type { TuiPluginApi, TuiPluginModule } from '@opencode-ai/plugin/tui';
import type { JSX } from '@opentui/solid';
import { DEFAULT_DISABLED_AGENTS, SUBAGENT_NAMES } from './config/constants';
import {
  readTuiSnapshot,
  readTuiSnapshotAsync,
  type TuiSnapshot,
} from './tui-state';
import { isPluginDisabledByEnv } from './utils/env';

const PLUGIN_NAME = 'opencode-multi-agent';
const CONFIG_WARNING_COLOR = 'orange';
const EDITOR_FILE_CONTEXT_KEY = 'file_context_enabled';
const TUI_KV_READY_POLL_INTERVAL_MS = 10;
const TUI_KV_READY_TIMEOUT_MS = 5000;
const FALLBACK_SIDEBAR_AGENTS = SUBAGENT_NAMES.filter(
  (agent) =>
    agent !== 'councillor' &&
    agent !== 'council' &&
    !DEFAULT_DISABLED_AGENTS.includes(agent),
);
const BORDER = { type: 'single' };

type Child = JSX.Element | string | number | null | undefined | false;
type SolidRuntime = Pick<
  typeof import('@opentui/solid'),
  'createElement' | 'insert' | 'setProp'
>;

let solidRuntime: SolidRuntime | undefined;

async function readPackageVersion(): Promise<string | undefined> {
  try {
    const packageJson = (await Bun.file(
      new URL('../package.json', import.meta.url),
    ).json()) as { version?: unknown };

    return typeof packageJson.version === 'string'
      ? packageJson.version
      : undefined;
  } catch {
    return undefined;
  }
}

function element(
  tag: string,
  props: Record<string, unknown>,
  children: Child[] = [],
) {
  if (!solidRuntime) {
    throw new Error('OpenTUI Solid runtime is not ready');
  }

  const node = solidRuntime.createElement(tag);

  for (const [key, value] of Object.entries(props)) {
    if (value !== undefined) solidRuntime.setProp(node, key, value);
  }

  for (const child of children) {
    if (child === null || child === undefined || child === false) continue;
    solidRuntime.insert(node, child);
  }

  return node as JSX.Element;
}

function text(props: Record<string, unknown>, children: Child[]) {
  return element('text', props, children);
}

function box(props: Record<string, unknown>, children: Child[] = []) {
  return element('box', props, children);
}

function getTuiDirectory(api: {
  state?: { path?: { directory?: string } };
}): string {
  return api.state?.path?.directory ?? process.cwd();
}

export function splitSidebarModelId(model: string): {
  provider?: string;
  model: string;
} {
  const slashIndex = model.indexOf('/');
  if (slashIndex === -1) {
    return { model };
  }

  return {
    provider: model.slice(0, slashIndex),
    model: model.slice(slashIndex + 1),
  };
}

export function getSidebarAgentNames(snapshot: TuiSnapshot): string[] {
  const configuredAgents = Object.keys(snapshot.agentModels);
  return configuredAgents.length > 0
    ? configuredAgents
    : FALLBACK_SIDEBAR_AGENTS;
}

function agentRow(
  label: string,
  model: string,
  variant: string | undefined,
  theme: { textMuted: unknown },
): JSX.Element {
  const modelParts = splitSidebarModelId(model);
  const detailRows: JSX.Element[] = [];

  function detailRow(fieldLabel: string, value: string) {
    return box({ width: '100%', flexDirection: 'row', paddingLeft: 2 }, [
      text({ fg: theme.textMuted, width: 9 }, [fieldLabel]),
      text({ fg: theme.textMuted }, [value]),
    ]);
  }

  if (modelParts.provider) {
    detailRows.push(detailRow('provider', modelParts.provider));
  }
  detailRows.push(detailRow('model', modelParts.model));
  if (variant) {
    detailRows.push(detailRow('variant', variant));
  }

  return box({ width: '100%', flexDirection: 'column', marginBottom: 1 }, [
    text({ fg: theme.textMuted }, [label]),
    ...detailRows,
  ]);
}

function compactAgentRow(
  label: string,
  model: string,
  _variant: string | undefined,
  theme: { textMuted: unknown },
): JSX.Element {
  const modelName = splitSidebarModelId(model).model;
  return box(
    {
      width: '100%',
      flexDirection: 'row',
      justifyContent: 'space-between',
    },
    [
      text({ fg: theme.textMuted, width: 14 }, [label]),
      text({ fg: theme.textMuted }, [modelName]),
    ],
  );
}

function renderSidebar(
  snapshot: TuiSnapshot,
  version: string,
  theme: {
    accent: unknown;
    background: unknown;
    borderActive: unknown;
    text: unknown;
    textMuted: unknown;
  },
  configInvalid: boolean,
  compactSidebar: boolean,
): JSX.Element {
  const configStatusRow = buildConfigStatusRow(configInvalid, theme);
  return box(
    {
      width: '100%',
      flexDirection: 'column',
      border: BORDER,
      borderColor: theme.borderActive,
      paddingTop: 1,
      paddingBottom: 1,
      paddingLeft: 1,
      paddingRight: 1,
    },
    [
      box(
        {
          width: '100%',
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center',
        },
        [
          box(
            { paddingLeft: 1, paddingRight: 1, backgroundColor: theme.accent },
            // Use theme.text, not theme.background: when the theme background is
            // "none" (transparent) the foreground becomes RGBA(0,0,0,0) and the
            // badge text vanishes. See #582.
            [text({ fg: theme.text }, ['opencode-multi-agent'])],
          ),
          text({ fg: theme.textMuted }, [`v${version}`]),
        ],
      ),
      configStatusRow,
      box({ width: '100%', marginTop: 1 }, [
        text({ fg: theme.text }, ['Agents']),
      ]),
      ...getSidebarAgentNames(snapshot).map((agentName) => {
        const model = snapshot.agentModels[agentName] ?? 'pending';
        const variant = snapshot.agentVariants[agentName];
        if (compactSidebar) {
          return compactAgentRow(agentName, model, variant, theme);
        }
        return agentRow(agentName, model, variant, theme);
      }),
    ],
  );
}

function buildConfigStatusRow(
  configInvalid: boolean,
  theme: { textMuted: unknown },
): JSX.Element | null {
  if (!configInvalid) return null;

  return box(
    {
      width: '100%',
      flexDirection: 'column',
      marginTop: 1,
      marginBottom: 1,
    },
    [
      text({ fg: CONFIG_WARNING_COLOR }, ['Config invalid']),
      text({ fg: theme.textMuted }, ['Run doctor for details']),
    ],
  );
}

export function disableEditorFileContext(
  api: Pick<TuiPluginApi, 'kv' | 'lifecycle'>,
): void {
  api.kv.set(EDITOR_FILE_CONTEXT_KEY, false);
  if (api.kv.ready || api.lifecycle.signal.aborted) return;

  const deadline = Date.now() + TUI_KV_READY_TIMEOUT_MS;
  const timer = setInterval(() => {
    if (api.lifecycle.signal.aborted || Date.now() >= deadline) {
      clearInterval(timer);
      return;
    }
    if (!api.kv.ready) return;

    api.kv.set(EDITOR_FILE_CONTEXT_KEY, false);
    clearInterval(timer);
  }, TUI_KV_READY_POLL_INTERVAL_MS);

  api.lifecycle.onDispose(() => {
    clearInterval(timer);
  });
}

const plugin: TuiPluginModule & { id: string } = {
  id: `${PLUGIN_NAME}:tui`,
  tui: async (api, _options, meta) => {
    if (isPluginDisabledByEnv()) return;

    disableEditorFileContext(api);

    const version = meta.version ?? (await readPackageVersion()) ?? 'dev';
    let snapshot = readTuiSnapshot(getTuiDirectory(api));
    const renderTimer = setInterval(async () => {
      try {
        const currentDirectory = getTuiDirectory(api);
        snapshot = await readTuiSnapshotAsync(currentDirectory);
        api.renderer.requestRender();
      } catch {
        // Ignore render errors; this is best-effort live status.
      }
    }, 1000);

    api.lifecycle.onDispose(() => {
      clearInterval(renderTimer);
    });

    api.slots.register({
      order: 900,
      slots: {
        sidebar_content() {
          if (!solidRuntime) return null;
          return renderSidebar(
            snapshot,
            version,
            api.theme.current,
            snapshot.configuration.invalid,
            snapshot.configuration.compactSidebar,
          );
        },
      },
    });

    if (!solidRuntime) {
      void import('@opentui/solid')
        .then((runtime) => {
          if (api.lifecycle.signal.aborted) return;
          solidRuntime = runtime;
          api.renderer.requestRender();
        })
        .catch((error) => {
          console.error(
            '[opencode-multi-agent] Failed to load TUI renderer:',
            error,
          );
        });
    }
  },
};

export default plugin;
