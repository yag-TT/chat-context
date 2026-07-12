#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

export CHROME_HEADLESS=1
exec "$SCRIPT_DIR/start_chrome_cdp.sh" "$@"
