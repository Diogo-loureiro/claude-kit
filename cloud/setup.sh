#!/usr/bin/env bash
# Cloud environment setup script: installs the claude-kit global layer (~/.claude/CLAUDE.md and
# skills) in Claude Code cloud sessions, which never see your local ~/.claude.
# Paste this line into claude.ai/code -> cloud environment -> Setup script:
#   curl -fsSL https://raw.githubusercontent.com/Diogo-loureiro/claude-kit/main/cloud/setup.sh | bash
# The environment cache keeps the result for about 7 days, so kit changes reach the cloud within a
# week. To refresh sooner, edit the environment's setup script (any change rebuilds the cache).
set -euo pipefail

raw="${KIT_RAW:-https://raw.githubusercontent.com/Diogo-loureiro/claude-kit/main}"
skills="spec ship receita-visual" # keep in sync with global/skills/ (kit-ci checks it)
extras="receita-visual/exemplo.html" # skill files besides SKILL.md

mkdir -p "$HOME/.claude"
curl -fsSL "$raw/global/CLAUDE.md" -o "$HOME/.claude/CLAUDE.md"
for skill in $skills; do
  mkdir -p "$HOME/.claude/skills/$skill"
  curl -fsSL "$raw/global/skills/$skill/SKILL.md" -o "$HOME/.claude/skills/$skill/SKILL.md"
done
for file in $extras; do
  curl -fsSL "$raw/global/skills/$file" -o "$HOME/.claude/skills/$file"
done
echo "claude-kit global layer installed: CLAUDE.md + skills ($skills)"
