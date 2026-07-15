import { afterEach, describe, expect, test } from 'bun:test';
import {
  mkdir,
  mkdtemp,
  readFile,
  rm,
  writeFile,
} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import {
  LEGACY_PROJECT_STATE_DIR,
  migrateProjectStateDirectory,
  PROJECT_STATE_DIR,
} from './project-state-migration';

const tempDirectories: string[] = [];

async function createTempDirectory(): Promise<string> {
  const directory = await mkdtemp(
    path.join(os.tmpdir(), 'opencode-multi-agent-migration-'),
  );
  tempDirectories.push(directory);
  return directory;
}

afterEach(async () => {
  await Promise.all(
    tempDirectories.splice(0).map((directory) =>
      rm(directory, { recursive: true, force: true }),
    ),
  );
});

describe('migrateProjectStateDirectory', () => {
  test('renames legacy state and updates known ignore paths', async () => {
    const root = await createTempDirectory();
    const legacyDeepwork = path.join(
      root,
      LEGACY_PROJECT_STATE_DIR,
      'deepwork',
    );
    await mkdir(legacyDeepwork, { recursive: true });
    await writeFile(path.join(legacyDeepwork, 'task.md'), 'progress\n');
    await writeFile(
      path.join(root, '.gitignore'),
      '.slim/codemap.json\r\n.slim/deepwork/\r\n.slim/custom/\r\n',
    );
    await writeFile(
      path.join(root, '.ignore'),
      '!.slim/deepwork/\n!.slim/deepwork/**\n',
    );

    const result = await migrateProjectStateDirectory(root);

    expect(result).toEqual({
      status: 'migrated',
      updatedIgnoreFiles: ['.gitignore', '.ignore'],
      warnings: [],
    });
    expect(
      await readFile(
        path.join(root, PROJECT_STATE_DIR, 'deepwork', 'task.md'),
        'utf8',
      ),
    ).toBe('progress\n');
    expect(
      await readFile(path.join(root, LEGACY_PROJECT_STATE_DIR), 'utf8').catch(
        (error: NodeJS.ErrnoException) => error.code,
      ),
    ).toBe('ENOENT');
    expect(await readFile(path.join(root, '.gitignore'), 'utf8')).toBe(
      '.opencode-multi-agent/codemap.json\r\n.opencode-multi-agent/deepwork/\r\n.slim/custom/\r\n',
    );
    expect(await readFile(path.join(root, '.ignore'), 'utf8')).toBe(
      '!.opencode-multi-agent/deepwork/\n!.opencode-multi-agent/deepwork/**\n',
    );
  });

  test('leaves an existing target directory unchanged', async () => {
    const root = await createTempDirectory();
    const target = path.join(root, PROJECT_STATE_DIR);
    await mkdir(target);
    await writeFile(path.join(target, 'state.json'), '{}\n');

    const result = await migrateProjectStateDirectory(root);

    expect(result.status).toBe('not-needed');
    expect(await readFile(path.join(target, 'state.json'), 'utf8')).toBe('{}\n');
  });

  test('does nothing when neither state directory exists', async () => {
    const root = await createTempDirectory();

    const result = await migrateProjectStateDirectory(root);

    expect(result).toEqual({
      status: 'not-needed',
      updatedIgnoreFiles: [],
      warnings: [],
    });
    expect(
      await readFile(path.join(root, PROJECT_STATE_DIR), 'utf8').catch(
        (error: NodeJS.ErrnoException) => error.code,
      ),
    ).toBe('ENOENT');
  });

  test('does not merge when legacy and target directories both exist', async () => {
    const root = await createTempDirectory();
    const legacy = path.join(root, LEGACY_PROJECT_STATE_DIR);
    const target = path.join(root, PROJECT_STATE_DIR);
    await mkdir(legacy);
    await mkdir(target);
    await writeFile(path.join(legacy, 'legacy.txt'), 'legacy\n');
    await writeFile(path.join(target, 'current.txt'), 'current\n');
    await writeFile(path.join(root, '.gitignore'), '.slim/deepwork/\n');

    const result = await migrateProjectStateDirectory(root);

    expect(result.status).toBe('conflict');
    expect(result.updatedIgnoreFiles).toEqual([]);
    expect(result.warnings).toHaveLength(1);
    expect(await readFile(path.join(legacy, 'legacy.txt'), 'utf8')).toBe(
      'legacy\n',
    );
    expect(await readFile(path.join(target, 'current.txt'), 'utf8')).toBe(
      'current\n',
    );
    expect(await readFile(path.join(root, '.gitignore'), 'utf8')).toBe(
      '.slim/deepwork/\n',
    );
  });

  test('returns a failure instead of throwing for an invalid legacy path', async () => {
    const root = await createTempDirectory();
    await writeFile(path.join(root, LEGACY_PROJECT_STATE_DIR), 'not a folder');

    const result = await migrateProjectStateDirectory(root);

    expect(result.status).toBe('failed');
    expect(result.warnings[0]).toContain('is not a directory');
  });
});
