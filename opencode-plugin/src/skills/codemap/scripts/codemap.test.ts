import { afterEach, describe, expect, test } from 'bun:test';
import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import {
  cmdInit,
  STATE_DIR,
  STATE_FILE,
} from './codemap.mjs';

const tempDirectories: string[] = [];

afterEach(async () => {
  await Promise.all(
    tempDirectories.splice(0).map((directory) =>
      rm(directory, { recursive: true, force: true }),
    ),
  );
});

describe('codemap state directory', () => {
  test('writes state under .opencode-multi-agent', async () => {
    const root = await mkdtemp(
      path.join(os.tmpdir(), 'opencode-multi-agent-codemap-'),
    );
    tempDirectories.push(root);
    await mkdir(path.join(root, 'src'));
    await writeFile(path.join(root, 'src', 'index.ts'), 'export {};\n');

    expect(
      cmdInit({
        root,
        include: ['src/**/*.ts'],
        exclude: [],
        exception: [],
      }),
    ).toBe(0);

    const state = JSON.parse(
      await readFile(path.join(root, STATE_DIR, STATE_FILE), 'utf8'),
    );
    expect(STATE_DIR).toBe('.opencode-multi-agent');
    expect(Object.keys(state.file_hashes)).toContain('src/index.ts');
  });
});
