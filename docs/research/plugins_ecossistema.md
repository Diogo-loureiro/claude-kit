# Claude Code plugin, skills and MCP ecosystem (as of 2026-10-31): what to install as a solo dev optimizing quality and token cost

Note on method: I pulled GitHub star counts and last-push dates live from the GitHub REST API on 2026-10-31 (api.github.com/repos/<owner>/<repo>). I pulled the official marketplace contents from the raw `.claude-plugin/marketplace.json` and the repo's `plugins/` and `external_plugins/` directories on the same day. Most other figures come from blogs or third-party write-ups and are marked as such.

## 1. Official Anthropic marketplaces and plugins

### Takeaway
`anthropics/claude-plugins-official` is a large, active catalog. It holds 315 plugins: about 40 Anthropic-internal ones plus partner and community entries, including Superpowers, Context7, Serena, Playwright, Supabase, Neon, Prisma, Stripe, Semgrep, SonarQube and Expo. Of the internal plugins, the ones that matter most for quality and cost are code-review, pr-review-toolkit, security-guidance and claude-security, the LSP "code intelligence" plugins (typescript-lsp, pyright-lsp), session-report, hookify, claude-md-management and commit-commands. Newer Claude Code builds also ship /code-review, /simplify and /security-review built in, so some of these plugins now duplicate built-ins.

### Cited Findings
- Repo `anthropics/claude-plugins-official`: 45,515 stars, last push 2026-10-31, not archived — [GitHub API](https://api.github.com/repos/anthropics/claude-plugins-official). The fetched repo page showed 4.7k forks and 4,658 commits — [GitHub](https://github.com/anthropics/claude-plugins-official).
- The repo has two directories. `/plugins` holds internal plugins maintained by Anthropic. `/external_plugins` holds partner and community plugins. You install with `/plugin install <name>@claude-plugins-official` or browse with `/plugin` → Discover — [GitHub](https://github.com/anthropics/claude-plugins-official).
- `marketplace.json` lists **315 plugins** as of 2026-10-31 — [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json). Earlier counts show how fast it grew: roughly 53 visible in a February 2026 screenshot, and about 101 according to a May 2026 secondary source — [search summary / Reddit snapshot](https://reddit.sentinel-team.org/posts/1r4tk3u/snapshots/2026-02-15T00%3A43%3A54.758766Z), [Atlas blueprint](https://laoujin.github.io/Atlas/research/2026-05-23-extending-claude-code-mcp-skills-plugins-a-session-3-blueprint/plugins-the-marketplace/views/catalog.html).
- The internal `/plugins` directory on 2026-10-31 contains: agent-sdk-dev, clangd-lsp, claude-code-setup, claude-md-management, claude-security, code-modernization, code-review, code-simplifier, commit-commands, csharp-lsp, cwc-makers, example-plugin, explanatory-output-style, feature-dev, frontend-design, gopls-lsp, hookify, jdtls-lsp, kotlin-lsp, learning-output-style, lua-lsp, math-olympiad, math-proof, mcp-server-dev, mcp-tunnels, php-lsp, playground, plugin-dev, pr-review-toolkit, project-artifact, pyright-lsp, ralph-loop, receipts, ruby-lsp, rust-analyzer-lsp, security-guidance, session-report, skill-creator, swift-lsp, typescript-lsp — [GitHub API contents](https://api.github.com/repos/anthropics/claude-plugins-official/contents/plugins).
- `/external_plugins` (vendored) contains: asana, context7, discord, fakechat, firebase, github, gitlab, imessage, laravel-boost, linear, playwright, serena, telegram, terraform — [GitHub API contents](https://api.github.com/repos/anthropics/claude-plugins-official/contents/external_plugins).
- Official descriptions from marketplace.json ([source](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json)):
  - **code-review**: "Automated code review for pull requests using multiple specialized agents with confidence-based scoring to filter false positives."
  - **pr-review-toolkit**: "PR review agents specializing in comments, tests, error handling, type design, code quality, and code simplification."
  - **feature-dev**: "feature development workflow with specialized agents for codebase exploration, architecture design, and quality review."
  - **commit-commands**: "git commit workflows including commit, push, and PR creation."
  - **security-guidance**: "Pattern-based warnings on edits, LLM-powered diff review on Stop, and an agentic commit reviewer that catches injection, XSS, SSRF, hardcoded secrets…" This means it runs hooks on every edit and at Stop, which costs tokens on an ongoing basis.
  - **claude-security**: "Deep vulnerability scanning of your own code, run entirely inside your Claude Code session at a chosen effort tier, with every finding challenged before it is reported."
  - **code-simplifier**: an agent that refines recently modified code for clarity.
  - **hookify**: "create custom hooks to prevent unwanted behaviors… Define rules via simple markdown."
  - **frontend-design**: "distinctive, production-grade frontend interfaces… avoids generic AI aesthetics."
  - **claude-md-management**: audits CLAUDE.md quality and captures session learnings.
  - **claude-code-setup**: analyzes the codebase and recommends hooks, skills, MCP servers and subagents.
  - **session-report**: "explorable HTML report of Claude Code session usage — tokens, cache efficiency, subagents, skills, and the most expensive prompts — from local transcripts."
  - **receipts**: a personal usage and impact report.
  - **ralph-loop**: "Ralph Wiggum technique," which runs Claude repeatedly on the same task until completion. Its cost is potentially unbounded.
  - **typescript-lsp / pyright-lsp**: language-server code intelligence.
  - **skill-creator**: create and evaluate skills.
- Relevant third-party and partner entries in the official marketplace:
  - Security: **semgrep**, **sonarqube** (PostToolUse hooks, 7,000+ rules), **aikido** (SAST, secrets, IaC), coderabbit, greptile.
  - Database: **supabase**, **neon**, **prisma** ("schema migrations, SQL queries"), convex, firebase, mongodb, cockroachdb.
  - Mobile: **expo** ("Official Expo skills for building, deploying, upgrading, and debugging React Native apps").
  - Payments: **stripe**, **mercadopago** (Mercado Pago integration plus a webhooks and test-setup skill).
  - Ops: **sentry**, **vercel**, **posthog**, chrome-devtools-mcp.
  - Superpowers itself is also listed in the official marketplace.
  
  All of the above come from [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json).
- `anthropics/skills`: 185,738 stars, last push 2026-10-28 — [GitHub API](https://api.github.com/repos/anthropics/skills). A blog describes it as capability-focused (document handling, mcp-builder, webapp-testing, skill-creator) rather than process-focused — [JoanMedia, 2026-07-16](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives).
- The official cost docs recommend code intelligence plugins for typed languages. Per the docs, "A single 'go to definition' call replaces what might otherwise be a grep" and plus file reads, which reduces unnecessary file reads — [Claude Code docs: costs](https://code.claude.com/docs/en/costs).
- One guide says code review and simplify are built into recent Claude Code versions and advises checking `/code-review` before installing duplicates. It also recommends security-guidance and code-review as early installs — [search summary of 2026 guides incl. turbodocx/accordio](https://www.turbodocx.com/blog/best-claude-code-skills-plugins-mcp-servers). The current session's built-in skill list also includes code-review, simplify and security-review, which is consistent with this.

### Inferences
- For a solo dev, the built-in /code-review, /security-review and /simplify cover most of what code-review, pr-review-toolkit and code-simplifier offer. Install the plugins only if the built-ins prove insufficient.
- security-guidance is the main official plugin with an always-on cost, because it runs hooks on edits and an LLM diff review on every Stop. For a finance app the protection is probably worth that cost, but measure it with session-report or ccusage.
- The typescript-lsp or pyright-lsp plugin is the clearest official "saves tokens" install for a typed web stack.

### Gaps
- I could not fetch per-plugin last-commit dates, because all plugins live in one monorepo. I found no install counts from Anthropic. "Ranked by installs" lists exist only on third-party sites such as accordio.ai, and I did not verify their methodology.
- I did not measure how many tokens security-guidance's Stop hook adds per turn.

## 2. Community frameworks: Superpowers, SuperClaude, claude-flow/Ruflo, wshobson/agents, BMAD, Spec Kit, GSD

### Takeaway
obra/superpowers is now the dominant community workflow plugin: 309.8k stars, active, and listed in the official marketplace. Superpowers 6 (June 2026) explicitly targeted its cost reputation, with author-reported results of up to 60% cheaper and 50% faster. It is still widely called overkill for small tasks. BMAD and claude-flow (now Ruflo) are heavyweight multi-agent systems that are hard to justify for a solo dev. SuperClaude is losing momentum. Spec Kit is lighter but its specs must be kept in sync by hand.

### Cited Findings
- **obra/superpowers**: 309,797 stars, last push 2026-10-29 — [GitHub API](https://api.github.com/repos/obra/superpowers). The page showed 27.6k forks and 686 commits. Its seven-step workflow is brainstorming → using-git-worktrees → writing-plans → subagent-driven-development or executing-plans → test-driven-development (red/green/refactor) → requesting-code-review (critical issues block) → finishing-a-development-branch. Other skills include systematic-debugging, verification-before-completion, dispatching-parallel-agents, receiving-code-review, writing-skills and using-superpowers — [GitHub README](https://github.com/obra/superpowers).
- **Superpowers 6** (blog dated 2026-06-15) reports "up to 50% faster and up to 60% cheaper" on the author's own eval suite — [blog.fsck.com](https://blog.fsck.com/2026/06/15/Superpowers-6/). Changes and findings:
  - Pre-built review packets (diff plus metadata from a script) saved about 10%.
  - Merging the spec-compliance and code-quality reviewers saved about 15%.
  - A terse reviewer contract cut reviewer output 41%, and a narration recipe cut output 54%.
  - Conditional implementer tiering uses cheaper models only when appropriate.
  - One benchmark run went from about $12–15 to about $6.
  - Capping controller thinking backfired.
  - The author also flagged caveats: diff-only reviewers missed a missing brief in 0/5 runs, and a fuller N=5 gate test is "still owed."
  - The evals are open source at prime-radiant-inc/superpowers-evals.
- Earlier history: v5.0.6 removed plan-review loops that added about 25 minutes with no measurable quality gain, and v6.1.0 compressed the `using-superpowers` bootstrap that is injected into every session — [JoanMedia, 2026-07-16](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives).
- Token profile: dormant skills cost about 100 tokens each in metadata, so 14 skills come to about 1,400 tokens. The main cost is workflow overhead (design docs, plans, a subagent per task, reviews). One community measurement (12 sessions, unverified) found 9% cheaper and 14% fewer tokens with better output on non-trivial tasks, but simple tasks cost more — [JoanMedia](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives); [lzwjava explainer, AI-generated, weak](https://lzwjava.github.io/superpowers-token-usage-explained-en).
- Critiques: users call it a "huge token guzzler," one said it "burned through all my max plan," simple fixes can take an hour, and plans that name exact files hurt exploratory work. Recommended to skip for typo fixes, renames, spikes and prototypes, and when on a tight subscription budget — [JoanMedia](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives).
- The Superpowers 6 HN thread (item 48739459) has commenters reporting 10x token burn on fire-and-forget tasks and worse results than plain Claude or Codex on personal benchmarks. Defenders say it produces "code which complies with the spec far better." In another HN comment a user said "Plan mode became enough" — [HN Superpowers 6](https://news.ycombinator.com/item?id=48739459); [HN comment](https://news.ycombinator.com/item?id=47418626); [HN rave review](https://news.ycombinator.com/item?id=47623101). These HN quotes come via a search-engine summary; I did not read the threads directly.
- **SuperClaude_Framework**: 23,918 stars, last push 2026-09-27, about 5 weeks before this check, so activity is slowing — [GitHub API](https://api.github.com/repos/SuperClaude-Org/SuperClaude_Framework). The only analysis found (v4.1.9, November 2025) describes it as a configuration layer of injected instructions and has no overhead data — [regis-rcr analysis](https://regis-rcr.github.io/claude-framework-research/frameworks/superclaude.html).
- **claude-flow → renamed Ruflo** (`ruvnet/claude-flow` redirects to `ruvnet/ruflo`): 80,383 stars, last push 2026-10-31. It describes itself as "multi-player swarms… adaptive memory, self-learning intelligence, federation, vector RAG" — [GitHub API](https://api.github.com/repos/ruvnet/ruflo).
- **wshobson/agents**: 42,035 stars, last push 2026-10-30 — [GitHub API](https://api.github.com/repos/wshobson/agents). Similar collection: **VoltAgent/awesome-claude-code-subagents** ("100+ specialized subagents"): 26,230 stars, last push 2026-10-30 — [GitHub API](https://api.github.com/repos/VoltAgent/awesome-claude-code-subagents).
- **BMAD-METHOD**: 54,812 stars, last push 2026-10-31 — [GitHub API](https://api.github.com/repos/bmad-code-org/BMAD-METHOD). Blogs call it the heavyweight option, modeling an entire software team with 12+ named agents, and one found it "hard for a solo developer to justify" — [GSD vs SpecKit/BMAD comparison](https://samy-portfolio.pages.dev/blog/2026/gsd-vs-speckit-bmad-compound-engineering); [Limitations of BMAD](https://asantos2000.github.io/blog/post-3/).
- **github/spec-kit**: 144,191 stars, last push 2026-10-30 — [GitHub API](https://api.github.com/repos/github/spec-kit). Commands can be learned in a day or two, but spec files must be kept in sync with code manually or they go stale — [dev.to Spec Kit vs BMAD vs OpenSpec](https://dev.to/willtorber/spec-kit-vs-bmad-vs-openspec-choosing-an-sdd-framework-in-2026-d3j).
- A 2026 comparison recommends Superpowers for solo work on a single repo, and GSD (a reaction to BMAD's complexity) for solo devs who want structure without a full multi-agent setup — [samy-portfolio comparison](https://samy-portfolio.pages.dev/blog/2026/gsd-vs-speckit-bmad-compound-engineering).
- Other active projects:
  - coleam00/Archon ("harness builder"): 23,794 stars, active.
  - thedotmack/claude-mem (cross-session memory): 107,199 stars, last push 2026-10-31.
  - davila7/claude-code-templates: 33,013 stars.
  - jarrodwatts/claude-hud (context-usage HUD plugin): 29,049 stars.
  - steipete/claude-code-mcp: last push 2026-05-15, so stale.
  
  All from the [GitHub API](https://api.github.com/repos/thedotmack/claude-mem).

### Inferences
- Per the sources above, the community largely agrees with Superpowers' workflow (brainstorm → plan → TDD → review). The disagreement is about enforcing it on every task. For a solo dev, a reasonable approach is to install Superpowers but invoke it deliberately for multi-file or correctness-critical features such as money calculations and sync. Use plan mode or plain prompts for small edits.
- Running two methodologies at once (Superpowers plus BMAD, SuperClaude or Spec Kit) stacks injected instructions and conflicting process. JoanMedia explicitly warns that "two competing methodologies in context are worse than one."
- Ruflo/claude-flow and BMAD are optimized for swarm and team simulation, which multiplies tokens. I found no evidence that they improve solo-dev outcomes enough to offset that.
- Giant subagent collections (wshobson, VoltAgent) add one description per agent to context. Cherry-pick 2–5 agents rather than installing the whole pack.

### Gaps
- I did not obtain the current Superpowers version number; the README has no releases section. The blog shows v6.x as of June–July 2026.
- I found no independent, controlled benchmark of Superpowers 6 versus vanilla Claude Code. All numbers are either the author's own or small-N community runs.
- I found no 2026 overhead measurements for SuperClaude, Ruflo or wshobson/agents. I did not check GSD's repo stars.

## 3. MCP servers and tools: Context7, Serena, Playwright MCP vs CLI, ccusage, claude-code-router, DB MCPs

### Takeaway
MCP tool definitions are now deferred by default through tool search, so the per-server context tax is small. That makes the CLI-vs-MCP gap narrower than it was in 2025. Anthropic's own docs still say CLIs (gh, sentry-cli and similar) are more context-efficient. Context7 is the near-universal pick. Serena and LSP plugins reduce file reads, though I found no official Serena benchmark. ccusage and the official session-report plugin are the cost-tracking tools. claude-code-router is active but is a model-routing hack, not a quality tool.

### Cited Findings
- **upstash/context7**: 64,003 stars, last push 2026-10-30 — [GitHub API](https://api.github.com/repos/upstash/context7). It is in the official marketplace and connects to a hosted remote MCP (https://mcp.context7.com/mcp) with "no local Node" needed — [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json). It is the most consistently recommended pick for "up-to-date, version-specific library documentation" — [2026 guides summary](https://www.turbodocx.com/blog/best-claude-code-skills-plugins-mcp-servers).
- **oraios/serena**: 30,931 stars, last push 2026-10-28, also in the official marketplace — [GitHub API](https://api.github.com/repos/oraios/serena). I found no official token-savings benchmark. A third-party slim fork reports that Serena's 29 tools reduce to 18, with an estimated 50.3% context cut, assuming about 570 tokens per tool. Reddit users call it "token-frugal" without numbers — [lobehub serena-slim](https://lobehub.com/mcp/mcpslim-serena-slim); [Reddit](https://redlib.hackliberty.org/r/ClaudeAI/comments/1l42cn6/claude_and_serena_mcp_a_dream_team_for_coding).
- **microsoft/playwright-mcp**: 38,891 stars. **microsoft/playwright-cli**: 14,820 stars. Both last pushed 2026-10-31 — [GitHub API](https://api.github.com/repos/microsoft/playwright-mcp). The evidence conflicts:
  - Write-ups report about 114k tokens (MCP) versus about 26–27k (CLI) for one multi-step browser task, because MCP returns screenshots into context while the CLI saves PNGs to disk.
  - Checkly counted 48 Playwright MCP tool schemas at about 5.9k tokens, but in three repeated runs found MCP and the skill-based CLI "more or less the same" in token use.
  
  Sources: [Checkly](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/); [Shipyard](https://shipyard.build/blog/playwright-mcp-vs-cli/); [Webfuse](https://www.webfuse.com/blog/playwright-mcp-vs-playwright-cli).
- **ChromeDevTools/chrome-devtools-mcp**: 54,543 stars, last push 2026-10-30, in the official marketplace (performance traces, network, console) — [GitHub API](https://api.github.com/repos/ChromeDevTools/chrome-devtools-mcp).
- **ccusage**: the repo moved from ryoppippi/ccusage to `ccusage/ccusage`. It has 19,274 stars and was last pushed 2026-10-31 (`npx ccusage`) — [GitHub API](https://api.github.com/repos/ccusage/ccusage). The official alternative is the **session-report** plugin (tokens, cache efficiency, most expensive prompts). The Claude Code `/usage` view also attributes recent usage to skills, subagents, plugins and individual MCP servers as percentages — [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json); [Claude Code docs: costs](https://code.claude.com/docs/en/costs).
- **musistudio/claude-code-router**: 37,918 stars, last push 2026-10-10. It is active but slower than the others — [GitHub API](https://api.github.com/repos/musistudio/claude-code-router).
- **Supabase MCP**: the repo moved to `supabase/mcp`, with 2,988 stars and a last push of 2026-10-31. The official marketplace "supabase" plugin covers SQL, auth, storage and realtime — [GitHub API](https://api.github.com/repos/supabase/mcp). Neon and Prisma (migrations) plugins also exist — [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json).

### Inferences
- Context7 is low-risk and high-value, because it is a hosted remote MCP and its tools are deferred.
- For a TypeScript stack, try the official typescript-lsp plugin before Serena. Both target the same "navigate symbols instead of grepping" savings, and the LSP plugin is first-party.
- Prefer the Playwright CLI (or the Playwright skill) for routine E2E checks in Claude Code. Use the MCP version only for interactive exploratory debugging.

### Gaps
- I found no independent measurement of Context7's per-call output size or its effect on cost.

## 4. Token overhead of MCP, skills and plugins: how many to install, and known cost inflation

### Takeaway
As of v2.1.x the official docs say MCP tools are deferred by default: only tool names and server instructions load at session start. Skills use progressive disclosure: only the description, capped at 1,536 characters, loads until the skill is invoked. Idle overhead is therefore now modest. The real cost drivers are the following, and they argue for installing few things:
- workflow plugins that spawn subagents and reviews (Superpowers, BMAD, Ruflo, ralph-loop),
- always-on hooks (security-guidance, sonarqube PostToolUse),
- large MCP tool outputs such as screenshots and DB dumps,
- injected bootstraps or instructions that load every session.

### Cited Findings
- Official docs on deferral: "Tool search keeps MCP context usage low by deferring tool definitions until Claude needs them. Only tool names and server instructions load at session start, so adding more MCP servers has minimal impact on your context window." "Tool search is enabled by default." It is used on Opus 4, Sonnet 4, Haiku 4.5 and later — [Claude Code docs: MCP](https://code.claude.com/docs/en/mcp).
- `ENABLE_TOOL_SEARCH` values:
  - unset or `true`: deferred.
  - `auto`: tools load upfront while their definitions total under 10% of context, and are deferred above that.
  - `auto:N`: same, with a custom percentage.
  - `false`: everything loads upfront.
  
  `"alwaysLoad": true` per server forces upfront loading. The docs advise reserving it for "a small number of tools that Claude needs on every turn, since each upfront tool consumes context" — [Claude Code docs: MCP](https://code.claude.com/docs/en/mcp).
- MCP output limits: a warning appears above 10,000 tokens of tool output, the default cap is 25,000 tokens (`MAX_MCP_OUTPUT_TOKENS`), and text results over 50,000 characters are saved to a file — [Claude Code docs: MCP](https://code.claude.com/docs/en/mcp).
- Official cost guidance:
  - "Prefer CLI tools when available: Tools like gh, aws, gcloud, and sentry-cli are still more context-efficient than MCP servers because they don't add any per-tool listing."
  - "Disable unused servers" via `/mcp`, and run `/context` to see what consumes space.
  - Use hooks to preprocess output, for example filtering test output to failures only, which can take context "from tens of thousands of tokens to hundreds."
  - Move workflow-specific instructions from CLAUDE.md into skills.
  - Agent-team teammates "load CLAUDE.md, MCP servers, and skills automatically," so every installed item is multiplied per teammate or subagent.
  
  Source: [Claude Code docs: costs](https://code.claude.com/docs/en/costs).
- Skills docs:
  - The combined `description` and `when_to_use` text "is truncated at 1,536 characters in the skill listing to reduce context usage."
  - `disable-model-invocation: true` means the "description not in context, full skill loads when invoked."
  - After auto-compaction, invoked skills are re-attached keeping the first 5,000 tokens each.
  
  Source: [Claude Code docs: skills](https://code.claude.com/docs/en/skills).
- Third-party sources state the skill-catalog budget as about 2% of context (about 16k characters at 200k) or 1% of 1M. When it is exceeded, lower-priority skills appear as bare names. `SLASH_COMMAND_TOOL_CHAR_BUDGET` raises the budget. The figures conflict and are not from the official docs I read — [claude-skills-guide](https://claude-skills-guide-3lc.pages.dev/claude-skills-performance-optimization/); [search summary](https://dak-dev.vercel.app/learn/toolkit/skills/mental-model).
- Older pre-deferral data points: one user saw 28.1k tokens (14.1% of the window) consumed by MCP tool definitions. A vendor claimed standalone MCPs can eat 30% or more of context. The vendor figure is not independent, since that vendor sells a gateway — [search summary incl. Checkly/getmaxim](https://www.getmaxim.ai/articles/best-mcp-servers-for-claude-code.md).
- Known cost-inflation cases:
  - Superpowers subagent and review loops on small tasks ("10x tokens," "burned through all my max plan").
  - Superpowers' pre-v5.0.6 plan-review loops, which added about 25 minutes for no gain.
  - Playwright MCP screenshots entering context.
  - ralph-loop, which by design runs repeatedly until completion.
  
  Sources: [JoanMedia](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives); [HN](https://news.ycombinator.com/item?id=48739459); [Shipyard](https://shipyard.build/blog/playwright-mcp-vs-cli/); [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json).
- Practitioner consensus is to keep the list short, "curate for trust and signal, not for context budget," and build or trim your own skills rather than installing many — [2026 guides summary](https://dev.to/dublecc/best-mcp-servers-for-claude-code-in-2026-a-curated-job-by-job-guide-1bnd); [JoanMedia](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives).

### Inferences
- In 2026 the binding constraint has shifted from context window to per-turn token spend (subagents, hooks, outputs) and to security and trust in third-party servers. For a solo dev, a sensible target is 3–6 plugins and 2–4 MCP servers.
- Audit spend weekly with `/context`, `/usage`, session-report or ccusage. Disable anything that never shows up in the attribution.

### Gaps
- I found no official number for how many tokens each deferred tool name or server instruction costs.

## 5. Fit for a solo dev building a personal finance app (web/mobile + DB)

### Takeaway
A lean, defensible set, with sources in the cited findings below:
- Security: built-in /security-review plus the security-guidance plugin, or Semgrep for a deterministic SAST layer.
- Code intelligence: typescript-lsp (or pyright-lsp).
- Docs: Context7.
- Database: one DB plugin matching the stack (supabase, neon or prisma, for migrations).
- E2E testing: Playwright CLI or skill (MCP only for exploration).
- Mobile: expo if using React Native.
- Cost tracking: ccusage or session-report.
- Workflow: optionally Superpowers, used deliberately for big features.

Avoid BMAD, Ruflo, SuperClaude, whole subagent packs and ralph-loop.

### Cited Findings
- Security options in the official marketplace:
  - security-guidance (injection, XSS, SSRF, hardcoded secrets; hooks on edit and Stop).
  - claude-security (deep scan at a chosen effort tier, findings challenged before reporting).
  - semgrep (real-time SAST).
  - sonarqube (7,000+ rules, secrets, quality gates via PostToolUse).
  - aikido (SAST, secrets, IaC).
  - 42crunch (OWASP API audit of OpenAPI specs).
  
  Source: [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json).
- DB and migration options: supabase (SQL, auth, storage, realtime), neon (neon-postgres skill plus MCP), prisma ("schema migrations, SQL queries"), convex, firebase — [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json); Supabase MCP repo active — [GitHub API](https://api.github.com/repos/supabase/mcp).
- Mobile: expo (official Expo skills for Expo Router, building, deploying and upgrading) — [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json).
- Payments and region: stripe, and mercadopago (integration wizard, webhooks, test setup, review). Mercado Pago may matter if the app targets Brazil — [marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json).
- Observability: sentry and posthog plugins exist, but the official docs note sentry-cli is more context-efficient than an MCP — [Claude Code docs: costs](https://code.claude.com/docs/en/costs).
- Superpowers' TDD and verification-before-completion skills are the strongest community evidence for correctness-sensitive work. Sources say the overhead "buys quality and autonomy" on multi-file, correctness-sensitive features — [JoanMedia](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives); [obra/superpowers](https://github.com/obra/superpowers).

### Inferences
- For a finance app, money logic, auth and data access are correctness- and security-critical. TDD on the domain layer (Superpowers' TDD skill, or a short custom TDD skill) plus a security reviewer is worth the tokens. UI tweaks are not.
- Database MCPs that can execute SQL should point at dev or branch databases only, such as Neon branches or a Supabase dev project, never production financial data. This is a security inference, not a sourced recommendation.
- A deterministic scanner like Semgrep complements LLM security review at near-zero token cost when run as a CLI or in CI.

### Gaps
- I found no head-to-head comparison of security-guidance, claude-security, Semgrep and SonarQube for false-positive rate or token cost.
- I found no finance-app-specific Claude Code case studies.
