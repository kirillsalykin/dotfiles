#!/usr/bin/env bash
set -euo pipefail

MAX_ITERS="${1:-50}"
SIGNAL="signal.txt"

if [[ ! -f plan.json ]]; then
  echo "Missing plan.json"
  echo "Run plan first."
  exit 1
fi

touch progress.txt
rm -f "$SIGNAL"

echo "== Autonomous execution started =="

for ((i=1;i<=MAX_ITERS;i++)); do
  echo
  echo "== iteration $i =="

  codex exec \
    --full-auto \
    --output-last-message "$SIGNAL" \
    <<'PROMPT'
execute the plan
use plain-text status signal protocol:
- first non-empty line must be COMPLETE when all tasks are done
- first non-empty line must be INTERRUPTED when blocked/unclear
PROMPT

  ########################################
  # stop condition
  ########################################
  # Canonical protocol: first non-empty line in signal.txt is COMPLETE or INTERRUPTED.
  signal_value="$(grep -m1 -E '[^[:space:]]' "$SIGNAL" | tr -d '\r' | tr '[:lower:]' '[:upper:]' || true)"

  if [[ "$signal_value" == "COMPLETE" ]]; then
    echo
    echo "== PROJECT COMPLETE =="
    exit 0
  fi

  if [[ "$signal_value" == "INTERRUPTED" ]]; then
    echo
    echo "== EXECUTION INTERRUPTED =="
    exit 130
  fi
done

echo
echo "Stopped after $MAX_ITERS iterations"
