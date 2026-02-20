#!/usr/bin/env bash
set -euo pipefail

MAX_ITERS="${1:-50}"
LAST=".last.txt"

if [[ ! -f plan.json ]]; then
  echo "Missing plan.json"
  echo "Run planner first."
  exit 1
fi

touch progress.txt
rm -f "$LAST"

echo "== Autonomous execution started =="

for ((i=1;i<=MAX_ITERS;i++)); do
  echo
  echo "== iteration $i =="

  codex exec \
    --full-auto \
    --output-last-message "$LAST" \
    <<'PROMPT'
execute the plan
PROMPT

  ########################################
  # stop condition
  ########################################
  if grep -q "<promise>COMPLETE</promise>" "$LAST"; then
    echo
    echo "== PROJECT COMPLETE =="
    exit 0
  fi
done

echo
echo "Stopped after $MAX_ITERS iterations"
