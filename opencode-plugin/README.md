# opencode-multi-agent

[日本語](README.ja-JP.md)

`opencode-multi-agent` is a local multi-agent orchestration plugin for
OpenCode. It is installed directly from this expanded folder and is not
published to npm or GitHub.

## Requirements

- OpenCode
- Bun
- This complete expanded folder

## Install

Open a terminal in this folder and run:

```bash
bun install
bun run install:local
```

The installer builds the plugin and registers this folder's absolute path in
the OpenCode and TUI `plugin` arrays. It also creates the plugin configuration
with an absolute `file://` URL for `opencode-multi-agent.schema.json`.

If this folder is moved, replaced, or re-extracted, rerun both commands from
the new location.

Configuration files are stored at:

```text
~/.config/opencode/opencode-multi-agent.json[c]
<project>/.opencode/opencode-multi-agent.json[c]
```

For installer options, diagnostics, updates, and removal, see
[Local Installation](docs/installation.md).
