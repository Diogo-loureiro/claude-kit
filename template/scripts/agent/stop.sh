#!/usr/bin/env bash
# Stop hook: Claude can't end its turn while `scripts/check stop` fails (exit 2 sends the
# failure back to it). After 3 blocks in a row it lets the turn end and warns you instead,
# so a question to you mid-task can't turn into an endless fix loop.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

input="$(cat)"
field() { printf '%s' "$input" | python3 -I -c "import json,sys; print(json.load(sys.stdin).get('$1', ''))" 2>/dev/null; }
counter="${TMPDIR:-/tmp}/claude-stop-$(field session_id)"
[ "$(field stop_hook_active)" = True ] || rm -f "$counter"

# Nothing changed: nothing to verify.
[ -z "$(git status --porcelain 2>/dev/null)" ] && exit 0

if out="$(scripts/check stop 2>&1)"; then
  rm -f "$counter"
  exit 0
fi

n=$(($(cat "$counter" 2>/dev/null || echo 0) + 1))
echo "$n" >"$counter"
if [ "$n" -gt 3 ]; then
  rm -f "$counter"
  printf '{"systemMessage": "scripts/check stop still fails after 3 attempts; turn released so you can decide."}\n'
  exit 0
fi
printf 'scripts/check stop is failing. Fix it before finishing, or explain what blocks you:\n%s\n' "$out" >&2
exit 2
