# Anthropic's official recommendations for agentic software development and cost/performance with Claude (as of 2026-10-31)

Retrieval note: all docs pages (platform.claude.com, code.claude.com) were fetched live on 2026-10-31, so they show current content. The engineering posts carry their own publication dates, listed below. Several 2024-2025 recommendations have been **explicitly superseded** by the current Claude Code docs. These are flagged as SUPERSEDED or MAY BE OUTDATED. Old URLs on docs.claude.com / docs.anthropic.com now redirect: Claude Code docs go to code.claude.com/docs, and API docs go to platform.claude.com/docs.

Engineering index, for posts and dates: [anthropic.com/engineering](https://www.anthropic.com/engineering). The posts relevant to this topic, newest first:
- Apr 23, 2026, "An update on recent Claude Code quality reports"
- Apr 8, 2026, "Scaling Managed Agents: Decoupling the brain from the hands"
- Mar 25, 2026, "How we built Claude Code auto mode"
- Mar 24, 2026, "Harness design for long-running application development"
- Feb 5, 2026, "Building a C compiler with a team of parallel Claudes"
- Feb 5, 2026, "Quantifying infrastructure noise in agentic coding evals"
- Jan 9, 2026, "Demystifying evals for AI agents"
- Nov 26, 2025, "Effective harnesses for long-running agents"
- Nov 24, 2025, "Advanced tool use"
- Nov 4, 2025, "Code execution with MCP"
- Oct 20, 2025, "Claude Code sandboxing"
- Oct 16, 2025, "Agent Skills"
- Sep 29, 2025, "Effective context engineering"
- Sep 11, 2025, "Writing effective tools"
- Jun 13, 2025, "Multi-agent research system"
- Apr 18, 2025, "Claude Code: Best practices for agentic coding"
- Mar 20, 2025, "think tool"

## Q1: What the Anthropic engineering posts and current Claude Code docs recommend for workflow patterns and context management

### Takeaway
The principle running through every source from 2024 to 2026 is to "find the simplest solution possible" and add complexity (more agents, harness parts, context tricks) only when it measurably pays. In 2026 the advice changed on two points. Current models have 1M-token windows and compact automatically, so the docs now say context is "rarely the problem," and they recommend subagents for parallel work, keeping noisy output out of the main session, and independent review, not to protect the context window. The levers the current docs emphasize are a short CLAUDE.md, giving Claude a verifiable check to run, hooks for rules that cannot have exceptions, effort level instead of "think hard" phrases, `/clear` between tasks, and a cache-aware workflow.

### Cited Findings

**Building effective agents (Dec 19, 2024; the page itself notes that much of the tooling it describes has since changed)**
- Workflows "orchestrate LLMs and tools through predefined code paths." Agents "dynamically direct their own processes and tool use." Recommends "finding the simplest solution possible" and adding complexity only when needed. Agentic systems trade latency and cost for task performance. — [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- Patterns covered: prompt chaining, routing, parallelization (sectioning and voting), orchestrator-workers, evaluator-optimizer. Agents fit open-ended problems with unpredictable step counts. They bring higher cost and compounding errors, so they need sandboxed testing and guardrails. Workflows fit well-defined tasks. — [same](https://www.anthropic.com/engineering/building-effective-agents)
- Three principles: keep the design simple, make planning transparent, and carefully craft the agent-computer interface (ACI). Frameworks can obscure prompts, so start with the APIs directly. SWE-bench poka-yoke example: requiring absolute file paths eliminated the model's mistakes. — [same](https://www.anthropic.com/engineering/building-effective-agents)

**Current Claude Code best practices (code.claude.com, live Oct 2026; supersedes the Apr 18, 2025 engineering post "Claude Code: Best practices for agentic coding")**
- Defaults now handle a lot without setup. New terminal and VS Code sessions start in **auto mode**, where a classifier reviews risky commands. Claude delegates to subagents on its own, which run in the background by default. Conversations are "compacted automatically before the context window fills." — [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices)
- Deterministic versus non-deterministic instructions: prompts, CLAUDE.md, and skills are suggestions the model may skip. Hooks, deny rules, and managed settings are always enforced. "If you keep adding emphasis to a `CLAUDE.md` line and Claude still misses it, that's a sign the line belongs in a hook." — [same](https://code.claude.com/docs/en/best-practices)
- Specific prompts: for example, "users report login fails after the session times out. look at token refresh in src/auth/, write a failing test that reproduces it, then fix it" in place of "fix the login bug." — [same](https://code.claude.com/docs/en/best-practices)
- Brainstorm or spec first: "Interview me until you could write the spec, then write it to SPEC.md". Then "start a fresh session to build from it, so the build begins with a clean context and a written definition of done." — [same](https://code.claude.com/docs/en/best-practices)
- Keep CLAUDE.md short. Include only what Claude can't infer: the exact test, typecheck, and lint commands; places where the code is misleading; decisions that aren't in the repo; "Anything you've had to correct twice already." `/init` generates a starting file, after which the work "is mostly removing lines." Stay under 200 lines. `/doctor prompt-audit` flags outdated or contradictory instructions. Put personal preferences in `CLAUDE.local.md`. — [same](https://code.claude.com/docs/en/best-practices)
- Give Claude a check to run (verification). Without one, "you [are] the test suite." Options are a prompt such as "run the auth tests after, and keep going until they pass", `/goal`, where a separate model checks the condition after every turn, `/code-review`, which reviews in a fresh subagent that never saw the conversation, and `/verify`, which builds and runs the app. Ask for *evidence*, meaning the command and its output. A reviewer prompt should include "skip style", because "A reviewer that's asked to find problems will always find *something*." — [same](https://code.claude.com/docs/en/best-practices)
- Steering: "Watch the first minute, press `Esc` the moment Claude drifts, and after two failed corrections run `/clear` and write a better prompt instead of a third." Other tools are `/rewind` checkpoints, `/btw` for side questions that stay out of history, and `/rename` with `--resume`. — [same](https://code.claude.com/docs/en/best-practices)
- Five questions before an unattended or headless run: (1) does it know what done looks like, (2) can it check its own work, (3) what can it touch, (4) what stops it (`--max-turns`, `--max-budget-usd`, a spend limit), (5) where does the result go and who signs off. `claude -p` covers CI, hooks, and loops. `--bare` skips hooks, skills, plugins, MCP, and CLAUDE.md for reproducible runs. — [same](https://code.claude.com/docs/en/best-practices)
- Parallel sessions: `claude -w <name>` gives each session its own git worktree, and `.worktreeinclude` copies gitignored files like `.env` into it. `/batch` splits a large mechanical change into 5 to 30 units, each in its own worktree with its own PR. "A second session is also the easiest independent reviewer you can get" (writer/reviewer pattern). — [same](https://code.claude.com/docs/en/best-practices)
- **Explicitly SUPERSEDED advice** (the docs' "What you can stop doing" table):
  - "The context window is your main constraint, manage it aggressively." The docs reply: "Most current models have a 1M-token window and compaction happens on its own, so running out is rare."
  - "Use subagents to protect your context window."
  - "Delegate to a subagent for a better answer." The docs say it doesn't help, although a fresh *reviewer* does.
  - IMPORTANT / ALL CAPS emphasis.
  - "think hard / think harder" phrases. "Effort is the control for that". `ultrathink` still works for a single turn.
  - "keep going / don't be lazy" lines.
  - "Describe your architecture and file layout in CLAUDE.md."

  — [same](https://code.claude.com/docs/en/best-practices)
- Subagents: broad searches go to the built-in Explore agent. Side tasks get forked while fork mode is on, which is the default. Subagents pay off for parallel independent work, for keeping long output out of the main session, for an unbiased reviewer, and for restricted tool sets (for example `tools: Read, Grep, Glob`). Their cost: "mostly tokens… a fresh subagent first has to gather context… can end up *slower*," and "it's the same model (or a smaller one) on the same task… not a smarter answer." — [same](https://code.claude.com/docs/en/best-practices)

**Effective context engineering (Sep 29, 2025)**
- "Context, therefore, must be treated as a finite resource with diminishing marginal returns". Context rot means recall degrades as the window fills, in all models. The goal is "the smallest set of high-signal tokens that maximize the likelihood of your desired outcome." — [Effective context engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- System prompts should be pitched at the right "altitude", between brittle hardcoded logic and vague guidance. Use minimal, non-overlapping tool sets, because "bloated tool sets" are a common failure. Use a few canonical examples instead of a long list of edge-case rules. — [same](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- Long-horizon techniques:
  - Just-in-time retrieval: keep lightweight references (file paths, queries, links) and load data when needed, or use a hybrid.
  - Compaction: tune it for recall first, then precision.
  - Tool-result clearing: the "lightest-touch" form of compaction.
  - Structured note-taking: for example NOTES.md or a to-do list.
  - Sub-agents that return condensed summaries of about 1,000 to 2,000 tokens.
  - The memory tool (file-based, public beta on the Claude Developer Platform).

  — [same](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- Start with a minimal prompt on the best model and add instructions based on observed failures. — [same](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

**Multi-agent research system (Jun 13, 2025)**
- "agents typically use about 4× more tokens than chat interactions," and multi-agent systems use about **15×** the tokens of chat. Token usage alone explains 80% of BrowseComp variance. — [Multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- An Opus 4 lead with Sonnet 4 subagents "outperformed single-agent Claude Opus 4 by 90.2%" on an internal research eval. Parallel subagent and tool calls cut research time by up to 90%. — [same](https://www.anthropic.com/engineering/multi-agent-research-system)
- Worth it only when "the value of the task is high enough to pay for the increased performance". Good fits are tasks that parallelize heavily, exceed one context window, or use many tools. Poor fits are tasks with shared context or many dependencies. **Coding** "involve[s] fewer truly parallelizable tasks than research." — [same](https://www.anthropic.com/engineering/multi-agent-research-system)
- Lessons:
  - Give each subagent a detailed task spec: objective, output format, tools, boundaries.
  - Embed effort-scaling rules, for example one agent for a simple lookup.
  - A rewritten tool description cut task time by 40%.
  - Start searches broad, then narrow.
  - Use thinking as a scratchpad.

  — [same](https://www.anthropic.com/engineering/multi-agent-research-system)

**Long-running agent harnesses (Nov 26, 2025, and Mar 24, 2026)**
- Nov 2025: the harness pairs an initializer agent with a coding agent. The initializer writes `init.sh`, a JSON feature list (200+ features, each starting at `"passes": false`, with the warning "It is unacceptable to remove or edit tests"), `claude-progress.txt`, and an initial git commit. Each coding session works on one feature and ends with a commit and a progress update. End-to-end testing through browser automation (Puppeteer MCP) "substantially improved results." JSON was chosen over Markdown because models are less likely to wrongly overwrite it. — [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- Mar 2026: a planner, generator, and evaluator architecture. The evaluator tests the running app with Playwright against hard pass/fail thresholds. A "sprint contract" is negotiated between generator and evaluator, and the agents communicate through files. Separating evaluation from generation helps because agents overrate their own work. — [Harness design for long-running apps](https://www.anthropic.com/research/harness-design-long-running-apps)
- Cost data from the same post: a solo Opus 4.5 run took 20 minutes and cost $9, and the core feature was broken. The full harness took 6 hours and cost $200 (>20×) and produced a much more functional app. A DAW build with the V2 harness on Opus 4.6 took about 3h50m and cost $124.70. — [same](https://www.anthropic.com/research/harness-design-long-running-apps)
- Components became unnecessary as models improved. Context resets were dropped with Opus 4.5, which showed no "context anxiety", in favor of a continuous session with auto-compaction. Sprints were dropped with Opus 4.6, and per-sprint evaluation was replaced by a single final pass. The post's rule is to strip parts that are no longer load-bearing. — [same](https://www.anthropic.com/research/harness-design-long-running-apps)

**Tools, Skills, MCP code execution**
- Writing tools (Sep 11, 2025):
  - Build a few targeted tools, not one per API endpoint.
  - Namespace them.
  - Return meaningful fields (names, not UUIDs).
  - Offer `response_format` concise or detailed (72 vs 206 tokens in their example).
  - Paginate, filter, and truncate. Claude Code caps tool responses at 25,000 tokens by default.
  - Develop tools against evaluations.

  — [Writing effective tools](https://www.anthropic.com/engineering/writing-tools-for-agents)
- Agent Skills (Oct 16, 2025; released as an open standard Dec 18, 2025): progressive disclosure in three levels. Level 1 is name and description in the system prompt. Level 2 is the SKILL.md body, loaded when the skill is relevant. Level 3 is linked files, loaded only when needed. Bundled scripts run deterministic operations without loading the script or its input into context. — [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- Code execution with MCP (Nov 4, 2025): presenting MCP tools as code files and filtering data inside the sandbox cut one workflow from "150,000 tokens to 2,000 tokens" (98.7%). Caveat: it needs a secure sandbox, which adds operational overhead. — [Code execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp)
- Advanced tool use (Nov 24, 2025):
  - Tool Search Tool: 85% fewer tokens (about 77K down to about 8.7K). MCP-eval accuracy rose from 49% to 74% on Opus 4 and from 79.5% to 88.1% on Opus 4.5. Use it when tool definitions exceed 10K tokens or there are 10+ tools.
  - Programmatic Tool Calling: 37% fewer tokens (43,588 down to 27,297).
  - Tool Use Examples: parameter accuracy rose from 72% to 90%.

  — [Advanced tool use](https://www.anthropic.com/engineering/advanced-tool-use)
- In Claude Code, MCP tool definitions are now **deferred by default** through tool search. CLI tools (`gh`, `aws`, `gcloud`) are "still more context-efficient than MCP servers." — [Manage costs](https://code.claude.com/docs/en/costs)

**Prompt caching as the core of harness design (Apr 30, 2026)**
- "Prompt caching is everything":
  - Order requests as static system prompt and tools, then CLAUDE.md, then session context, then messages.
  - Send updates as messages (`<system-reminder>`), not system-prompt edits.
  - "Don't change models mid-session". Use a subagent with a hand-off instead. The Explore agents run on Haiku this way.
  - Never add or remove tools mid-session. Plan mode is itself a tool, and MCP tools use `defer_loading: true`.
  - Compaction uses a cache-safe fork of the parent's prefix (summary of about 20k tokens).
  - Monitor cache hit rate like uptime. Claude Code treats drops as SEVs, because "a few percentage points of cache miss rate can dramatically affect cost and latency."

  — [Lessons from building Claude Code: Prompt caching is everything](https://claude.dev/blog/lessons-from-building-claude-code-prompt-caching-is-everything/)

**Plugins and marketplaces (official)**
- Anthropic's official marketplace is `claude-plugins-official` (GitHub `anthropics/claude-plugins-official`). Claude Code adds it automatically the first time an interactive terminal session starts, and it auto-updates by default. The example plugin is `commit-commands`. Plugins can also be browsed at claude.com/marketplace. A separate **community marketplace** exists, with auto-update off by default. For official-marketplace plugins, the details pane shows a "Context cost" estimate split into "Every turn" and "When invoked". `claude plugin details <name>` shows always-on token cost, and `/plugin` lists plugins "Not used recently" so they can be pruned. — [Install and manage plugins](https://code.claude.com/docs/en/discover-plugins)
- Code intelligence (LSP) plugins for typed languages are recommended to reduce token use: "A single 'go to definition' call replaces what might otherwise be a grep followed by reading multiple candidate files". They also report type errors after edits. — [Manage costs](https://code.claude.com/docs/en/costs)

### Inferences
- For a solo or small app project, the official guidance points to a single main session with a good model. Use subagents for parallel or noisy work and for independent review. Multi-agent teams make sense only for high-value, parallelizable work, because the cost multipliers are about 4×, about 7× (agent teams), and about 15× (multi-agent).
- Harness complexity should be re-checked with each model generation. Anthropic itself removed resets and sprints as models improved.
- The Apr 2025 "explore-plan-code-commit / TDD / multiple Claudes / headless" advice survives in the current docs, reworded as spec-first, verification checks, worktrees and writer/reviewer, and `claude -p` / `--bare`. Advice framed around context scarcity is now outdated.

### Gaps
- I did not re-fetch the original Apr 18, 2025 "Claude Code best practices" post. I relied on the current docs page, which the docs present as the up-to-date version. The Feb 2026 C-compiler and Apr 2026 Managed Agents posts were not read in detail.
- The memory tool and context-editing API docs (platform.claude.com) were not fetched. Their current status (beta or GA) is unverified.

## Q2: Official guidance on model selection, effort/thinking, prompt caching, batch, and Claude Code cost management

### Takeaway
The official starting point is now **Opus 5.5** at **medium** effort. Sonnet is the cheaper choice for routine work. Haiku is for simple subagents. **Fable 5.1** is for the hardest long-horizon or ambiguous tasks. `opusplan` gives Opus for planning and Sonnet for execution. **Effort** replaces thinking budgets as the main cost/quality dial. Cache reads cost 0.05× base input on Opus and Sonnet 5.5. Batch is 50% off. Enterprise Claude Code averages about $13 per developer per active day.

### Cited Findings

**Model choice**
- API docs: "If you're unsure which model to use, start with Claude Opus 5.5 for most workloads. Use Claude Fable 5.1 for demanding reasoning and long-horizon agentic work, or when your evals on Claude Opus 5.5 at higher effort still fall short." Haiku 5.5 is "For high-volume, latency-sensitive tasks such as classification, extraction, and routing." — [Models overview](https://platform.claude.com/docs/en/about-claude/models/overview)
- Claude Code: "the default Opus 5.5 handles most coding well and Sonnet costs less on routine work… Fable 5.1 is there when you select it explicitly with `/model fable`, and Haiku is a good fit for subagents doing simple jobs." — [Best practices](https://code.claude.com/docs/en/best-practices)
- Cost page: "Sonnet handles most coding tasks well and costs less than Opus. Reserve Opus for complex architectural decisions or multi-step reasoning… For simple subagent tasks, specify `model: haiku`." A switch to Opus also applies to subagents that inherit the session model. Unexpectedly high spend "usually traces back to long sessions that were never cleared or to Opus left as the default model." — [Manage costs](https://code.claude.com/docs/en/costs)
  - NOTE on tension: the cost page frames Opus as the model to reserve, while the best-practices page calls Opus 5.5 the default that "handles most coding well." This likely reflects Opus 5.5's price cut to $4/$20.
- Aliases: `default`, `best` (Fable where available, otherwise Opus), `fable`, `opus`, `sonnet`, `haiku`, `sonnet[1m]`, `opus[1m]`, and `opusplan` ("uses `opus` during plan mode, then switches to `sonnet` for execution… pairs Opus's reasoning for planning with Sonnet's efficiency for execution"). — [Model configuration](https://code.claude.com/docs/en/model-config)
  - On the Anthropic API the aliases resolve as opus = Opus 5.5, sonnet = Sonnet 5.5, haiku = Haiku 5.5.
  - Cloud providers lag. On Bedrock and Google Cloud, opus = Opus 5.5 but sonnet = Sonnet 4.5 and haiku = Haiku 4.5. On Microsoft Foundry, opus = Opus 4.6.
  - Fable guidance: "Hand it ambiguous problems: root-cause investigations, outage debugging, and architecture decisions… Describe the outcome, not the steps."
- Caveat for `opusplan`: each plan-mode toggle is a model switch and starts a fresh cache. — [Prompt caching in Claude Code](https://code.claude.com/docs/en/prompt-caching)
- Agent teams: "approximately 7x more tokens than standard sessions when teammates run in plan mode." Recommendations: use Sonnet for teammates, keep teams small, keep spawn prompts focused, and shut teammates down when done. Agent teams are disabled by default (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` enables them). — [Manage costs](https://code.claude.com/docs/en/costs)

**Effort and thinking**
- Effort levels are low, medium, high, xhigh, and max (Opus 4.6 and Sonnet 4.6 have no xhigh). In Claude Code the default is `high`, "except that Opus 5.5, Sonnet 5.5, and Haiku 5.5 default to `medium` and Opus 4.7 defaults to `xhigh`." — [Model configuration](https://code.claude.com/docs/en/model-config)
- When to use each level:
  - low: brainstorming, sketches, renames.
  - medium: everyday work with a clear scope.
  - high or xhigh: bugs in unfamiliar code, flaky tests, schema changes.
  - max: hard unattended problems such as security hunting. Max "may show diminishing returns and is prone to overthinking, so test before adopting it broadly."
  - Migration: "When you move from Opus 5 to Opus 5.5, start at `medium`."
  - `ultrathink` raises effort for one turn only.

  — [Model configuration](https://code.claude.com/docs/en/model-config); [Best practices](https://code.claude.com/docs/en/best-practices)
- Thinking can't be turned off on Opus 5.5, Sonnet 5.5, Haiku 5.5, or Fable. Thinking tokens bill as output, and "the default budget can be tens of thousands of tokens per request." `MAX_THINKING_TOKENS` applies only to fixed-budget models. "Adaptive-reasoning models ignore nonzero budgets, so use effort levels there instead." — [Manage costs](https://code.claude.com/docs/en/costs)
- API: the current models use adaptive thinking steered by effort. Manual extended thinking (`budget_tokens`) "is deprecated on Claude Opus 4.6 and Claude Sonnet 4.6 and not accepted on later models." Default API effort is high on Fable 5.1, medium on Opus 5.5, high on Sonnet 5.5, and medium on Haiku 5.5. — [Models overview](https://platform.claude.com/docs/en/about-claude/models/overview)
  - NOTE: the Sonnet 5.5 default differs between surfaces, high on the API versus medium in Claude Code.

**Prompt caching**
- Multipliers: a 5-minute cache write costs 1.25× base input, and a 1-hour write costs 2×. A cache read costs 0.1× base, except 0.05× on Opus 5.5 and Sonnet 5.5 and 0.025× on Fable 5.1 and Mythos 5.1. Caching "pays off after one cache read for the 5-minute duration… or after two cache reads for the 1-hour duration". The multipliers stack with the Batch and data-residency modifiers. Automatic caching (one top-level `cache_control`) is "the recommended starting point." — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- Claude Code TTLs: the main conversation gets 1 hour on a subscription within plan usage. It gets 5 minutes on an API key, a cloud provider, or usage credits. Subagents, compaction, and similar requests get 5 minutes by default. These can be overridden with `promptCacheTtl` / `CLAUDE_CODE_PROMPT_CACHE_TTL` and `subagentPromptCacheTtl`. For API-key users: "set `promptCacheTtl` to `1h`." — [Prompt caching in Claude Code](https://code.claude.com/docs/en/prompt-caching)
- These actions invalidate the cache: switching models, changing effort (except on the 5.5 models and Fable 5.1 via API or subscription), toggling fast mode, adding or removing MCP servers when tools aren't deferred, toggling plugins that provide MCP servers, denying an entire tool, compaction, piling up many images, and upgrading Claude Code. — [same](https://code.claude.com/docs/en/prompt-caching)
- These actions keep the cache: editing files, editing CLAUDE.md (the change takes effect only after `/clear`, `/compact`, or a restart), changing permission mode, changing output style, invoking skills, `/recap`, `/rewind`, and spawning subagents. — [same](https://code.claude.com/docs/en/prompt-caching)
- Tip: "Pick your model and effort level at the top of a session, then save `/compact` for natural breaks between tasks." To abandon a path, `/rewind` instead of compacting, because rewinding goes back to an already-cached prefix. — [same](https://code.claude.com/docs/en/prompt-caching)
- `/usage` shows a "Prompt cache (main)" line (v2.1.251+). Its example reads "91% of input tokens from cache". It also names the likely cause of the last miss. — [Manage costs](https://code.claude.com/docs/en/costs)

**Batch and fast mode**
- The Batch API is "a 50 percent discount on both input and output tokens". Fast mode is not available with Batch. On the Batches API, the 5.x and 4.6+ models support up to 300k output tokens with a beta header. — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing); [Models overview](https://platform.claude.com/docs/en/about-claude/models/overview)
- Fast mode (premium speed) costs $8/$40 on Opus 5.5 and $10/$50 on Opus 5 and Opus 4.8. — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing)

**Claude Code cost management (costs page, live Oct 2026)**
- "Across enterprise deployments, the average cost is around $13 per developer per active day and $150-250 per developer per month, with costs remaining below $30 per active day for 90% of users." — [Manage costs](https://code.claude.com/docs/en/costs)
  - These figures come from the live page. I did not check how they changed from earlier versions.
- `/cost` has effectively become **`/usage`**. It shows a session cost estimate, cache stats, and on plans an attribution breakdown by skill, subagent, plugin, and MCP, with recommendations and an `f` fix shortcut. `/insights` gives a usage-pattern report. `--max-budget-usd` and `--max-turns` cap headless runs. The `modelPricing` managed setting shows costs at contracted rates. — [Manage costs](https://code.claude.com/docs/en/costs)
- Token-reduction tips (official list):
  - `/clear` between tasks ("costs nothing").
  - `/compact <focus>` and "Compact instructions" in CLAUDE.md.
  - Choose the right model.
  - Use CLI tools over MCP and disable unused MCP servers.
  - Install code-intelligence plugins.
  - Use hooks to preprocess output, for example a PreToolUse hook that filters test output to failures, cutting "tens of thousands of tokens to hundreds".
  - Move workflow instructions from CLAUDE.md into on-demand skills and "keep CLAUDE.md under 200 lines".
  - Lower effort.
  - Delegate verbose operations to subagents on cheaper models.
  - Write specific prompts.
  - Use plan mode (Shift+Tab) for complex tasks.
  - Course-correct early with Esc or `/rewind`.
  - Give verification targets and test incrementally.

  — [Manage costs](https://code.claude.com/docs/en/costs)
- Hidden or background usage: session recap, idle compaction, prompt suggestions, `/loop` tasks, goal check-ins, cross-session messages, and teammates all keep sending requests. "`/compact` reads the conversation it summarizes," which is costly once the cache is cold. — [Manage costs](https://code.claude.com/docs/en/costs)
- Team rate-limit recommendations, as TPM / RPM per user:

  | Team size | TPM per user | RPM per user |
  | :- | :- | :- |
  | 1-5 | 200-300k | 5-7 |
  | 5-20 | 100-150k | 2.5-3.5 |
  | 20-50 | 50-75k | 1.25-1.75 |
  | 50-100 | 25-35k | 0.62-0.87 |
  | 100-500 | 15-20k | 0.37-0.47 |
  | 500+ | 10-15k | 0.25-0.35 |

  — [Manage costs](https://code.claude.com/docs/en/costs)

### Inferences
- With cache reads at 0.05× on Opus and Sonnet 5.5, long sessions are cheap per turn while the cache stays warm. The main cost risks are cache misses (model or effort switches, idle gaps past the TTL, MCP or tool churn) and output/thinking tokens, not raw context size.
- For API-key users, a 1h TTL (`promptCacheTtl: 1h`) probably pays off in interactive coding with pauses. A 5m TTL suits fast bursts and CI.
- `opusplan` can cost more than expected if plan mode is toggled often, because each toggle rebuilds the cache.

### Gaps
- No official published cache hit-rate target. The blog says only that a few points of miss rate matter a lot.
- I did not fetch the official per-model effort or "choosing a model" page (platform.claude.com/docs/en/about-claude/models/choosing-a-model), so there are no benchmark-based routing thresholds.
- Haiku 5.5 thinking defaults in Claude Code and how the Explore agent picks its model in 2026 were not confirmed. The blog says Explore uses Haiku.

## Q3: Current Claude model lineup and pricing per MTok (verified on the official pricing page, 2026-10-31)

### Takeaway
The current lineup is Fable 5.1 ($10/$50), Opus 5.5 ($4/$20), Sonnet 5.5 ($2/$10), and Haiku 5.5 ($0.10/$0.50 up to 100k-token prompts, $0.50/$2.50 above). All have 1M context and 128K max output. The 5.5 generation is cheaper than its predecessors and cheaper still on cache reads. Note that the new tokenizer (Opus 4.7 and later) produces about 30% more tokens for the same text.

### Cited Findings
- Pricing per MTok, as input / 5m cache write / 1h cache write / cache read / output — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing):

  | Model | Input | 5m write | 1h write | Cache read | Output |
  | :- | :- | :- | :- | :- | :- |
  | Fable 5.1 | $10 | $12.50 | $20 | $0.25 | $50 |
  | Mythos 5.1 (limited access) | $10 | $12.50 | $20 | $0.25 | $50 |
  | Fable 5 / Mythos 5 | $10 | $12.50 | $20 | $1 | $50 |
  | **Opus 5.5** | $4 | $5 | $8 | $0.20 | $20 |
  | Opus 5, 4.8, 4.7, 4.6, 4.5 | $5 | $6.25 | $10 | $0.50 | $25 |
  | Opus 4.1 / 4 (retired except on some clouds) | $15 | — | — | — | $75 |
  | **Sonnet 5.5** | $2 | $2.50 | $4 | $0.10 | $10 |
  | Sonnet 5 (see note) | $2 | — | — | $0.20 | $10 |
  | Sonnet 4.6 / 4.5 | $3 | — | — | $0.30 | $15 |
  | **Haiku 5.5**, prompts ≤100k tokens | $0.10 | $0.125 | $0.20 | $0.01 | $0.50 |
  | **Haiku 5.5**, prompts >100k tokens | $0.50 | — | — | $0.05 | $2.50 |
  | Haiku 4.5 | $1 | — | — | $0.10 | $5 |

  Sonnet 5 note: its introductory $2/$10 price "is now the standard price". The planned increase to $3/$15 on Sep 1, 2026 "will not occur."
- Batch prices are half of list: Fable 5.1 $5/$25, Opus 5.5 $2/$10, Sonnet 5.5 $1/$5, Haiku 5.5 $0.05/$0.25 (≤100k). — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- Long context: "Claude 4.6 and later models (except Claude Haiku 5.5)… include the full 1M token context window at standard pricing". Haiku 5.5 has its own tier above 100k tokens. US-only inference (`inference_geo: "us"`) adds a 1.1× multiplier. — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- Tokenizer: "Claude 4.7 and later models… use a newer tokenizer… approximately 30% more tokens for the same text." — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- Tool extras: web search costs $10 per 1,000 searches. Code execution is free when used with web_search or web_fetch (20260209+); otherwise it bills $0.05 per container-hour beyond 1,550 free hours. — [Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- Model specs: IDs `claude-fable-5-1`, `claude-opus-5-5`, `claude-sonnet-5-5`, `claude-haiku-5-5`. All have 1M context, 128K max output, and a reliable knowledge cutoff of Jun 2026. Retirement is not sooner than Sep 1 2027 (Fable 5.1), Sep 22 2027 (Opus 5.5), Sep 28 2027 (Sonnet 5.5), and Oct 7 2027 (Haiku 5.5). Legacy models still available: Fable 5, Opus 5, Opus 4.8/4.7/4.6/4.5, Sonnet 5, Sonnet 4.6, Haiku 4.5. — [Models overview](https://platform.claude.com/docs/en/about-claude/models/overview)
- Launch dates come from third-party press only and were not confirmed on anthropic.com in this session: Opus 5.5 on Sep 22, 2026, Sonnet 5.5 on Sep 28, 2026, Haiku 5.5 on Oct 7, 2026. Press also reported Sonnet 5.5 as more than 30% faster than Sonnet 5 and Haiku 5.5 as cutting cost about 75% versus the prior generation. The dates match the official retirement-commitment dates. — [technews.tw (Opus 5.5)](https://technews.tw/2026/09/23/anthropic-upgrades-claude-with-new-opus-5-5-model/); [technews.tw (Sonnet 5.5)](https://technews.tw/2026/09/29/anthropic-upgrades-claude-with-new-sonnet-5-5-model/); [iphonesoft.fr](https://iphonesoft.fr/2026/09/29/anthropic-claude-sonnet-5-5-ia-plus-rapide-moins-chere); [digitaltoday (Haiku 5.5)](https://www.digitaltoday.co.kr/cn/view/112034/anthropic-launches-fast-low-cost-ai-claude-haiku-55-cuts-costs-75-percent)

### Inferences
- Approximate price ratios per output token: Fable is 2.5× Opus 5.5, Opus 5.5 is 2× Sonnet 5.5, and Sonnet 5.5 is 20× Haiku 5.5 (≤100k). Haiku 5.5 is very cheap for subagent and Explore-style work under 100k tokens.
- Anything written before Sep 2026 that quotes Opus at $5/$25 or $15/$75, or Sonnet at $3/$15, is out of date for the current models.
- Because of the tokenizer change, per-MTok comparisons with Sonnet 4.6 or earlier understate the real cost difference by about 30%.

### Gaps
- No official Anthropic announcement pages for the 5.5 models were fetched. Launch dates and performance claims rest on press coverage.
- Subscription plan prices (Pro, Max, Ultra, Team, Enterprise; claude.com/pricing) were not fetched.
- The Mythos models are limited-access (Cyber Verification Program), so their usefulness for general app development is unclear.
