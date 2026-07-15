import { lstat, readFile, rename, writeFile } from 'node:fs/promises';
import path from 'node:path';

export const LEGACY_PROJECT_STATE_DIR = '.slim';
export const PROJECT_STATE_DIR = '.opencode-multi-agent';

const IGNORE_FILE_NAMES = ['.gitignore', '.ignore'] as const;
const KNOWN_LEGACY_IGNORE_PATTERNS = new Set([
  '.slim/',
  '.slim/codemap.json',
  '.slim/clonedeps/repos/',
  '.slim/worktrees/',
  '.slim/worktrees.json',
  '.slim/deepwork/',
  '!.slim/',
  '!.slim/**',
  '!.slim/clonedeps.json',
  '!.slim/clonedeps/',
  '!.slim/clonedeps/repos/',
  '!.slim/clonedeps/repos/**',
  '.slim/clonedeps/repos/**/.git/',
  '.slim/clonedeps/repos/**/.git/**',
  '!.slim/worktrees.json',
  '!.slim/worktrees/',
  '!.slim/worktrees/**',
  '!.slim/deepwork/',
  '!.slim/deepwork/**',
]);

type MigrationStatus = 'not-needed' | 'migrated' | 'conflict' | 'failed';

export interface ProjectStateMigrationResult {
  status: MigrationStatus;
  updatedIgnoreFiles: string[];
  warnings: string[];
}

type PathKind = 'missing' | 'directory' | 'other';

function errorCode(error: unknown): string | undefined {
  if (typeof error !== 'object' || error === null || !('code' in error)) {
    return undefined;
  }

  const code = (error as { code?: unknown }).code;
  return typeof code === 'string' ? code : undefined;
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}

async function getPathKind(targetPath: string): Promise<PathKind> {
  try {
    const stat = await lstat(targetPath);
    return stat.isDirectory() ? 'directory' : 'other';
  } catch (error) {
    if (errorCode(error) === 'ENOENT') return 'missing';
    throw error;
  }
}

function rewriteKnownIgnorePaths(content: string): string {
  const parts = content.split(/(\r\n|\n|\r)/);

  for (let index = 0; index < parts.length; index += 2) {
    const line = parts[index];
    if (!KNOWN_LEGACY_IGNORE_PATTERNS.has(line.trim())) continue;

    parts[index] = line.replace(
      LEGACY_PROJECT_STATE_DIR,
      PROJECT_STATE_DIR,
    );
  }

  return parts.join('');
}

async function updateIgnoreFile(filePath: string): Promise<boolean> {
  let content: string;
  try {
    content = await readFile(filePath, 'utf8');
  } catch (error) {
    if (errorCode(error) === 'ENOENT') return false;
    throw error;
  }

  const updated = rewriteKnownIgnorePaths(content);
  if (updated === content) return false;

  await writeFile(filePath, updated, 'utf8');
  return true;
}

async function updateIgnoreFiles(projectDirectory: string): Promise<{
  updatedIgnoreFiles: string[];
  warnings: string[];
}> {
  const updatedIgnoreFiles: string[] = [];
  const warnings: string[] = [];

  for (const fileName of IGNORE_FILE_NAMES) {
    try {
      if (await updateIgnoreFile(path.join(projectDirectory, fileName))) {
        updatedIgnoreFiles.push(fileName);
      }
    } catch (error) {
      warnings.push(`Failed to update ${fileName}: ${errorMessage(error)}`);
    }
  }

  return { updatedIgnoreFiles, warnings };
}

/**
 * Migrates project-local plugin state without overwriting an existing target.
 * All failures are returned as data so plugin initialization can continue.
 */
export async function migrateProjectStateDirectory(
  projectDirectory: string,
): Promise<ProjectStateMigrationResult> {
  const legacyPath = path.join(projectDirectory, LEGACY_PROJECT_STATE_DIR);
  const targetPath = path.join(projectDirectory, PROJECT_STATE_DIR);

  try {
    const [legacyKind, targetKind] = await Promise.all([
      getPathKind(legacyPath),
      getPathKind(targetPath),
    ]);

    if (legacyKind === 'other') {
      return {
        status: 'failed',
        updatedIgnoreFiles: [],
        warnings: [`${legacyPath} exists but is not a directory.`],
      };
    }

    if (legacyKind === 'directory' && targetKind !== 'missing') {
      return {
        status: 'conflict',
        updatedIgnoreFiles: [],
        warnings: [
          `Both ${legacyPath} and ${targetPath} exist; migration was skipped.`,
        ],
      };
    }

    let status: MigrationStatus = 'not-needed';
    if (legacyKind === 'directory') {
      await rename(legacyPath, targetPath);
      status = 'migrated';
    }

    const ignoreResult = await updateIgnoreFiles(projectDirectory);
    return {
      status,
      updatedIgnoreFiles: ignoreResult.updatedIgnoreFiles,
      warnings: ignoreResult.warnings,
    };
  } catch (error) {
    return {
      status: 'failed',
      updatedIgnoreFiles: [],
      warnings: [`Project state migration failed: ${errorMessage(error)}`],
    };
  }
}
