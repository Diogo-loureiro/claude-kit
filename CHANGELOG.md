# Changelog

## Unreleased (global layer, live via git pull)
- `remoteControlAtStartup: true` in global settings: every session is reachable from the Claude mobile app.
- `cloud/setup.sh`: cloud environment setup script that installs the global CLAUDE.md and skills in cloud sessions.

## v0.1.3 (2026-10-31)
- Everything written to files is now in English (docs, skills, template, messages). Conversations
  stay in Brazilian Portuguese. `docs/rationale-2026-10.md` and `docs/research/` remain an archived
  Portuguese record.
- `/ship` PR body gains "How to validate by running it"; PLAYBOOK adds "validate by running it",
  one-session-per-area/worktrees, and Anthropic's workflow-patterns checklist.

## v0.1.2 (2026-10-31)
- Template CI: gitleaks installed directly and run by `scripts/check ci` (mandatory in CI).
  `gitleaks-action` failed on the first push of a new repository (root commit has no parent).

## v0.1.1 (2026-10-31)
- ts template: Biome restricted to `src/` and `tests/` (newer versions also format Markdown and broke CI).

## v0.1.0 (2026-10-31)
- Global layer: CLAUDE.md (Karpathy-style rules adapted to autonomous mode), secret deny rules,
  `/spec` and `/ship` skills, `install.sh` (symlinks + settings merge that never overwrites your values).
- Copier template (stack `none | py | ts`): `scripts/check fast|stop|ci`, PreToolUse (guard),
  PostToolUse (format) and Stop hooks (gate with at most 3 consecutive blocks), pre-commit, CI with
  gitleaks and `harness-approved` / `deps-approved` gates, weekly `kit-update` workflow.
- `kit-ci`: shellcheck + project generation per stack + hook behavior tests.
