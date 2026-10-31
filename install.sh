#!/usr/bin/env bash
# Installs the global layer of claude-kit into ~/.claude. Idempotent: re-run after `git pull`
# when the kit adds a new skill. Edits to existing files need no re-run (they are symlinks).
set -euo pipefail

kit="$(cd "$(dirname "$0")" && pwd)"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$dest/skills"

link() { # link SRC DST - symlink, backing up a real file the first time
  if [ -e "$2" ] && [ ! -L "$2" ]; then
    mv "$2" "$2.bak.$(date +%Y%m%d%H%M%S)"
    echo "backup: $2"
  fi
  ln -sfn "$1" "$2"
  echo "link:   $2 -> $1"
}

link "$kit/global/CLAUDE.md" "$dest/CLAUDE.md"
for skill in "$kit"/global/skills/*/; do
  link "${skill%/}" "$dest/skills/$(basename "$skill")"
done

# Claude Code writes to settings.json itself, so it is merged rather than symlinked:
# lists are unioned and values you already set are never overwritten.
python3 -I - "$kit/global/settings.json" "$dest/settings.json" <<'PY'
import json, pathlib, sys

src, dst = map(pathlib.Path, sys.argv[1:])
kit = json.loads(src.read_text())
cur = json.loads(dst.read_text()) if dst.exists() else {}

def merge(a, b):
    for k, v in b.items():
        if isinstance(v, dict):
            merge(a.setdefault(k, {}), v)
        elif isinstance(v, list):
            a[k] = a.get(k, []) + [x for x in v if x not in a.get(k, [])]
        else:
            a.setdefault(k, v)
    return a

dst.write_text(json.dumps(merge(cur, kit), indent=2) + "\n")
PY
echo "merge:  $dest/settings.json"
