#!/usr/bin/env bash
# PreToolUse hook (Edit|Write|MultiEdit|NotebookEdit): keeps the agent away from files only a
# human or the kit may change. Exit 2 blocks the edit and sends stderr back to Claude.
# Human override for one session: KIT_UNLOCK=1 claude
[ "${KIT_UNLOCK:-}" = 1 ] && exit 0

file="$(python3 -I -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))' 2>/dev/null)"
[ -z "$file" ] && exit 0
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
rel="${file#"$root"/}"

deny() {
  echo "Blocked: $rel $1. Do not work around this (no sed/echo/cp via Bash): stop and tell the human." >&2
  exit 2
}

case "$rel" in
  .env.example) ;;
  .env | .env.* | */.env | */.env.*) deny "may hold secrets" ;;
  .claude/settings.json | .githooks/* | scripts/agent/* | scripts/check | .github/workflows/* | .copier-answers.yml)
    deny "is part of the harness (change it in claude-kit)" ;;
  biome.json | ruff.toml) deny "is lint config: fix the code, not the rule" ;;
  package-lock.json | pnpm-lock.yaml | uv.lock | */package-lock.json | */pnpm-lock.yaml | */uv.lock)
    deny "is a lockfile: use the package manager" ;;
  tests/acceptance/*)
    # Drafting new acceptance tests is fine; once committed they are approved and locked.
    if git -C "$root" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1; then
      deny "is an approved acceptance test (committed = locked)"
    fi
    ;;
esac
exit 0
