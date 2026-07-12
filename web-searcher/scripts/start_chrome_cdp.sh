#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-9222}"
USER_DATA_DIR="${USER_DATA_DIR:-}"

if [[ -z "$USER_DATA_DIR" ]]; then
  if [[ "${OSTYPE:-}" == msys* || "${OSTYPE:-}" == cygwin* ]]; then
    if [[ -n "${LOCALAPPDATA:-}" ]] && command -v cygpath >/dev/null 2>&1; then
      LOCAL_APP_DATA_DIR="$(cygpath -u "$LOCALAPPDATA")"
    else
      LOCAL_APP_DATA_DIR="$HOME/AppData/Local"
    fi
    USER_DATA_DIR="$LOCAL_APP_DATA_DIR/ChromeGeminiMcp/User Data"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    USER_DATA_DIR="$HOME/Library/Application Support/ChromeGeminiMcp/User Data"
  else
    USER_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/chrome-gemini-mcp/user-data"
  fi
fi

find_chrome() {
  if [[ -n "${CHROME_PATH:-}" ]]; then
    printf '%s\n' "$CHROME_PATH"
    return 0
  fi

  local candidates=(
    "/c/Program Files/Google/Chrome/Application/chrome.exe"
    "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    "/usr/bin/google-chrome"
    "/usr/bin/google-chrome-stable"
    "/usr/bin/chromium"
    "/usr/bin/chromium-browser"
  )

  local candidate
  for candidate in "${candidates[@]}"; do
    if [[ -x "$candidate" || -f "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  if command -v google-chrome >/dev/null 2>&1; then
    command -v google-chrome
    return 0
  fi
  if command -v google-chrome-stable >/dev/null 2>&1; then
    command -v google-chrome-stable
    return 0
  fi
  if command -v chromium >/dev/null 2>&1; then
    command -v chromium
    return 0
  fi

  return 1
}

CHROME_BIN="$(find_chrome || true)"
if [[ -z "$CHROME_BIN" ]]; then
  cat >&2 <<'EOF'
Chrome executable was not found.
Set CHROME_PATH explicitly, for example:
  CHROME_PATH="/c/Program Files/Google/Chrome/Application/chrome.exe" ./scripts/start_chrome_cdp.sh
EOF
  exit 1
fi

mkdir -p "$USER_DATA_DIR"
CHROME_LOG_FILE="${CHROME_LOG_FILE:-/dev/null}"

CHROME_ARGS=(
  --remote-debugging-port="$PORT"
  --remote-debugging-address=127.0.0.1
  --user-data-dir="$USER_DATA_DIR"
)

if [[ "${CHROME_HEADLESS:-0}" == "1" ]]; then
  CHROME_ARGS+=(--headless=new)
fi

"$CHROME_BIN" \
  "${CHROME_ARGS[@]}" \
  "https://gemini.google.com/" \
  </dev/null >"$CHROME_LOG_FILE" 2>&1 &
CHROME_PID=$!

CDP_URL="http://127.0.0.1:$PORT/json/version"
for _ in {1..30}; do
  if curl --fail --silent "$CDP_URL" >/dev/null 2>&1; then
    echo "Started Chrome with CDP on http://127.0.0.1:$PORT"
    if [[ "${CHROME_HEADLESS:-0}" == "1" ]]; then
      echo "Chrome mode: headless (no UI)"
    else
      echo "Chrome mode: headed"
    fi
    echo "Chrome executable: $CHROME_BIN"
    echo "Profile directory: $USER_DATA_DIR"
    if [[ "$CHROME_LOG_FILE" != "/dev/null" ]]; then
      echo "Chrome log: $CHROME_LOG_FILE"
    fi
    echo "Verify with: curl $CDP_URL"
    exit 0
  fi
  sleep 1
done

cat >&2 <<EOF
Chrome was launched, but CDP did not become reachable at $CDP_URL.
Check whether the port is already in use or Chrome failed to start.
Chrome executable: $CHROME_BIN
Profile directory: $USER_DATA_DIR
EOF

if kill -0 "$CHROME_PID" >/dev/null 2>&1; then
  kill "$CHROME_PID" >/dev/null 2>&1 || true
fi
exit 1
