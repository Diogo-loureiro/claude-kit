# Changelog

## Unreleased (global layer, live via git pull)
- `remoteControlAtStartup: true` in global settings: every session is reachable from the Claude mobile app.
- `cloud/setup.sh`: cloud environment setup script that installs the global CLAUDE.md and skills in cloud sessions.
- `syncClaudeAiSkills: false` in global settings: claude.ai-synced skills (docx, pptx, morning…, ~2.4k
  tokens of descriptions per session) stop loading in Claude Code; claude.ai is unaffected. Want them
  back? Set it to `true` in `~/.claude/settings.json` (install.sh never overwrites your values).
- `/receita-visual` global skill: the "vidro e grafite" visual recipe (by a colleague, kept verbatim in
  Portuguese) with its `exemplo.html` reference page. Manual-only (`disable-model-invocation`); point a
  project's CLAUDE.md at it for UI work.

## v0.1.5 (2026-11-01)
- CI `security` job, report-only: OSV-Scanner (known vulnerabilities in lockfiles) and Semgrep CE
  (code) write their findings to the job summary and never fail the build (#6).
- `.github/dependabot.yml` (project-owned): weekly grouped updates with a 7-day release cooldown.
  New projects get it; existing ones get it on the next `copier update`.
- kit-update requires `KIT_TOKEN` and fails early with instructions; `scripts/set-kit-token.sh`
  sets it on every project (#7). With the token, the update PR triggers CI and works even where
  Actions may not open PRs.
- No empty `src/` when `stack=none` (#4).
- Template smoke tests are self-contained (py: `importorskip` of the package; ts: optional import of
  `src/index`). Copier re-creates them on every update when a project deletes them, so they must pass
  anywhere; projects that keep them just get the new content (#10).

## v0.1.4 (2026-10-31)
- Stop hook runs only the tests affected by the change (pytest-testmon, added to py dev deps);
  `scripts/check ci` still runs the whole suite (#1). Existing py projects: `uv add --dev pytest-testmon`.
- ruff.toml: no fixed `target-version` (inferred from `requires-python`, so 3.11 projects don't get
  3.12-only autofixes); `PLC0415` (import outside top level) ignored.
- README: adoption steps for existing projects, with a `noqa` lint baseline (#5).

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
