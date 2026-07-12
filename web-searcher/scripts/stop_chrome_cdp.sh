#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-9222}"

if [[ ! "$PORT" =~ ^[0-9]+$ ]] || ((PORT < 1 || PORT > 65535)); then
  echo "PORT must be an integer between 1 and 65535: $PORT" >&2
  exit 1
fi

if [[ "${OSTYPE:-}" == msys* || "${OSTYPE:-}" == cygwin* ]]; then
  CHROME_CDP_STOP_PORT="$PORT" powershell.exe -NoProfile -NonInteractive -Command '
    $ErrorActionPreference = "Stop"
    $port = [int]$env:CHROME_CDP_STOP_PORT
    $argumentPattern = "--remote-debugging-port=" + $port + "(?:\s|$)"
    $processes = @(
      Get-CimInstance Win32_Process |
        Where-Object {
          $_.Name -eq "chrome.exe" -and
          $_.CommandLine -match $argumentPattern
        }
    )

    if ($processes.Count -eq 0) {
      Write-Output "Chrome CDP is not running on http://127.0.0.1:$port"
      exit 0
    }

    foreach ($process in $processes) {
      Stop-Process -Id $process.ProcessId -Force -ErrorAction SilentlyContinue
    }
    Write-Output "Stopped Chrome CDP on http://127.0.0.1:$port"
  '
  exit $?
fi

if ! command -v pgrep >/dev/null 2>&1; then
  echo "pgrep is required to locate Chrome CDP processes." >&2
  exit 1
fi

PIDS="$(pgrep -f "(^|[[:space:]])--remote-debugging-port=${PORT}([[:space:]]|$)" || true)"
if [[ -z "$PIDS" ]]; then
  echo "Chrome CDP is not running on http://127.0.0.1:$PORT"
  exit 0
fi

while IFS= read -r pid; do
  [[ -n "$pid" ]] && kill "$pid" 2>/dev/null || true
done <<<"$PIDS"

for _ in {1..50}; do
  RUNNING=0
  while IFS= read -r pid; do
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      RUNNING=1
      break
    fi
  done <<<"$PIDS"
  [[ "$RUNNING" == "0" ]] && break
  sleep 0.1
done

while IFS= read -r pid; do
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    kill -KILL "$pid" 2>/dev/null || true
  fi
done <<<"$PIDS"

echo "Stopped Chrome CDP on http://127.0.0.1:$PORT"
