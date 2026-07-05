#!/usr/bin/env bash
set -euo pipefail

PROJECT="D:/work/Test/Flutter/mvvm"
OUTPUT=""
FULL=0

usage() {
  cat <<'EOF'
Usage: scripts/pack-foldermix.sh [OPTIONS]

Generate a Gemini-friendly Markdown context file with foldermix.

Options:
  -p, --project PATH   Project directory to pack.
                      Default: D:/work/Test/Flutter/mvvm
  -o, --output PATH    Output Markdown path.
                      Default: <project>/foldermix-context.md
  --full              Use foldermix's default scan instead of Flutter-focused include globs.
  -h, --help          Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--project)
      PROJECT="${2:?Missing value for $1}"
      shift 2
      ;;
    -o|--output)
      OUTPUT="${2:?Missing value for $1}"
      shift 2
      ;;
    --full)
      FULL=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

export PYTHONUTF8=1

if [[ ! -d "$PROJECT" ]]; then
  echo "Project directory does not exist: $PROJECT" >&2
  exit 1
fi

if [[ -z "$OUTPUT" ]]; then
  OUTPUT="${PROJECT%/}/foldermix-context.md"
fi

if [[ "$OUTPUT" == *.md ]]; then
  REPORT="${OUTPUT%.md}.report.json"
else
  REPORT="${OUTPUT}.report.json"
fi

args=(
  run
  foldermix
  pack
  "$PROJECT"
  --out
  "$OUTPUT"
  --report
  "$REPORT"
  --continue-on-error
  --include-skipped-files
)

if [[ "$FULL" -eq 0 ]]; then
  include_globs=(
    "docs/**"
    "AI_CONTEXT.md"
    "mobile_app/AI_CONTEXT.md"
    "mobile_app/README.md"
    "mobile_app/pubspec.yaml"
    "mobile_app/pubspec.lock"
    "mobile_app/analysis_options.yaml"
    "mobile_app/.gitignore"
    "mobile_app/lib/**"
    "mobile_app/test/**"
    "mobile_app/web/**"
    "mobile_app/android/build.gradle.kts"
    "mobile_app/android/settings.gradle.kts"
    "mobile_app/android/gradle.properties"
    "mobile_app/android/app/build.gradle.kts"
    "mobile_app/android/app/src/**"
    "mobile_app/ios/Runner/**"
    "mobile_app/ios/Podfile"
  )

  for glob in "${include_globs[@]}"; do
    args+=(--include-glob "$glob")
  done
fi

uv "${args[@]}"

printf '\nGenerated context:\n%s\n\nGenerated report:\n%s\n' "$OUTPUT" "$REPORT"
