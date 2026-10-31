# Distribuição multiprojeto de um framework agêntico (Claude Code + tooling de qualidade) para dev solo

Research date: 2026-10-31. Claude Code docs were checked live at code.claude.com. They cite builds around v2.1.2xx–v2.1.31x.

## 1. Claude Code layers: what lives at user level, project level and managed level, and how they combine

### Takeaway
CLAUDE.md files and rules are **additive**: every level loads at once and nothing overrides anything. Settings follow a **precedence stack** (managed > CLI > local > project > user), and their lists merge. Skills and subagents **override by name**, but the two use different orders. Hooks **all fire**. So the user level (`~/.claude/`) is for what is truly universal and personal. The project level (`.claude/` committed in each repo) is for what the repo needs in order to be reproducible.

### Cited Findings
- Memory levels: Managed (`/etc/claude-code/CLAUDE.md` on Linux/WSL), User (`~/.claude/CLAUDE.md`, "Personal preferences for all projects"), Project (`./CLAUDE.md` or `./.claude/CLAUDE.md`, shared via git), plus `CLAUDE.local.md`. — [Claude Code: Memory](https://code.claude.com/docs/en/memory)
- CLAUDE.md files in the directory hierarchy **above** the cwd load at launch. Files in subdirectories load on demand, when Claude reads or edits a file in that subdirectory. — [Memory](https://code.claude.com/docs/en/memory)
- Recommended size: "target under 200 lines per CLAUDE.md file. Longer files consume more context and reduce adherence." Imports "help you organize a long file but don't reduce its context cost, because imported files load together with the CLAUDE.md that imports them." — [Memory](https://code.claude.com/docs/en/memory)
- `@path` imports: relative paths resolve against the file that contains the import. Imports can be recursive, "with a maximum depth of four hops". Paths with spaces need a backslash before each space, and a quoted path is not imported. Imports inside code spans and fences are ignored. — [Memory](https://code.claude.com/docs/en/memory)
- An import in a project memory file that points **outside** the working directory (e.g. `@~/.claude/x.md`) triggers a one-time approval dialog per project. If you decline, it stays disabled. Imports in user-scope files (`~/.claude/CLAUDE.md`, `~/.claude/rules/`) load without the dialog. — [Memory](https://code.claude.com/docs/en/memory)
- Block-level HTML comments (`<!-- -->`) in CLAUDE.md are stripped before injection, so they cost zero tokens. — [Memory](https://code.claude.com/docs/en/memory)
- `.claude/rules/*.md` are discovered recursively. A rule without `paths` loads at launch with the same priority as `.claude/CLAUDE.md`. A rule with `paths:` frontmatter (globs) loads only when Claude reads, writes or edits a matching file. — [Memory](https://code.claude.com/docs/en/memory)
- `~/.claude/rules/` holds user-level rules that apply to every project. They load before project rules, and "Neither set overrides the other: if a user rule and a project rule conflict, Claude may follow either one". — [Memory](https://code.claude.com/docs/en/memory)
- Symlinks in `.claude/rules/` are supported, e.g. `ln -s ~/shared-claude-rules .claude/rules/shared`. A target outside the cwd is treated as an external import, which needs approval. After approval, **only rules without `paths`** load. — [Memory](https://code.claude.com/docs/en/memory)
- AGENTS.md: Claude Code reads `AGENTS.md` natively (v2.1.277+) when there is no CLAUDE.md in the cwd or above it. `~/.claude/CLAUDE.md` and `.claude/rules/` "don't count" for that check and keep loading alongside AGENTS.md. A `claude-md-and-agents-md` setting exists to load both. — [Memory](https://code.claude.com/docs/en/memory)
- Settings files: User `~/.claude/settings.json`, Shared project `.claude/settings.json` (commit it), Project local `.claude/settings.local.json` (Claude Code adds it to the global git excludes), and Managed. — [Settings](https://code.claude.com/docs/en/settings)
- Precedence, highest first: Managed > `--settings` CLI > project local > shared project > user. "Lists merge instead of overriding" (e.g. `permissions.allow`). — [Settings](https://code.claude.com/docs/en/settings)
- Committed keys that wait for workspace trust: `permissions.allow`, `additionalDirectories`, `extraKnownMarketplaces`, and most `env`. `deny`/`ask` apply immediately. `permissions.defaultMode` values `auto`/`bypassPermissions` do **not** take effect from project or local settings. — [Settings](https://code.claude.com/docs/en/settings)
- Skills: Personal `~/.claude/skills/<name>/SKILL.md`, Project `.claude/skills/`, Nested `<subdir>/.claude/skills/`, Plugin `<plugin>/skills/` (namespaced `/plugin:skill`). On a name conflict: "Enterprise over personal, and personal over project". A skill beats a file in `.claude/commands/`. Plugin skills always coexist because they are namespaced. — [Skills](https://code.claude.com/docs/en/skills)
- Commands were merged into skills: `.claude/commands/deploy.md` and `.claude/skills/deploy/SKILL.md` "both create `/deploy`". Skills are preferred for new work. — [Skills](https://code.claude.com/docs/en/skills)
- Precedence by layer: "managed > user > project for skills; managed > CLI flag > project > user > plugin for subagents". MCP: local > project > user. "Hooks merge: all registered hooks fire for their matching events regardless of source." — [Extend Claude Code (features overview)](https://code.claude.com/docs/en/features-overview)
- `settings.json` has a `$schema` (`https://json.schemastore.org/claude-code-settings.json`) and is strict JSON, so comments and trailing commas are errors. — [Settings](https://code.claude.com/docs/en/settings)
- Cloud sessions do not read `~/.claude/settings.json` or `settings.local.json`. Only the committed `.claude/settings.json` (and server-managed settings) applies. — [Settings](https://code.claude.com/docs/en/settings)

### Inferences
- **Pitfall:** a personal skill **wins** over a project skill with the same name. A subagent works the other way: the project one wins over the user one. Avoid identical names between the global layer and the repo. Use a plugin, which is namespaced, for shared skills.
- **User level (`~/.claude/`):** short personal CLAUDE.md (style, language, "always run tests before saying done"). Generic `rules/` without `paths`. Universal workflow skills (commit, review, research). Personal read-only `permissions.allow`/`deny` (e.g. deny on `.env`). Language-agnostic security hooks.
- **Project level (`.claude/` committed):** the repo's build/test/lint commands in CLAUDE.md. Rules with `paths` per stack (e.g. `paths: ["**/*.py"]`). `settings.json` with permissions, `enabledPlugins`/`extraKnownMarketplaces`, and the repo-specific formatter/lint hooks. Commit it because cloud sessions, CI and other machines don't see `~/.claude`.
- Global CLAUDE.md and rules without `paths` are paid in tokens on **every request of every project**. Keep the global CLAUDE.md minimal (<50–80 lines). Push stack-specific content into rules with `paths` or into skills.

### Gaps
- Docs mention a "per-file size limit" for nested CLAUDE.md without the number appearing in the excerpt I read.

## 2. Personal plugin + private marketplace (git repo)

### Takeaway
A plugin is the official packaging unit for **skills, agents, hooks, commands, MCP, LSP, output styles, monitors and bin/**. Plugins **cannot carry CLAUDE.md, rules or permissions**: plugin `settings.json` accepts only `agent` and `subagentStatusLine`. A private marketplace is just a git repo with `.claude-plugin/marketplace.json`. Background auto-update is **off by default** for third-party marketplaces. Updates arrive only when the computed `version` changes, so either bump `version` or omit it entirely to track commits.

### Cited Findings
- A marketplace is "a directory or repository with a `.claude-plugin/marketplace.json`". It needs `name`, `owner` and `plugins[]`, and each entry needs `name` + `source`. Relative paths are written from the marketplace root, and `..` is forbidden. Validate with `claude plugin validate ./my-marketplace`. — [Create a marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- Flow: `claude plugin marketplace add ./my-marketplace` (or `/plugin marketplace add owner/repo`), then `claude plugin install my-plugin@my-marketplace` (default scope: user). Check with `claude plugin list` and `claude plugin details`. — [Create a marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- Source types: relative path, `github`, `git-subdir` (monorepo), `url` (any git host), `archive` (zip HTTPS), `npm`, `command`. Git sources can be pinned with `ref`/`sha`. — [Create a marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- Local marketplace (added from a path): plugins with a relative-path source are read **in place**. Edits apply at the next session or after `/reload-plugins` with no version bump. Hosted installs go to a copy in the plugin cache. — [Create a marketplace](https://code.claude.com/docs/en/plugin-marketplaces); [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- `#<ref>` pins a branch or tag of the marketplace: `your-org/your-marketplace#stable`. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace). Note: a third-party repo claims the CLI "has no version or ref pin" ([search summary of a dotfiles repo](https://github.com/Boulede987/dotfiles-claude)). That claim **conflicts with the official docs** and is probably out of date.
- Per repo: `claude plugin marketplace add owner/repo --scope project` writes `.claude/settings.json`. Commit it, and each collaborator gets the marketplace after trusting the folder. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- Private repo: Claude Code uses the machine's git credentials non-interactively. It has no token of its own, and `marketplace.json` has no token field. For `owner/repo` it probes SSH and falls back to HTTPS. `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` skips the probe. `gh auth login` + `gh auth setup-git` is recommended. `GITHUB_TOKEN` alone does not authenticate the background check unless a credential helper reads it. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- Auto-update: "Background auto-update is off for your marketplace by default, and `marketplace.json` has no field to turn it on." The user turns it on in `/plugin` → Marketplaces → Enable auto-update, or an admin sets `"autoUpdate": true` on `extraKnownMarketplaces` in managed settings. Without it: `/plugin marketplace update <name>` or `claude plugin update <plugin>@<name>`. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- Versioning: "If you set `"version": "1.0.0"` and push new commits without changing it, users don't receive them." Omitting `version` (in both plugin.json and the entry) makes users track commits. Don't set it in both places, because plugin.json wins silently. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1` keeps the last checkout if the background check fails. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- Renames: the `renames` map in marketplace.json migrates `enabledPlugins` automatically. `forceRemoveDeletedPlugins: true` uninstalls removed plugins. Release channels mean two marketplaces with different names pointing at different refs. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- Symlinks: a symlink inside the plugin is kept. A symlink to elsewhere in the marketplace is dereferenced (copied). A symlink outside the marketplace is skipped. Git LFS files arrive as pointers, so avoid LFS. — [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- Components: skills, commands (legacy), agents, `hooks/hooks.json`, `.mcp.json`, `.lsp.json`, output-styles, themes, workflows, monitors, `bin/` (on PATH), channels. — [Plugin components](https://code.claude.com/docs/en/plugins/components)
- "Claude Code doesn't load a `CLAUDE.md` at the plugin root". Write instructions as a skill, and write a rule that must always hold as a hook. Plugin `settings.json`: "Only two keys take effect from a plugin, `agent` and `subagentStatusLine`; every other key is dropped." — [Plugin components](https://code.claude.com/docs/en/plugins/components)
- Plugin hooks register when the plugin loads and fire on every event, not just when a skill is used. Use `${CLAUDE_PLUGIN_ROOT}` (it changes per version, so don't write state there) and `${CLAUDE_PLUGIN_DATA}` (`~/.claude/plugins/data/<id>/`, persists across updates). — [Plugin components](https://code.claude.com/docs/en/plugins/components)
- Plugin agents ignore `permissionMode`, `hooks` and `mcpServers` in frontmatter. — [Plugin components](https://code.claude.com/docs/en/plugins/components)
- Docs trigger: "A second repository needs the same setup → Package it as a plugin." — [Features overview](https://code.claude.com/docs/en/features-overview)

### Inferences
- For a solo dev, the best fit is **one** marketplace repo (e.g. `me/claude-kit`) with 2–4 plugins: `core` (universal skills + agents + security hooks), `ts` (TS hooks/skills), `py` (Python hooks/skills), optionally `research`. Add it locally with `claude plugin marketplace add ~/code/claude-kit`. Local path means in-place loading, so edits apply instantly with no bump. On other machines or in the cloud, use `owner/repo`.
- Because plugins **don't carry CLAUDE.md, rules or permissions**, those must go through another channel: `~/.claude` dotfiles for global ones, a Copier template for per-repo ones.
- Turn on auto-update manually for your own marketplace, or always run `/plugin marketplace update`. Omitting `version` is simpler for a solo dev.

### Gaps
- I did not confirm whether `enabledPlugins` in the project `.claude/settings.json` installs the plugin automatically or only prompts after trust. The docs say marketplaces declared there "register" after trust. I didn't see the exact install text for plugins.

## 3. Scaffolding templates with update support

### Takeaway
**Copier** is the most mature tool for re-applying template improvements to existing repos. `copier update` regenerates the old version, computes the diff of your local changes, applies the new version and re-applies your diff. Conflicts show as inline markers or `.rej` files. **cruft** gives the same idea on top of Cookiecutter. GitHub template repos and degit have no update path.

### Cited Findings
- Requirements for `copier update`: a valid `.copier-answers.yml`, a template versioned in git **with tags**, and a destination that is a git repo with a clean `git status`. It picks the latest tag (PEP 440). `--vcs-ref=HEAD` uses the latest commit. — [Copier: Updating](https://copier.readthedocs.io/en/stable/updating/)
- Mechanism: regenerate the project from the old version, diff it against the current project, apply pre-migrations, update to the new template, re-apply the diff, run post-migrations. — [Copier: Updating](https://copier.readthedocs.io/en/stable/updating/)
- Conflicts: `--conflict inline` (default, git-merge-style markers) or `--conflict rej` (`.rej` files). Guard with pre-commit hooks: `check-merge-conflict --assume-in-merge`, or forbid `\.rej$`. — [Copier: Updating](https://copier.readthedocs.io/en/stable/updating/)
- `--defaults` reuses previous answers. `--data q=...` changes one answer. "**Never** update `.copier-answers.yml` manually." Template files you deleted are not brought back by updates (use `copier recopy`). `copier check-update --quiet` exits with code 2 when an update exists, which is useful in CI or a script. — [Copier: Updating](https://copier.readthedocs.io/en/stable/updating/)
- `_skip_if_exists` creates a file only if missing, so it doesn't overwrite customizations. `_exclude`. `_tasks` run after copy/update. `_migrations` run only on update and can be tied to a version. `_answers_file` lets **several templates coexist in the same project**, each with its own answers file. Recommendation: "1 template = 1 Git repository". — [Copier: Configuring](https://copier.readthedocs.io/en/stable/configuring/)
- cruft: `cruft update` asks for review before applying, and `cruft link TEMPLATE_REPOSITORY` links an existing project to a template. One report describes poor practical experience updating Cookiecutter projects. Projects like linkml-project-copier migrated from cruft to Copier "and improved updates". — [cruft fork README](https://github.com/alexander-rabenstein/cruft); [linkml-project-copier v0.1.0](https://github.com/linkml/linkml-project-copier/releases/tag/v0.1.0); [Copier discussion #1637](https://github.com/copier-org/copier/discussions/1637)
- Cambridge UIS evaluated Copier because it "can handle project upgrades based on git tags and populate new template with pre-stored answers". — [UIS issue #89](https://gitlab.developers.cam.ac.uk/uis/devops/webapp-boilerplate/-/issues/89)

### Inferences
- Use Copier for **per-repo** artifacts that need to be physical files: project CLAUDE.md skeleton, `.claude/settings.json` (permissions, enabledPlugins, hooks), `.claude/rules/*.md` with `paths`, `.pre-commit-config.yaml`, `biome.json`/`ruff.toml` stubs, `.github/workflows/*.yml` callers, `renovate.json`.
- Use **multiple layered templates** with distinct `_answers_file` values (`.copier-answers.base.yml`, `.copier-answers.py.yml`, `.copier-answers.ts.yml`) to cover mixed stacks without one giant template.
- Use `_skip_if_exists` for files the project will customize heavily, such as the project-specific part of CLAUDE.md. A good pattern: the template owns `.claude/rules/base-*.md` (always overwritten), and the project owns `CLAUDE.md` (skip_if_exists).
- Propagation loop: tag the template, then run a `for repo in ~/code/*; do (cd $repo && copier check-update --quiet || copier update --defaults --conflict rej); done` script, then review the diffs and `.rej` files.
- Projen (synthesizes files from code and marks them read-only, which is heavy-handed for Python) and Nx generators (monorepo-centric) look like over-engineering for a solo dev with independent repos. That is not verified in this session; see Gaps.

### Gaps
- I didn't fetch current Projen/Nx/degit docs. The claims "GitHub template repos have no update path" and "degit copies without history" come from prior knowledge and were not verified here.
- The Copier docs page I read doesn't use the term "3-way merge" explicitly. It describes regenerate + diff + reapply.

## 4. Shared lint/format/tsconfig/ruff config packages + Renovate/Dependabot

### Takeaway
On TS, configs **extend from npm packages**: Biome resolves `extends` through `node_modules` with `exports`, and the same pattern works for ESLint flat config and tsconfig. That makes updates automatic through Renovate. On Python, **Ruff has no remote/URL `extend`**: `extend` accepts only a local path. The options are to copy via the Copier template, use third-party tools like `ruff-sync`, or install a package and point at its path. Renovate supports **shared presets in a git repo** (`github>owner/renovate-config`).

### Cited Findings
- Biome: supports npm packages in `extends`. The package exposes the config through `exports` in package.json (e.g. `"./biome"`), and the consumer uses `"extends": ["@org/shared-configs/biome"]`. Paths inside the shared config are relative to the config that extends it. — [Biome: big projects](https://biomejs.dev/configuration/big-projects); [Configure Biome](https://next.biomejs.dev/guides/configure-biome); example [@rowanmanning/biome-config](https://github.com/rowanmanning/biome-config)
- Ruff: `extend` is a local path only, with no native URL support (open request astral-sh/ruff#12352, according to a third-party README). Workarounds are a pip package resolved by path ([teo-ruff-config-shared](https://pypi.org/project/teo-ruff-config-shared)) or `ruff-sync`, which pulls a canonical config from a URL and merges it into the local pyproject ([ruff-sync](https://pypi.org/project/ruff-sync/)). These are secondary sources; I did not confirm in the official Ruff docs.
- Renovate: a preset hosted in a plain GitHub repo (normally `renovate-config`) is referenced with `github>owner/repo` and reads `default.json` from the default branch. `github>owner/repo:xyz` reads `xyz.json`. `local>owner/name` works on the same git server. Presets must be JSON/JSONC/JSON5. — [Renovate: Shareable Config Presets](https://docs.renovatebot.com/config-presets/); [Meziantou: sharing Renovate config](https://www.meziantou.net/sharing-the-renovate-configuration-across-multiple-projects.htm)

### Inferences
- **TS:** publish `@me/configs` (biome.json + tsconfig base + optional eslint flat config) to npm or as a git dependency. Each repo's `biome.json` has only `extends`. Renovate opens a bump PR in every repo whenever you release.
- **Python:** the leanest path is for the Copier template to own `ruff.toml` (full copy) and propagate it with `copier update`. A pip package only pays off if you have many Python repos. The pin of `ruff` itself in `pyproject`/`pre-commit` is kept current by Renovate.
- **Renovate preset** `github>me/renovate-config` defines the shared policy (automerge for patch/minor of devDeps, grouping, schedule) once. It also covers bumps of `uses: me/ci/.github/workflows/x.yml@vX` and of `rev:` in `.pre-commit-config.yaml`. Renovate has managers for github-actions and pre-commit; check the docs for the latter, which needs enabling.

### Gaps
- I didn't confirm whether Renovate's `pre-commit` manager is still opt-in in 2026. I didn't compare with Dependabot, which has no equivalent shared-preset concept to my knowledge (unverified).

## 5. CI reuse: reusable workflows and composite actions

### Takeaway
Keep a central `me/ci` repo with reusable workflows (`on: workflow_call`) for `ts-ci.yml`, `py-ci.yml` and `security.yml`, referenced by tag or SHA. Each project then has a ~10-line caller workflow that Copier generates and Renovate bumps.

### Cited Findings
- Reference: `{owner}/{repo}/.github/workflows/{filename}@{ref}`, where ref is a SHA, tag or branch. A tag takes precedence over a branch with the same name. "Using the commit SHA is the safest option for stability and security." — [GitHub Docs: Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- Limits: up to **10 levels** of workflows (caller + 9). Loops are not allowed. Permissions can only stay the same or decrease. Every workflow in the chain must be accessible to the caller. Secrets go only to the directly called workflow. No expressions in `uses`. — [GitHub Docs: Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- `secrets: inherit` passes all secrets implicitly within the same org or enterprise. Otherwise, pass them by name. — [GitHub Docs: Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)

### Inferences
- For a solo dev with a personal account (not an org), check that `me/ci` is reachable. A private repo needs the "Access" setting under Actions that allows use by other repos of the same owner. That is unverified here; see Gaps.
- Use composite actions for repeated steps (setup-node + pnpm cache, setup-uv), and reusable workflows for whole jobs.
- A floating tag `v1`, moved on minor releases, gives automatic propagation. Pinning a SHA plus Renovate gives propagation by PR. For a solo dev, a `v1` tag on your own repo is acceptable.

### Gaps
- I didn't fetch docs for composite actions, rulesets (org/repo-level "required workflows" via rulesets) or the private-repo sharing setting. Rulesets that require workflows are an org (paid plan) feature to my knowledge, unverified, and probably irrelevant for a solo dev with a personal account.

## 6. Practitioner examples and token cost (global CLAUDE.md vs skills)

### Takeaway
Practitioners converge on "dotfiles for `~/.claude`" (symlink or stow) and, increasingly, "**personal marketplace as dotfiles**". Machine state (sessions, projects, memory, credentials, plugin cache) stays out of git. On token cost, the official docs are explicit: CLAUDE.md and rules without `paths` cost tokens on **every request**. Skills cost only their description (listing budget ≈1% of the context window) until invoked. Hooks cost zero unless they return output.

### Cited Findings
- Boulede987/dotfiles-claude is a personal plugin marketplace for carrying skills and agents across machines: `/plugin marketplace add`, then install, then `/plugin marketplace update`. — [dotfiles-claude](https://github.com/Boulede987/dotfiles-claude)
- slimcandy/dotfiles: "My Claude Code setup as a plugin marketplace". — [slimcandy/dotfiles](https://github.com/slimcandy/dotfiles)
- Povaz/claude-code-dotfiles syncs agents, commands, settings and skills with symlinks + git. A setup script links each top-level entry into `~/.claude/`. — [Povaz/claude-code-dotfiles](https://github.com/Povaz/claude-code-dotfiles)
- JRRS1982/dotfiles: editing the symlinked file edits the repo, so "just commit and push". — [JRRS1982/dotfiles](https://github.com/JRRS1982/dotfiles)
- mohamedjs/claude-code-setup is copy-based: it backs up CLAUDE.md, settings.json, agents, skills and the plugin list, then restores and re-runs `claude plugin marketplace add` + install. — [claude-code-setup](https://github.com/mohamedjs/claude-code-setup)
- A pruszel/dotfiles issue proposes a GNU stow package for settings.json, CLAUDE.md, hooks and skills, and warns that projects, sessions and memory are machine-local and stay out. — [pruszel/dotfiles#1](https://github.com/pruszel/dotfiles/issues/1)
- Official context cost: CLAUDE.md is "Full content … Every request". Skills are "Low (descriptions every request)", and `disable-model-invocation: true` removes the description from context. MCP loads only tool names, with schemas deferred (tool search on by default). Subagents are isolated. Hooks are "Zero, unless hook returns additional context". — [Features overview](https://code.claude.com/docs/en/features-overview)
- Skill listing budget: "The budget scales at 1% of the model's context window". Descriptions of the least-used skills are dropped first. Each description + `when_to_use` is capped at 1,536 characters. Adjust with `skillListingBudgetFraction`, `SLASH_COMMAND_TOOL_CHAR_BUDGET`, or `skillOverrides: "name-only"`. Diagnose with `/doctor` and `/skill-doctor`. — [Skills](https://code.claude.com/docs/en/skills)
- After compaction, invoked skills are re-attached at "first 5,000 tokens of each" with "a combined budget of 25,000 tokens". Keep SKILL.md under 500 lines. — [Skills](https://code.claude.com/docs/en/skills)
- Auto memory loads every session (first 200 lines or 25KB). — [Memory](https://code.claude.com/docs/en/memory)
- `/doctor prompt-audit` audits CLAUDE.md, rules, skills, commands, agents and output styles in `.claude/` and `~/.claude/` for conflicting or outdated instructions. — [Memory](https://code.claude.com/docs/en/memory)
- Content you want "every time" should be a hook (deterministic). CLAUDE.md and skills are requests, not guarantees. — [Features overview](https://code.claude.com/docs/en/features-overview)

### Inferences
- With dozens of global skills, the 1% listing budget saturates and descriptions get truncated. That makes the case for few global skills, plus `disable-model-invocation: true` on manually triggered workflows (zero cost), plus per-stack plugins enabled only where relevant (`enabledPlugins` per project).
- In cost order, the cheapest way to "make a standard apply" is: hook/CI/pre-commit (0 tokens, deterministic), then a rule with `paths` (only when relevant), then a skill (description only), then global CLAUDE.md (always). Quality standards should live in **tooling** (lint/format/test in pre-commit + CI), not in prose for the model.

### Gaps
- I found no quantitative 2025–2026 measurement (tokens/$) comparing setups with a large global CLAUDE.md vs skills. The cost argument is qualitative, from the official docs.
- The practitioner repos were seen through search summaries. I didn't open each one to check activity or date.

## 7. Recommended lean architecture (solo dev, TS + Python)

### Takeaway
Use **four repos/layers**, each with one propagation mechanism. (1) `dotfiles/claude` → `~/.claude` (global, symlink). (2) `claude-kit` marketplace (plugins: core/ts/py), updated with `/plugin marketplace update`. (3) Copier `project-template`, with per-repo files and `copier update`. (4) `ci` + `renovate-config` (+ optional `@me/configs` on npm), bumped by Renovate. Anything that must be enforced goes in hooks, pre-commit or CI. Anything only "advice" goes in rules with `paths` or skills. The global CLAUDE.md stays minimal.

### Cited Findings (basis)
- Plugins package skills, agents, hooks and MCP "when you want to reuse the same setup across multiple repositories". — [Features overview](https://code.claude.com/docs/en/features-overview)
- Plugins don't load CLAUDE.md, and their settings.json accepts only `agent`/`subagentStatusLine`. — [Plugin components](https://code.claude.com/docs/en/plugins/components)
- User rules in `~/.claude/rules/` apply everywhere without approval. Symlinks into a project need external approval and drop `paths` rules. — [Memory](https://code.claude.com/docs/en/memory)
- Copier update + `_answers_file` for several templates + `_skip_if_exists`. — [Copier configuring](https://copier.readthedocs.io/en/stable/configuring/); [Copier updating](https://copier.readthedocs.io/en/stable/updating/)
- Reusable workflows by tag/SHA. — [GitHub Docs](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows). Renovate `github>` presets. — [Renovate](https://docs.renovatebot.com/config-presets/)

### Inferences (recommendation)
**Layer A — Global (`~/.claude`, `dotfiles` repo, symlink/stow):**
- `CLAUDE.md` ≤ ~50 lines: personal principles (language, "verify before declaring done", minimal diffs).
- `settings.json`: `permissions.deny` for secrets (`.env`, `~/.ssh`), read-only `allow` rules, `extraKnownMarketplaces` + `enabledPlugins` for `claude-kit` core. Leave out machine state (projects/, sessions, memory, `.credentials`, `plugins/cache`).
- No stack-specific content at this level.

**Layer B — `claude-kit` marketplace (git repo; added from a local path on the main machine for in-place editing):**
- `core`: universal skills (review, commit, plan, research) with `disable-model-invocation: true` on manual workflows. Agents (reviewer, explorer). Guardrail hooks (PreToolUse blocking `rm -rf`, edits to `.env`, `git push --force`).
- `ts` and `py`: PostToolUse format/lint hooks (biome/ruff) that run only if the binary or config exists in the repo. Stack skills (test conventions, migrations).
- Turn on each project's stack plugin in the committed `.claude/settings.json` (`enabledPlugins`). Omit `version` (track commits) or bump consistently.

**Layer C — Copier template (`project-template`, tagged; sub-templates `base`, `ts`, `py` with separate `_answers_file`):**
- Generates and owns: `.claude/settings.json` (permissions + enabledPlugins + marketplace), `.claude/rules/stack-*.md` with `paths`, `CLAUDE.md` skeleton (`_skip_if_exists`, project-owned), `.pre-commit-config.yaml`, `biome.json` (extends) / `ruff.toml` (copy), test config (vitest/pytest), `.github/workflows/ci.yml` (calls the reusable workflow), `renovate.json` (extends preset), security scanning (gitleaks/semgrep or CodeQL via the reusable workflow).
- Propagation: release a template tag, run a sweep script with `copier check-update` → `copier update --defaults --conflict rej` on a branch, review, merge. Pre-commit blocks `.rej` files and conflict markers.

**Layer D — Packages/CI (bumped by Renovate):**
- `me/ci`: reusable workflows `ts.yml`, `py.yml`, `security.yml` (`workflow_call`) + composite actions for setup. Callers use `@v1` (floating) or SHA + Renovate.
- `me/renovate-config` (`default.json`): grouping, automerge for devDeps patch/minor, schedule.
- `@me/configs` (npm, optional): biome/tsconfig/eslint, only once there are ≥3 TS repos. Before that, copying via Copier is enough.

**Pitfalls:**
1. Global CLAUDE.md growing too large becomes a token tax on every request of every project, and lowers adherence (>200 lines).
2. A user skill with the same name **overrides** the project one. A user agent **loses** to the project one. Use namespacing (plugin) to avoid ambiguity.
3. A plugin with a fixed `version` and no bump means users never receive updates. Third-party auto-update is off by default.
4. `.claude/rules` symlinks to outside the repo: approval dialog, `paths` rules don't load, and they break on other machines, CI and cloud. Prefer files materialized by Copier.
5. Cloud sessions and CI see only what is committed, never `~/.claude`.
6. Manual edits to `.copier-answers.yml` break updates. A dirty working tree blocks the update. Deleted template files don't come back without `recopy`.
7. Ruff has no remote extend, so don't depend on a URL.
8. Instructions in prose are not enforcement. Standards that matter go in hooks, pre-commit and CI.
9. Private marketplace on a machine without a stored credential: background update fails silently and keeps the stale checkout.
10. Over-engineering: Projen/Nx, or npm config packages with 1–2 repos, cost more than they return. Start with dotfiles + 1 marketplace + 1 Copier template, and extract packages only once there is real repetition.

### Gaps
- No public 2025–2026 case study of a solo dev combining Copier + plugin marketplace was found. The recommendation is a synthesis of the official mechanisms.
- I didn't verify whether `copier update` behaves well with symlinks or with files that Claude Code itself modifies (e.g. `settings.local.json`, which should be in `_exclude`).
