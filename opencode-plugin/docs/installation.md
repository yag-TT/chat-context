# Local Installation

`opencode-multi-agent` is distributed as an expanded local folder. It is
not installed from npm or GitHub, and it has no automatic updater.

## Requirements

- OpenCode installed and available as `opencode`
- Bun installed and available as `bun`
- The complete expanded `opencode-multi-agent` folder
- Optional: tmux, Zellij, Herdr, or cmux for visible child-agent panes

## Install

Open a terminal in the expanded folder:

```bash
cd /absolute/path/to/opencode-multi-agent
bun install
bun run install:local
```

The installer builds the project and registers the expanded folder's absolute
path in the OpenCode and TUI `plugin` arrays. It never writes a bare package
name, version pin, registry URL, or npm cache path.

It also writes the generated plugin configuration to:

```text
~/.config/opencode/opencode-multi-agent.json
```

The generated `$schema` value is an absolute `file://` URL pointing to:

```text
<expanded-folder>/opencode-multi-agent.schema.json
```

If `OPENCODE_CONFIG_DIR` or `XDG_CONFIG_HOME` is set, the corresponding OpenCode
configuration directory is used.

## Folder Moves and Updates

The folder path is part of the OpenCode configuration. After moving, replacing,
or re-extracting the folder, run the installer again from its new location:

```bash
bun install
bun run install:local
```

There is no remote version check or automatic update. Updating means replacing
the local files, reinstalling dependencies if necessary, and rerunning the
installer.

## Installer Options

```text
--skills=yes|no
--preset=<name>
--background-subagents=ask|yes|no
--background-subagents-target=<path>
--no-tui
--dry-run
--reset
```

Examples:

```bash
bun run install:local -- --no-tui --skills=yes
bun run install:local -- --background-subagents=yes
bun run install:local -- --preset=opencode-go
bun run install:local -- --dry-run
bun run install:local -- --reset
```

Use the built CLI for diagnostics:

```bash
bun dist/cli/index.js doctor
bun dist/cli/index.js doctor --json
```

## Existing Legacy Installation

The installer deliberately does not inspect, remove, migrate, or alias legacy
plugin registrations, config files, prompt folders, state, logs, or environment
variables. If both plugins are registered, OpenCode may load both. Remove an
unwanted legacy registration manually from your OpenCode/TUI config.

## Uninstall

1. Remove the absolute `opencode-multi-agent` folder entry from the
   `plugin` arrays in OpenCode and TUI config.
2. Remove these files or directories if no longer needed:

   ```text
   ~/.config/opencode/opencode-multi-agent.json
   ~/.config/opencode/opencode-multi-agent.jsonc
   ~/.config/opencode/opencode-multi-agent/
   ~/.config/opencode/.opencode-multi-agent/
   ```

3. Delete the expanded project folder.

Do not remove legacy files unless you separately decide to uninstall the legacy
plugin.
