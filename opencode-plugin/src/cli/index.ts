#!/usr/bin/env bun
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { doctor, parseDoctorArgs } from './doctor';
import { install } from './install';
import { getGeneratedPresetNames, isGeneratedPresetName } from './providers';
import type { BackgroundSubagentsArg, BooleanArg, InstallArgs } from './types';

export function parseArgs(args: string[]): InstallArgs {
  const result: InstallArgs = {
    tui: true,
    skills: 'yes',
  };

  for (const arg of args) {
    if (arg === '--no-tui') {
      result.tui = false;
    } else if (arg.startsWith('--skills=')) {
      result.skills = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--preset=')) {
      const preset = arg.split('=')[1];
      if (!isGeneratedPresetName(preset)) {
        console.error(
          `Unsupported preset: ${preset}. Available presets: ${getGeneratedPresetNames().join(', ')}`,
        );
        process.exit(1);
      }
      result.preset = preset;
    } else if (arg.startsWith('--background-subagents=')) {
      const mode = arg.split('=')[1] as BackgroundSubagentsArg;
      if (!['ask', 'yes', 'no'].includes(mode)) {
        console.error(
          'Unsupported --background-subagents value: use ask, yes, or no',
        );
        process.exit(1);
      }
      result.backgroundSubagents = mode;
    } else if (arg.startsWith('--background-subagents-target=')) {
      result.backgroundSubagentsTarget = arg.split('=')[1];
    } else if (arg === '--dry-run') {
      result.dryRun = true;
    } else if (arg === '--reset') {
      result.reset = true;
    } else if (arg === '-h' || arg === '--help') {
      printHelp();
      process.exit(0);
    } else if (arg.startsWith('-')) {
      console.error(`Unsupported option: ${arg}`);
      process.exit(1);
    }
  }

  result.backgroundSubagents ??= 'ask';

  return result;
}

function printHelp(): void {
  console.log(`
opencode-multi-agent installer

Usage:
  bun dist/cli/index.js install [OPTIONS]
  bun dist/cli/index.js doctor [OPTIONS]

Options:
  --skills=yes|no        Install bundled skills (default: yes)
  --preset=<name>        Active generated config preset (default: openai)
  --background-subagents=ask|yes|no
                          Persist required OpenCode background subagent env
                          (default: ask; prompt defaults to yes)
  --background-subagents-target=<path>
                          Shell startup file to update
  --no-tui               Non-interactive mode
  --dry-run              Simulate install without writing files
  --reset                Force overwrite of existing configuration
  -h, --help             Show this help message

Doctor options:
  --json                 Print diagnostics as JSON

Available presets: ${getGeneratedPresetNames().join(', ')}

The installer generates OpenAI and OpenCode Go presets by default.
OpenAI is active unless --preset selects another generated preset.
Configuration is validated by opencode-multi-agent.schema.json.

Examples:
  bun run install:local
  bun run install:local -- --no-tui --skills=yes
  bun run install:local -- --background-subagents=yes
  bun run install:local -- --preset=opencode-go
  bun run install:local -- --reset
  bun dist/cli/index.js doctor
`);
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === 'install') {
    const hasSubcommand = args[0] === 'install';
    const installArgs = parseArgs(args.slice(hasSubcommand ? 1 : 0));
    const exitCode = await install(installArgs);
    process.exit(exitCode);
  } else if (args[0] === 'doctor') {
    const doctorArgs = parseDoctorArgs(args.slice(1));
    const exitCode = await doctor(doctorArgs);
    process.exit(exitCode);
  } else if (args[0] === '-h' || args[0] === '--help') {
    printHelp();
    process.exit(0);
  } else {
    console.error(`Unknown command: ${args[0]}`);
    console.error('Run with --help for usage information');
    process.exit(1);
  }
}

const isDirectExecution =
  process.argv[1] !== undefined &&
  path.resolve(process.argv[1]) === fileURLToPath(import.meta.url);

if (isDirectExecution) {
  main().catch((err) => {
    console.error('Fatal error:', err);
    process.exit(1);
  });
}
