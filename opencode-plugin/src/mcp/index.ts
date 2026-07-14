import { gh_grep } from './grep-app';
import type { McpConfig } from './types';

export type { LocalMcpConfig, McpConfig, RemoteMcpConfig } from './types';

const allBuiltinMcps: Record<string, McpConfig> = {
  gh_grep,
};

/**
 * Creates the merged built-in and user-configured MCP registry.
 * User-configured local MCPs override built-ins with the same name.
 */
export function createMcpConfigs(
  disabledMcps: readonly string[] = [],
  configuredMcps: Record<string, McpConfig> = {},
): Record<string, McpConfig> {
  const mcps = { ...allBuiltinMcps, ...configuredMcps };

  return Object.fromEntries(
    Object.entries(mcps).filter(([name]) => !disabledMcps.includes(name)),
  );
}

export function mergeMcpConfigs(
  hostMcps: Record<string, unknown> | undefined,
  pluginMcps: Record<string, McpConfig>,
  disabledMcps: readonly string[] = [],
): Record<string, unknown> {
  const merged = { ...(hostMcps ?? {}), ...pluginMcps };
  for (const disabledMcp of disabledMcps) {
    delete merged[disabledMcp];
  }
  return merged;
}
