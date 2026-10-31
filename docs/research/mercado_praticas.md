# What the market actually uses for agentic software development (2025-2026), with a focus on cost and quality

Research date: 2026-10-31.

Recency note:
- The most recent items (2026-06 to 2026-10) are marked "Most recent" or "Latest".
- Older items from 2024-2025 (Aider architect benchmark 2024-09, Cognition/Anthropic 2025-06, METR 2025-07, Stack Overflow 2025) are foundational but predate current models.
- Claude Code plugins and community frameworks (Superpowers etc.) are covered in detail by another researcher and are mentioned only briefly here. Many sources are vendor or consultancy blogs and are flagged as such. Primary sources (Anthropic, Cognition, Aider, HumanLayer, GitHub, METR, ETH/arXiv) are noted where available.

## 1. Spec-driven development (SDD): Spec Kit, Kiro, BMAD, Tessl, OpenSpec, Agent OS

### Takeaway
SDD became a major 2025-2026 trend. The common pipeline is spec -> design/plan -> tasks -> implement, with human review at the artifacts. The consistent critique is token and time overhead plus "a sea of markdown" on small tasks. The best (vendor-run) evidence suggests SDD pays off only on mid-to-large feature work. The lighter variants (OpenSpec, plain "plan mode") are gaining as cheaper alternatives.

### Cited Findings
- Token overhead measured head to head with GPT-5.2: Spec Kit used about 2x the tokens of OpenSpec (about 120,947 vs 57,740 total; planning alone 96,298 vs 38,117). The extra cost came from more file traversal and tool calls. This is a single-author comparison. — [Medium: "Spec Driven Development Is Wasting Tokens"](https://medium.com/it-chronicles/is-your-safe-choice-burning-your-budget-1cfddf8782e4)
- A Scott Logic review of Spec Kit found "a sea of markdown documents, long agent run-times and unexpected friction". One run was about 10x slower than iterative prompting. A comparison piece reported that Spec Kit costs ran several multiples of an equivalent plan-mode flow. — [Instil: "Spec-Driven Development is dead, long live Plan Mode"](https://instil.co/blog/spec-driven-development-is-dead-long-live-plan-mode); [Medium/Reenbit comparison](https://medium.com/@reenbit/bmad-vs-spec-kit-vs-openspec-choosing-your-spec-driven-ai-framework-in-2026-a6996b3ebb8d)
- BMAD Method is called the heaviest of the group, at about 31.7k tokens per workflow run and with a steep learning curve. In one anecdotal benchmark, BMAD took 5.5 hours to build a CRM dashboard vs 12 minutes with OpenSpec. The source is vendor-adjacent and n=1. — [Reenbit: BMAD vs Spec Kit vs OpenSpec (2026)](https://medium.com/@reenbit/bmad-vs-spec-kit-vs-openspec-choosing-your-spec-driven-ai-framework-in-2026-a6996b3ebb8d)
- Kiro (AWS) enforces a three-phase pipeline (requirements -> design -> tasks). It suits greenfield work but adds friction to small fixes on legacy code. Kiro later added "Design-first" and "Bugfix" workflows, and it meters usage with credits. — [codemyspec: Spec Kit vs Kiro](https://codemyspec.com/blog/spec-kit-vs-kiro); [particula.tech: Spec Kit vs Kiro vs Tessl](https://particula.tech/blog/spec-driven-development-tools-spec-kit-vs-kiro-vs-tessl)
- Counter-evidence (vendor benchmark): across 50 production Python tickets, Kiro merged 41/50 and Spec Kit 40/50, at a cost per merged ticket of $2.35 (Kiro) vs $3.33 (Spec Kit). The spec "paid back" on feature and data-pipeline tickets but not on the smallest ones. Treat as a single vendor-run benchmark; some table text in the source was garbled. — [Uvik: SDD Benchmark 2026](https://uvik.net/spec-driven-development-benchmark/)
- Enterprise critique: SDD tools are said to fail in enterprise settings because of the mismatch with existing processes and documentation. — [martinelli.ch](https://martinelli.ch/why-spec-driven-development-tools-fail-in-the-enterprise/)
- **Most recent status (June-September 2026; secondary sources, star counts approximate):**
  - GitHub Spec Kit reportedly passed 115k stars by June 2026 (about 80k in early 2026) and reached v1.0.1 in August 2026.
  - OpenSpec has about 52-56k stars (June 2026) and is called the "most actively maintained" SDD framework.
  - Kiro's pricing page (September 2026): free tier of 50 credits/month, paid tiers $20-$200/user/month.
  - Kiro is described as the replacement for Amazon Q Developer, which is being sunset. One source gives a 2026-05-07 date, but this is unverified; Kiro was first previewed in July 2025.
  - I found no October 2026 data.
  - [ssojet SDD tools](https://ssojet.com/blog/best-spec-driven-development-tools); [augmentcode 2026](https://www.augmentcode.com/tools/best-spec-driven-development-tools); [levelop](https://levelop.dev/blog/spec-driven-development-tools-compared); [dev.to SDD in 2026](https://dev.to/krlz/spec-driven-development-in-2026-what-it-is-the-tooling-and-how-teams-actually-use-it-2fk2)
- Within this landscape, HumanLayer's "Research -> Plan -> Implement" is the most-cited practitioner variant. It recommends human review of plans and research rather than code ("reviewing a 200-line plan" vs "2,000 lines of code"). — [HumanLayer ACE-FCA](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)

### Inferences
- The market is converging on "lightweight spec/plan + human review of the plan" (plan mode, OpenSpec, RPI) rather than heavy ceremony (BMAD, full Spec Kit). The heavy frameworks cost 2-10x more tokens and time on small tasks.
- Cost-effective rule: scale the ceremony to the size of the task. Use direct prompting or plan mode for bugfixes and small edits, and a spec only for multi-file features or shared, auditable work on teams.

### Gaps
- I found no independent, peer-reviewed data on SDD adoption (number of users or companies). GitHub star counts for Spec Kit, BMAD and Agent OS were not verified in this session.
- I did not collect specifics on Tessl (spec registry, "spec-as-source") or Agent OS (Builder Methods) beyond names in comparison posts.

## 2. Context files and conventions: AGENTS.md, CLAUDE.md, rules, skills, plugins, community frameworks

### Takeaway
AGENTS.md is now the de facto cross-tool standard and is governed by the Linux Foundation's Agentic AI Foundation (Dec 2025). The best empirical evidence (ETH Zurich, ICLR 2026) shows that context files, especially LLM-generated ones, do not improve and can reduce task success while raising inference cost by about 20%. The recommendation is minimal, human-written files covering only non-obvious requirements. Claude Code's skills (progressive disclosure), subagents and plugins are the main extension ecosystem. Community frameworks such as Superpowers are hugely popular, but their cost and quality claims are unaudited.

### Cited Findings
- AGENTS.md was contributed by OpenAI to the Agentic AI Foundation (AAIF), announced by the Linux Foundation on 2025-12-09. The other founding projects were Anthropic's MCP and Block's goose. — [OpenAI](https://openai.com/index/agentic-ai-foundation/); [SiliconANGLE 2025-12-09](https://siliconangle.com/2025/12/09/linux-foundation-announces-agentic-ai-foundation-joined-anthropic-openai-block/); [InfoQ](https://infoq.com/news/2025/12/agentic-ai-foundation/)
- Adoption: 40,000+ open-source projects used AGENTS.md at the AAIF launch, and later secondary sources say 60,000+. AAIF membership was reportedly 146 by 2026-02-24 (secondary source). — [SiliconANGLE](https://siliconangle.com/2025/12/09/linux-foundation-announces-agentic-ai-foundation-joined-anthropic-openai-block/); [danielvaughan codex blog](https://codex.danielvaughan.com/2026/04/07/agents-md-open-standard-cross-tool-portability)
- ETH Zurich / LogicStar study (arXiv 2602.11988, ICLR 2026), "Evaluating AGENTS.md":
  - LLM-generated context files reduced success by about 0.5% (SWE-bench Lite) and about 2% (AgentBench), and increased inference cost by more than 20%.
  - Developer-written files gave only a marginal gain (about 4% on AgentBench).
  - Mechanism: agents obey the files and do more exploration and testing, without solving more issues.
  - Context files helped when the repo's existing docs were removed, which suggests the files are redundant with existing docs.
  - Recommendation: write only minimal, non-standard requirements.
  - [arXiv 2602.11988](https://arxiv.org/html/2602.11988v1); [ICLR listing](https://iclr.cc/virtual/2026/10018749)
- Claude Code skills use progressive disclosure: only the name and description are loaded at startup (about 30-50 tokens per skill), and the full body loads when the skill is relevant. Skills have no model field and run on the session model, so routing work to Haiku requires a subagent. Subagents do not inherit parent skills. These are third-party docs. — [claude-skills-guide](https://claude-skills-guide-3lc.pages.dev/progressive-disclosure-pattern-claude-code-skills/); [weihaoqu wiki](https://weihaoqu.github.io/learnAIDoc/wiki/claude-code-route-to-cheaper-models/)
- Superpowers (Jesse Vincent / obra) is a Claude Code plugin and skills framework. Its skills include:
  - brainstorming (Socratic design refinement)
  - writing-plans and executing-plans
  - test-driven-development (enforced red-green-refactor)
  - subagent-driven-development (a fresh subagent per task with two-stage review: spec compliance, then code quality)
  - dispatching-parallel-agents
  - writing-skills

  It reportedly had more than 93k GitHub stars by March 2026 (third-party figure, unverified). — [emelia.io guide](https://emelia.io/hub/superpowers-claude-code-framework); [obra/superpowers](https://github.com/obra/superpowers)
- Cursor's June 2025 pricing change turned every rule and context token into a direct dollar cost: the request caps became a usage credit pool at API rates ($20 of non-Auto usage on Pro). — [Vantage: Cursor pricing explained](https://vantage.sh/blog/cursor-pricing-explained); [fintechweekly](https://www.fintechweekly.com/magazine/articles/cursor-pricing-change-user-backlash-refund)

### Inferences
- A large CLAUDE.md or AGENTS.md is a recurring per-turn cost, even with prompt caching, and it pushes the agent toward extra exploration steps. Keep root files short (build/test commands, non-obvious conventions, gotchas). Move procedures into on-demand skills or docs, which is progressive disclosure.
- Heavy community frameworks such as SuperClaude, claude-flow and BMAD add many commands, personas and agents. By the ETH logic they risk the same "obedient over-exploration" cost. Superpowers is the most practitioner-endorsed of them because its skills load on demand.

### Gaps
- I found no measured token-overhead data for SuperClaude, claude-flow (ruvnet) or Superpowers. Their claims of hours-long autonomous runs come from their authors and fans.
- Cline/Roo "memory bank" conventions and Cursor `.cursor/rules` (MDC) were not researched in depth in this session.
- I found no empirical evaluation of Claude Code hooks for cost or quality. Hooks are commonly used for deterministic lint, test and format gates, but I have no source for that in this session.

## 3. Parallel agents: worktrees, background/cloud agents, orchestrators, and real costs

### Takeaway
Parallelism is mainstream among power users: local worktrees plus cloud agents such as the Copilot coding agent, Codex cloud, Jules, Devin and Cursor background agents. The binding constraint reported by practitioners is human review capacity, not compute. Primary-source evidence (Anthropic, Cognition) says multi-agent systems cost about 15x the tokens of chat and are a poor fit for coding, which is less parallelizable than research. Extreme orchestrators (Yegge's Gas Town) burn roughly $100/hour.

### Cited Findings
- Anthropic (2025-06-13), on its multi-agent research system:
  - Agents use about 4x the tokens of chat, and multi-agent systems about 15x.
  - Token usage alone explains about 80% of performance variance on BrowseComp.
  - "Most coding tasks involve fewer truly parallelizable tasks than research."
  - [Anthropic Engineering](https://www.anthropic.com/engineering/multi-agent-research-system)
- Cognition, "Don't Build Multi-Agents" (Walden Yan, 2025-06-12):
  - Principles: (1) share full context and traces, not just messages; (2) actions carry implicit decisions, and parallel subagents make conflicting ones.
  - Recommendation: a single-threaded linear agent, plus a context-compression model for long tasks.
  - Claude Code's subagents are cited as acceptable because they do not run in parallel with the main agent, mostly answer well-scoped questions rather than write code, and keep investigation out of the main context.
  - [Cognition](https://cognition.com/blog/dont-build-multi-agents)
- Simon Willison (2025-10-05), "Embracing the parallel coding agent lifestyle":
  - Runs several agents across checkouts and worktrees.
  - Good uses: research/proof-of-concept tasks (throwaway code) and low-stakes maintenance such as fixing deprecation warnings.
  - The bottleneck is reviewing the output.
  - He recommends running local agents in Docker containers.
  - [simonwillison.net](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/)
- Steve Yegge's Gas Town (released around 2026-01) is a Go orchestrator for 20-30 parallel Claude Code instances in role hierarchies. Commentators repeatedly cite about $100/hour of tokens, about 10x a solo session. Yegge reportedly ran three Claude Max accounts at once, or exhausted three in launch week; sources differ. These are secondary sources. — [danielvaughan](https://codex.danielvaughan.com/2026/04/08/gas-town-multi-agent-factory/); [gadgetbytenepal](https://www.gadgetbytenepal.com/steve-yegge-gas-station)
- Geoffrey Huntley's "Ralph" loop is `while :; do cat PROMPT.md | claude ; done`. He claims software development now costs about "$10.42/hour". His showcase is the CURSED language, built over about 3 months of looping. Third-party reports include YC hackathon teams shipping 6+ repos overnight for $297 of API spend. — [The Register 2026-01-27](https://www.theregister.com/2026/01/27/ralph_wiggum_claude_loops); [ralph-orchestrator docs](https://mikeyobrien.github.io/ralph-orchestrator/concepts/ralph-wiggum-technique)
- Cloud-agent pricing models:
  - GitHub Copilot coding agent: 1 premium request per session from 2025-07-10. Reportedly replaced by "AI Credits" ($0.01 each) in June 2026 (secondary sources).
  - Devin: billed in ACUs (about 15 minutes of work each, about $2-2.25 per ACU), which reviewers find hard to predict on looping tasks.
  - Jules: bundled with Google AI plans.
  - [GitHub changelog](https://github.blog/changelog/2025-07-10-github-copilot-coding-agent-now-uses-one-premium-request-per-session/); [digitalapplied June 2026](https://www.digitalapplied.com/blog/ai-coding-tool-pricing-june-2026-seat-economics-guide); [metavert](https://metavert.io/github-copilot-vs-cognition-ai-devin)
- HumanLayer: a 3-person team averages about $12k/month on Opus, which is roughly $4k per engineer per month. — [HumanLayer ACE-FCA](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)

### Inferences
- For cost-conscious teams, the evidence-backed pattern is:
  - one main agent (single-threaded) per task;
  - read-only subagents for search and summary (cheap, context-isolating);
  - parallelism only across independent tasks, each in its own worktree or cloud agent, sized to the human's review capacity.
- Writing code in parallel within one task conflicts with Cognition's principles.

### Gaps
- I found no rigorous public study on the ROI of parallel agents (merged PR quality per dollar). Practitioner reports are anecdotal.
- Cursor background agents and Codex cloud pricing details were not verified in this session.

## 4. Model routing: cheap vs frontier models, architect/editor mode, routers

### Takeaway
Splitting planning and reasoning (strong model) from editing and execution (cheaper model) has the best benchmark support: Aider's architect/editor results. It is productized in Claude Code (per-subagent `model`, Haiku-backed Explore subagent, `opusplan`) and in Codex and Cursor model choices. Reported savings from routing to Haiku are large but come from blog case studies.

### Cited Findings
- Aider architect/editor (2024-09-26), on Aider's code editing benchmark:
  - o1-preview as architect with o1-mini or DeepSeek as editor scored 85.0% (whole-file format, slow), vs o1-preview solo at 79.7%.
  - o1-preview + Claude 3.5 Sonnet (diff): 82.7%.
  - Sonnet + Sonnet: 80.5% vs Sonnet solo at 77.4%.
  - GPT-4o + GPT-4o: 75.2% vs 71.4% solo.
  - DeepSeek was a strong, cheap editor.
  - [Aider blog](https://aider.chat/2024/09/26/architect.html)
- Aider (January 2025): DeepSeek R1 as architect + Claude 3.5 Sonnet as editor set a new SOTA on the polyglot benchmark at "14X less cost" than o1. I saw this via feed snippets, not the full post. — [aider.chat feed](https://rss-parrot.net/web/feeds/aider.chat)
- Claude Code:
  - Subagents accept `model: haiku|sonnet|opus|inherit`, and `CLAUDE_CODE_SUBAGENT_MODEL` overrides it.
  - The built-in Explore subagent runs on Haiku.
  - `opusplan` = Opus for plan, Sonnet for execution.
  - Blog case studies claim 60-92% savings by routing bounded or read-only work to Haiku. These are unaudited.
  - One blog reports "Haiku + skills (27.7%) beat Opus without skills (22.0%)" on an unspecified benchmark (unverified).
  - [weihaoqu wiki](https://weihaoqu.github.io/learnAIDoc/wiki/claude-code-route-to-cheaper-models/); [dev.to: "How I cut my AI usage by 60%"](https://dev.to/owenyuwono/how-i-cut-my-ai-usage-by-60-and-got-better-code-1h40); [skillsmp model-routing skill](https://skillsmp.com/skills/markus41-claude-plugins-claude-code-expert-skills-model-routing-skill-md)
- Codex CLI cost guidance also centers on model and reasoning-effort routing and quota control. — [danielvaughan: Codex CLI cost management](https://codex.danielvaughan.com/2026/03/28/codex-cli-cost-management-token-strategy/)
- Anthropic: token usage explains about 80% of variance and model choice is the other main factor. Spending more tokens on harder tasks helps; it does not imply using the frontier model everywhere. — [Anthropic Engineering](https://www.anthropic.com/engineering/multi-agent-research-system)

### Inferences
- Practical routing: frontier model for plan and review; mid-tier for implementation; cheap model for search, summarization, log reading and mechanical edits. This mirrors Aider's architect/editor results (a 3-8 point gain at lower editor cost).
- Gateway routers (OpenRouter, LiteLLM) are mainly used for provider flexibility, budgets and observability. I found no evidence that automatic "smart routers" beat explicit role-based routing for coding.

### Gaps
- I found no primary data on the cost/quality effect of OpenRouter or LiteLLM auto-routing for coding agents.
- I did not fetch Aider's current polyglot leaderboard (2025-2026 models).

## 5. Practitioner write-ups on token spend and workflow

### Takeaway
The respected practitioners converge on context discipline rather than more agents:
- keep context utilization moderate (HumanLayer: 40-60%);
- compact intentionally into artifacts (research.md, plan.md, progress);
- review plans, not just code;
- use subagents for context isolation;
- use simple loops (Ralph) with strong tests;
- treat human review as the scarce resource.

Rigorous productivity evidence is mixed (METR: -19%).

### Cited Findings
- HumanLayer, "Advanced Context Engineering for Coding Agents" (Dex Horthy, about August 2025):
  - Research -> Plan -> Implement, with "frequent intentional compaction".
  - Keep context utilization at 40-60%.
  - Use generic subagents for search and read so the parent context stays clean.
  - Claimed results: fixed a bug in BAML (300k LOC Rust) as a Rust novice; shipped about 35k LOC in about 7 hours (estimated at 3-5 senior-days per feature).
  - Failures: a race-condition fix and removing Hadoop from parquet-java, which the author attributes to shallow research.
  - Cost: about $12k/month for 3 people on Opus.
  - [HumanLayer repo](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)
- Cognition (Walden Yan, June 2025): prefer a single linear agent with compression; multi-agent coding is fragile. — [Cognition](https://cognition.com/blog/dont-build-multi-agents)
- Simon Willison (October 2025): parallel agents work for research and low-risk chores; the bottleneck is review; use sandboxing (Docker). — [simonwillison.net](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/)
- Armin Ronacher: favor simple code and simple ecosystems (Go, "basic Python" reported to work well); prompt injection is an unsolved risk. This came only from a secondary summary and is unverified against his original posts. — [gist summary](https://gist.github.com/fry69/79bd6897f185df7671edea5699e33a4c)
- Geoffrey Huntley's Ralph: a brute-force loop on one prompt with persistent spec and plan files, claimed at about $10.42/hour. — [The Register](https://www.theregister.com/2026/01/27/ralph_wiggum_claude_loops)
- Steve Yegge's Gas Town: maximal parallelism at about $100/hour (secondary sources), described even by sympathetic coverage as "chaotic". — [gadgetbytenepal](https://www.gadgetbytenepal.com/steve-yegge-gas-station); [daviderutigliano](https://daviderutigliano.github.io/portfolio-website/posts/2026/01/gas-town-the-industrial-revolution-of-vibe-coding/)
- METR RCT (published 2025-07-10):
  - 16 experienced open-source developers, 246 tasks on their own mature repos, mainly Cursor + Claude 3.5/3.7 Sonnet.
  - Developers were 19% slower with AI, yet believed they were about 20% faster (they had forecast +24%).
  - Small sample, early-2025 tools.
  - [arXiv 2507.09089](https://arxiv.org/abs/2507.09089); [eWeek](https://eweek.com/news/news-ai-tools-slow-developer-productivity-study)
- **Stack Overflow 2026 survey (primary, most recent).** Question: "coding agents or assistants used in the past year", n=12,255.

  | Tool | Share |
  |---|---:|
  | Claude Code | 65.5% |
  | GitHub Copilot | 58.7% |
  | OpenAI Codex | 29.5% |
  | Cursor | 25.5% |
  | Google Antigravity | 16.0% |
  | Gemini Code Assist | 14.6% |
  | OpenCode | 13.6% |
  | JetBrains AI | 12.8% |
  | Windsurf | 6.5% |
  | Cline | 4.5% |
  | Amazon Q Developer | 3.9% |
  | Devin | 2.9% |
  | Jules | 2.5% |
  | Aider | 2.1% |

  — [Stack Overflow Survey 2026](https://survey.stackoverflow.co/2026/ai/data/ai-code-agent)
- JetBrains Developer Ecosystem 2026 (May-July 2026, 15k+ developers): use at work was Claude Code 39%, Copilot 21%, Codex 16%, Cursor 12% (down from 18%). It reports that about 90% of developers use agents weekly. This is a secondary summary that I did not verify against JetBrains directly. — [syntior: surveys 2026](https://www.syntior.com/updates/ai-coding-agents-developer-surveys-2026); [digitalapplied adoption 2026](https://www.digitalapplied.com/blog/ai-coding-tool-adoption-2026-developer-survey)
- The 2025 Stack Overflow figures below are older (mid-2025) and show a much earlier stage, when only about 14% used agents daily. Agent use rose sharply between the 2025 and 2026 surveys.
- Stack Overflow 2025 Developer Survey (fielded May-June 2025, released 2025-07-29), older data:
  - 84% use or plan to use AI (76% in 2024).
  - 46% distrust AI accuracy (up from 31%); only about 3% "highly trust".
  - About 52% don't use agents or prefer simpler tools; about 14% use agents daily.
  - 87% worry about agent accuracy.
  - Among agent users, 70% report time saved but only 38% report better code quality.
  - Claude Sonnet was the most admired model.
  - [InfoWorld](https://infoworld.com/article/4031673/ai-use-among-software-developers-grows-but-trust-remains-an-issue-stack-overflow-survey.html); [The Decoder](https://the-decoder.com/developers-rely-on-ai-tools-more-than-ever-but-trust-is-slipping/); [devops.com](https://devops.com/stack-overflow-survey-shows-ai-adoption-for-devs/)

### Inferences
- The highest-leverage, lowest-cost practices are:
  - strict context hygiene (small context files, fresh sessions, compaction into files);
  - plan review before implementation;
  - strong automated verification (tests and lint as the agent's feedback loop).
- Adding agents or framework ceremony is the costliest lever and has the weakest evidence.

### Gaps
- Mitchell Hashimoto's and Thorsten Ball's (Amp) specific recommendations were not retrieved in this session. Amp's stance (for example, no model picker and pay-per-use pricing) is unverified here.
- HumanLayer's "12-factor agents" (about building agents, not coding with them) was not fetched.
- I found no rigorous 2026 replication of METR with newer models in this session.

## 6. Tool comparison relevant to cost: Claude Code vs Codex CLI vs Cursor vs Aider vs Gemini CLI; subscriptions vs API

### Takeaway
Subscriptions (Claude Max at $100/$200, ChatGPT Plus/Pro for Codex, Cursor Pro/Ultra) are far cheaper than API billing for heavy agent users, but they are governed by opaque and changing rate limits: a 5-hour window plus weekly caps since August 2025. Codex is widely reported as more token-efficient (2-4x, mostly vendor or anecdotal figures). Claude Code is generally rated higher on code quality. Many practitioners use both.

### Cited Findings
- Claude Code limits:
  - Two overlapping limits: a 5-hour rolling window and a weekly cap introduced in late August 2025. Anthropic said the cap would affect fewer than 5% of subscribers.
  - Max 20x is marketed as "20x Pro", but a critic estimated about 6x in Claude Code hours.
  - Five-hour limits were reportedly doubled around 2026-05-06 (sources conflict on the timeline).
  - All subagents share the same rate-limit allocation.
  - `/cost` is misleading for subscriptions (issue #1287). ccusage reconstructs local usage per 5-hour block.
  - Above the limit, "extra usage" bills at API rates.
  - [Portkey: Everything we know about Claude Code limits](https://portkey.ai/blog/claude-code-limits); [Techloy](https://www.techloy.com/claudes-code-popularity-is-forcing-anthropic-to-limit-access/); [alexcloudstar 2026](https://alexcloudstar.com/md/blog/claude-code-usage-limits-2026/)
- **Latest Claude plan changes (October 2026; third-party reports of Anthropic's announcement):**
  - 2026-10-30: Max 5x was renamed "Max" ($100) and Max 20x "Ultra" ($200), with prices unchanged.
  - The 5-hour limit is being removed for verified Ultra accounts. The pricing page now lists Ultra at "10x Pro weekly usage"; the old wording was 20x Pro per 5-hour session.
  - From 2026-10-07, Max and Ultra include $100 and $200/month of Claude API credits. One source says these cover the Agent SDK and `claude -p` but not interactive Claude Code.
  - A "June 2026 billing change" was reportedly paused as of 2026-10-26; its details are unclear.
  - The limit history above (August 2025 weekly caps, May 2026 doubling) is older context.
  - [CellCog 2026-10-30](https://cellcog.ai/blog/claude-max-ultra-rename/); [codersera Oct 2026](https://codersera.com/blog/anthropic-june-2026-billing-change-claude-code/); [Digg](https://digg.com/ai/e1dnwnjk)
- Codex vs Claude Code:
  - Codex is commonly claimed to use 2-4x fewer tokens. One anecdote: an Express.js refactor took about 1.5M tokens (about $15) with Codex vs 6.2M (about $155) with Claude.
  - Claude Code won about 67% of blind code-quality reviews (one source).
  - At the $20 tier, Claude Code hits limits sooner, so moderate users move to Max at $100.
  - A self-selected Reddit poll showed about 65% preferring Codex day-to-day.
  - Common advice: Claude Code for complex features, Codex for routine or batch work.
  - [hongkiat](https://www.hongkiat.com/blog/codex-vs-claude-code-2026/); [nxcode](https://nxcode.io/resources/news/claude-code-vs-codex-cli-terminal-coding-comparison-2026); [termdock](https://termdock.com/en/blog/claude-code-vs-codex-cli); [inventivehq](https://inventivehq.com/blog/codex-cli-vs-claude-code-2026); [codeongrass](https://codeongrass.com/blog/cursor-vs-claude-code-vs-codex-2026-honest-breakdown/)
- Cursor:
  - In June 2025, Cursor moved from 500 requests to a credit pool at API rates ($20 on Pro) plus unlimited "Auto".
  - The backlash led to an apology and refunds on 2025-07-04 for charges from June 16 to July 4.
  - Adoption kept growing despite the backlash.
  - [Vantage](https://vantage.sh/blog/cursor-pricing-explained); [fintechweekly](https://www.fintechweekly.com/magazine/articles/cursor-pricing-change-user-backlash-refund); [wearefounders timeline](https://www.wearefounders.uk/cursors-pricing-disaster-the-full-timeline-of-how-an-ai-coding-darling-burned-its-most-loyal-users/)
- Market-wide in 2026, GitHub moved Copilot to AI Credits ($0.01 each) in June 2026, part of a broader shift from flat "requests" to usage-metered credits (secondary). — [digitalapplied](https://www.digitalapplied.com/blog/ai-coding-tool-pricing-june-2026-seat-economics-guide); [Tokenomics #1](https://dannguyenhuu.substack.com/p/tokenomics-1-the-pricing-evolution)
- Model popularity: GPT models were most used (81.4%) and Claude Sonnet most admired in the Stack Overflow 2025 survey. — [ADTmag](https://adtmag.com/blogs/watersworks/2026/01/stack-overflow-survey.aspx); [devops.com](https://devops.com/?p=178436)

### Inferences
- For an individual developer or small team, the cheapest high-quality setup is a flat subscription (Claude Max or ChatGPT Pro/Plus), using:
  - in-tool model routing (Haiku/Sonnet subagents, opusplan, lower reasoning effort for routine work);
  - lean context;
  - optionally a second vendor's CLI for overflow or cross-review.
- API billing makes sense mainly for CI and headless automation, or when spend must be attributed per project.
- Aider (bring-your-own-key, architect mode) and Gemini CLI (generous free tier) are cost-control options. Specific current numbers were not verified here.

### Gaps
- Current official Max, ChatGPT Pro and Gemini CLI quota numbers were not verified from vendor pages. Most figures come from third-party blogs and change often (2026-05 changes reported).
- I found no independent, controlled benchmark of the same tasks across Claude Code, Codex, Cursor, Aider and Gemini CLI measuring both cost and quality. The 4x and 67% figures are vendor or blog claims.
