#!/usr/bin/env bash
# PostToolUse hook (Edit|Write|MultiEdit): formats and autofixes only the edited file.
# Never blocks and prints nothing: remaining problems are the Stop hook's job.
file="$(python3 -I -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))' 2>/dev/null)"
[ -n "$file" ] && "${CLAUDE_PROJECT_DIR:-.}/scripts/check" fast "$file"
exit 0
