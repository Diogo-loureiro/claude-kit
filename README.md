# claude-kit

Personal framework for agentic development with Claude Code: one agent per task, minimal
context, and **deterministic checks** instead of human code review.
Day-to-day workflow: [PLAYBOOK.md](PLAYBOOK.md). Why each choice was made:
[docs/rationale-2026-10.md](docs/rationale-2026-10.md) (research notes in [docs/research/](docs/research/);
both are an archived October 2026 record, written in Portuguese).

## Layers and how each one reaches projects

| Layer | Where | Propagation |
|---|---|---|
| Global rules + `/spec`, `/ship` and `/receita-visual` skills | `global/` → symlinks in `~/.claude` | `git pull` in the kit (immediate) |
| Hooks, `scripts/check`, lint, project CI | `template/` (Copier) | automatic weekly PR (`kit-update`) in each project |
| Tests for the kit itself | `.github/workflows/kit-ci.yml`, `tests/` | every push |

`scripts/check` is the single source of checks: the agent hooks, the pre-commit hook and CI all call the same script.

## Install (once per machine)

```bash
uv tool install copier
git clone https://github.com/Diogo-loureiro/claude-kit ~/Projetos/claude-kit
~/Projetos/claude-kit/install.sh
```

## Phone and cloud

- **Remote Control** (steer local sessions from the Claude mobile app): `install.sh` sets
  `remoteControlAtStartup: true`, so every interactive session shows up in the app's **Code** tab.
  Your computer must stay on; the session runs locally.
- **Cloud sessions** (run on Anthropic's VMs, computer can be off): they clone the repo, so project
  hooks and `CLAUDE.md` work, but they never see your `~/.claude`. In claude.ai/code, edit your cloud
  environment and set its **Setup script** to:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/Diogo-loureiro/claude-kit/main/cloud/setup.sh | bash
  ```
  That installs the global `CLAUDE.md` and skills. The environment cache keeps it ~7 days; edit the
  script to refresh sooner. When adding a global skill, add it to `cloud/setup.sh` too (kit-ci checks).

## New project

```bash
copier copy --trust gh:Diogo-loureiro/claude-kit ~/Projetos/my-project   # asks for name and stack
cd ~/Projetos/my-project
git add -A && git commit -m "chore: scaffold from claude-kit"
gh repo create my-project --private --source . --push
```
First session in the project: ask Claude to fill in `CLAUDE.md` (domain rules). If the stack is still
undecided, switch later with `copier update --trust -d stack=py` (or `ts`).
Once the stack is set, install the LSP: `/plugin install pyright-lsp@claude-plugins-official` (or `typescript-lsp`).

## Existing project

```bash
cd project && copier copy --trust gh:Diogo-loureiro/claude-kit .   # project-owned files are not overwritten
```
Legacy code will likely fail the first `scripts/check ci`; see issue #5 (baseline).

## Improving the kit (and shipping it to every project)

1. Change it here, never directly in a project. Kit files are locked for the agent inside projects.
2. If the change affects agent behavior, run the evals (`evals/`) first and compare cost and accuracy.
3. Update `CHANGELOG.md`, commit, `git tag vX.Y.Z && git push --tags`. `kit-ci` must be green.
4. The following Monday each project gets a PR `chore: update claude-kit to vX.Y.Z`
   (or run it now: Actions tab → kit-update → Run workflow). Green CI → merge.
   Updates that touch `.github/workflows/` need the `KIT_TOKEN` secret (issue #7).

Versions: patch/minor = compatible change; major = requires action in the project (explain it in the CHANGELOG).
With every new model generation, run the evals and **remove** what no longer makes a difference.

## Who owns each file

- **Kit-owned** (updated by `copier update`; locked for the agent): `.claude/settings.json`,
  `scripts/check`, `scripts/agent/*`, `.githooks/*`, `.github/workflows/*`, `ruff.toml`, `biome.json`.
- **Project-owned** (created once, never overwritten): `CLAUDE.md`, `README.md`, `pyproject.toml`,
  `package.json`, `tsconfig.json`, `src/`, `tests/`, `docs/`, `scripts/check.d/*.sh`.

## Language

Files are written in English (code, docs, commits, PRs). Conversations with Claude happen in
Brazilian Portuguese (set in `global/CLAUDE.md`). Verbatim domain inputs, such as bank notification
texts, stay in their original language.
