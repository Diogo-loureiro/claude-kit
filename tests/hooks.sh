#!/usr/bin/env bash
# Behaviour tests for the agent hooks, run against a project generated from the template.
# Usage: tests/hooks.sh GENERATED_PROJECT_DIR
set -uo pipefail
cd "$1" || exit 1
export CLAUDE_PROJECT_DIR="$PWD"
fails=0

expect() { # expect EXIT_CODE DESCRIPTION CMD...
  local want="$1" desc="$2"
  shift 2
  "$@" >/dev/null 2>&1
  local got=$?
  if [ "$got" -eq "$want" ]; then echo "ok   $desc"; else echo "FAIL $desc (exit $got, want $want)"; fails=1; fi
}
# shellcheck disable=SC2329  # edit/stop are invoked indirectly through expect
edit() { printf '{"tool_input":{"file_path":"%s"}}' "$PWD/$1" | scripts/agent/guard.sh; }
# shellcheck disable=SC2329
stop() { printf '{"session_id":"t","stop_hook_active":%s}' "$1" | scripts/agent/stop.sh; }

expect 2 "guard blocks .env" edit .env
expect 0 "guard allows .env.example" edit .env.example
expect 2 "guard blocks scripts/check" edit scripts/check
expect 2 "guard blocks CI workflows" edit .github/workflows/ci.yml
expect 0 "guard allows source files" edit src/app.py
expect 0 "guard allows drafting a new acceptance test" edit tests/acceptance/test_new.py
expect 2 "guard blocks a committed acceptance test" edit tests/acceptance/README.md
expect 0 "KIT_UNLOCK overrides guard" env KIT_UNLOCK=1 bash -c "$(declare -f edit); edit .env"

expect 0 "stop passes on a clean tree" stop false
seq 900 >big.py
expect 1 "check stop fails on an 800+ line file" scripts/check stop
expect 2 "stop blocks while checks fail" stop false
expect 2 "stop blocks again (2nd)" stop true
expect 2 "stop blocks again (3rd)" stop true
expect 0 "stop gives up after 3 blocks" stop true
rm big.py
expect 0 "check stop passes again" scripts/check stop

exit $fails
