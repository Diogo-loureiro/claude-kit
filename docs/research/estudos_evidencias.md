# Empirical evidence on cost vs. quality in agentic coding and LLM agents (2023-2026)

Research date: 2026-10-31. Items marked "(verified)" were checked against the primary source during this session. Items marked "(from abstract, recalled)" are well-known paper abstracts cited from memory to their arXiv IDs and were not re-fetched; confirm them before quoting exact figures.

## 1. Multi-agent vs single-agent: cost and accuracy

### Takeaway
Multi-agent setups buy accuracy mainly on breadth-first, parallelizable work such as research and search, and they cost roughly 15x the tokens of chat. On sequential, tightly coupled work like most coding, controlled studies find multi-agent setups often add errors and cost. A single strong agent with shared context is the safer default.

### Cited Findings
- **Anthropic multi-agent research system (June 2025, verified):**
  - Agents use about 4x the tokens of a chat interaction. Multi-agent systems use about 15x.
  - Lead Opus 4 with Sonnet 4 subagents beat single-agent Opus 4 by 90.2% on an internal research eval.
  - On BrowseComp, three factors explained 95% of performance variance, and token usage alone explained 80%. The other two were the number of tool calls and model choice.
  - Anthropic says domains where agents must share context or have many dependencies are a poor fit, and "most coding tasks involve fewer truly parallelizable tasks than research."
  - Multi-agent only pays when task value is high.
  - [Anthropic Engineering](https://www.anthropic.com/engineering/multi-agent-research-system)
  - Caveat: the 80% figure is a correlation within one benchmark, not proof that more tokens cause better results.
- **Google Research / DeepMind / MIT, "Towards a Science of Scaling Agent Systems" (arXiv 2512.08296, Dec 2025):**
  - Controlled evaluation of 180 agent configurations: one single-agent baseline against independent, centralized, decentralized and hybrid multi-agent setups.
  - Multi-agent coordination helps a lot on parallelizable tasks and degrades performance on sequential ones.
  - Independent multi-agent systems amplify errors by up to 17.2x. Centralized coordination contained errors best.
  - Coordination returns become diminishing or negative once the single-agent baseline is strong enough (a statistically significant negative coefficient in v2).
  - [Google Research blog](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/); [arXiv](https://arxiv.org/abs/2512.08296)
  - Caveat: I did not review the full per-benchmark tables.
- **MAST, "Why Do Multi-Agent LLM Systems Fail?" (Cemri et al., UC Berkeley; NeurIPS 2025, arXiv 2503.13657):**
  - Taxonomy of 14 failure modes in 3 categories: specification/system design, inter-agent misalignment, and task verification.
  - The latest version annotates 1,642 traces from 7 popular MAS frameworks. v1 had about 150 traces and 5 systems.
  - Inter-annotator Cohen's kappa is 0.88, and the authors built an LLM-as-judge pipeline for labeling at scale.
  - Secondary sources report failure rates of 41-86.7% across 7 open-source MAS. I could not confirm this exact range in the primary text.
  - [arXiv v3](https://arxiv.org/html/2503.13657v3)
- **Cognition, "Don't Build Multi-Agents" (June 2025, opinion/engineering essay):**
  - Argues for single-threaded linear agents, built on two principles: "share context, share full agent traces" and "actions carry implicit decisions."
  - Parallel subagents with partial context make conflicting decisions.
  - This is practitioner argument, not a controlled study. [Cognition blog](https://cognition.ai/blog/dont-build-multi-agents) (not re-fetched this session)

### Inferences
- For a coding framework, default to one agent with full context. Use subagents only for read-only, parallelizable fan-out (search, research, independent file analysis) where each returns a compressed summary. Expect a several-fold token multiplier per subagent.
- Anthropic's 90% gain and Google's degradation results are consistent with each other: the decisive variable is how parallelizable the task is.

### Gaps
- I found no controlled study isolating multi-agent vs single-agent cost per resolved issue on SWE-bench with the same model.
- The MAST per-category percentages need checking against Table/Figure 3 of the paper.

## 2. Long-context degradation and why to keep context small

### Takeaway
Every evaluated frontier model degrades as input length grows, even on trivial tasks. Effective context is much shorter than the advertised window. Smaller, focused context is both cheaper and more accurate.

### Cited Findings
- **Chroma, "Context Rot" (Hong, Troynikov, Huber; July 14, 2025):**
  - Evaluated 18 LLMs, including GPT-4.1, Claude 4, Gemini 2.5 and Qwen3.
  - Performance grows increasingly unreliable as input length grows, even when task difficulty is held constant.
  - Distractors hurt: one distractor degrades results, and four compound the damage.
  - In a LongMemEval comparison, a focused ~300-token prompt beat the full ~113k-token history that contained the same answer.
  - [Chroma Research](https://trychroma.com/research/context-rot)
  - Note: the distractor and LongMemEval details come via secondary summaries ([ZenML](https://www.zenml.io/llmops-database/context-rot-evaluating-llm-performance-degradation-with-increasing-input-tokens)).
- **NoLiMa (Modarressi et al., Adobe; ICML 2025, arXiv 2502.05167):**
  - Tests needle retrieval that requires inference rather than literal matching, on 13 models that all claim at least 128K context.
  - At 32K tokens, 11 of 13 models fall to half or less of their short-context score. Earlier versions said 10 of 12.
  - GPT-4o drops from 99.3% to 69.7% at 32K.
  - [PMLR](https://proceedings.mlr.press/v267/modarressi25a.html); [arXiv v3](https://arxiv.org/html/2502.05167v3)
- **RULER (Hsieh et al., NVIDIA; arXiv 2404.06654, 2024; from abstract, recalled):** all evaluated models claim 32K+ context, but only about half maintain satisfactory performance at 32K. [arXiv](https://arxiv.org/abs/2404.06654)
- **"Lost in the Middle" (Liu et al.; TACL 2024, arXiv 2307.03172; from abstract, recalled):**
  - Performance follows a U-shape: highest when the relevant information is at the beginning or end of the context, and significantly lower in the middle.
  - [arXiv](https://arxiv.org/abs/2307.03172)
- **SWE-Pruner (arXiv 2601.16746, Jan 2026):**
  - For Mini-SWE-Agent with Claude Sonnet 4.5 on SWE-bench Verified, read operations account for 76.1% of token consumption.
  - This motivates pruning file-read observations. [arXiv](https://arxiv.org/pdf/2601.16746)

- **LOCA-bench (Zeng, Huang, He, HKUST; arXiv 2602.07962, Feb 2026; ICML 2026), the newest agent-specific context-rot evidence:**
  - Grows the environment context while keeping the task fixed.
  - Agent performance generally degrades as context grows. Agents explore less, act more conservatively and hallucinate more.
  - Advanced context-management techniques substantially raise success rates.
  - [arXiv](https://arxiv.org/abs/2602.07962); [PMLR](https://proceedings.mlr.press/v306/zeng26g.html)
  - I did not retrieve exact percentages.
- **Recency flag:** "Lost in the Middle" (2023) and RULER (2024) used older models, and their exact numbers are likely superseded for 2026 frontier models. The qualitative conclusion still holds in Chroma 2025 and LOCA-bench 2026: effective context is less than nominal context, and degradation grows with length. I found no newer Chroma report as of Oct 2026.

### Inferences
- Large file dumps and stale tool outputs are the main source of both cost and accuracy loss. Use targeted reads (grep, line ranges), prune old observations, and put critical instructions at the start or end of the context.

### Gaps
- Fiction.LiveBench numbers were not retrieved this session.
- Coding-specific long-context degradation curves (as opposed to retrieval or QA) are sparse.

## 3. Token consumption of coding agents and cost-aware evaluation

### Takeaway
Agentic coding costs are dominated by input tokens from re-sent context. They vary up to 30x for the same task, and higher spend does not reliably buy accuracy. Simple pipelines (Agentless) and cost-controlled baselines show that much agent spend is wasted.

### Cited Findings
- **"How Do AI Agents Spend Your Money?" (arXiv 2604.22750, Apr 2026; Microsoft Research / Stanford Digital Economy Lab; NeurIPS 2026 listing):**
  - Analyzed trajectories from 8 frontier LLMs running OpenHands on SWE-bench Verified.
  - Agentic tasks consume about 1000x more tokens than code reasoning or code chat, and input tokens are the main cost driver.
  - Runs of the same task can differ by up to 30x in total tokens, and higher token usage does not necessarily improve accuracy.
  - Human difficulty labels correlate weakly with token spend (Kendall tau-b about 0.32, per a review summary).
  - Models predict their own costs poorly (correlation at most 0.39) and systematically underestimate them.
  - [arXiv](https://arxiv.org/abs/2604.22750); [Stanford DEL](https://digitaleconomy.stanford.edu/publication/how-do-ai-agents-spend-your-money/)
- **Agentless (Xia et al., UIUC; arXiv 2407.01489, 2024; from abstract, recalled):**
  - A fixed three-phase localize, repair, validate pipeline with no autonomous agent loop.
  - Reached 27.33% on SWE-bench Lite at about $0.34 per issue, the highest open-source result at lowest cost at the time.
  - [arXiv](https://arxiv.org/abs/2407.01489)
- **"AI Agents That Matter" (Kapoor, Narayanan et al., Princeton; arXiv 2407.01502, 2024; from abstract, recalled):**
  - Agent benchmarks that ignore cost reward needlessly expensive agents.
  - Simple baselines (retry, escalation) match complex state-of-the-art agents on HumanEval at much lower cost.
  - The authors call for cost-accuracy Pareto reporting.
  - [arXiv](https://arxiv.org/abs/2407.01502)
- **Cuadron et al., "The Danger of Overthinking" (arXiv 2502.08235, Feb 2025):**
  - On SWE-bench Verified, o1 at high reasoning effort resolved 29.1% at about $1,400. Low effort resolved 21.0% at about $400, 3.5x cheaper.
  - [arXiv](https://arxiv.org/abs/2502.08235)

- **HAL, Holistic Agent Leaderboard (Kapoor, Narayanan et al., Princeton; arXiv 2510.11977; ICLR 2026), the most recent cost-aware evaluation at scale:**
  - 21,730 rollouts across 9 models and 9 benchmarks (coding, web, science, customer service), costing about $40,000 in total.
  - The most expensive models are rarely on the cost-accuracy Pareto frontier, and accuracy gains often come without better token efficiency.
  - Scaffold choice strongly moves both accuracy and cost. Task-specific scaffolds usually win but cost more.
  - Higher reasoning effort reduced accuracy in the majority of runs. One secondary source reports o4-mini high below low in 21 of 36 runs.
  - Secondary example on Online Mind2Web: Browser-Use with Sonnet 4 reached 40% for $1,577, while SeeAct with GPT-5 Medium reached 42% for $171 (about 9x cost for a 2-point difference).
  - The leaderboard reportedly reached 26,597 rollouts by April 2026 (unverified).
  - [ICLR 2026](https://proceedings.iclr.cc/paper_files/paper/2026/hash/a0928f924a344aaebbb7f6cd8d56e34c-Abstract-Conference.html); [arXiv](https://arxiv.org/abs/2510.11977); [review summary](https://www.themoonlight.io/review/holistic-agent-leaderboard-the-missing-infrastructure-for-ai-agent-evaluation)
- **Terminal-Bench 2.0 / 2.1 (ICLR 2026, arXiv 2601.11868):**
  - Third-party leaderboards (Vals) now publish cost per test alongside score.
  - Indicative figures: top score about 82.7% (GPT-5.5, listed Sept 9, 2026); a GPT-5.5 (high) row at 73.2% shows roughly $1.82 per test (hard to parse, verify).
  - Rows mix snapshots from different dates.
  - Terminal-Bench 2.1 fixes 28 of 89 tasks, so 2.0 and 2.1 numbers are not directly comparable.
  - [Vals mirror on benchmarklist](https://benchmarklist.com/benchmarks/vals_terminal_bench_2/); [pricing board](https://anotherwrapper.com/tools/llm-pricing/evals/terminal-bench-2-0); [paper](https://arxiv.org/abs/2601.11868)
- **Recency flag:**
  - Agentless ($0.34 per issue, 27% Lite, 2024) and Kapoor 2024 are historically important but superseded in absolute numbers, because 2026 SWE-bench Verified scores are far higher.
  - Their lesson, that simple or cheap scaffolds sit near the Pareto frontier, is reconfirmed by HAL (2026).
  - The 2026 "How Do AI Agents Spend Your Money?" paper and HAL are the most current cost evidence.

### Inferences
- Because input tokens dominate cost, the biggest levers are context hygiene and caching, not shorter outputs.
- The 30x variance means hard per-task budgets and step caps matter.
- Cost-per-resolved-task, not cost per token, is the right metric.

### Gaps
- I did not retrieve current SWE-bench, Aider or HAL leaderboard cost columns this session. The Aider polyglot leaderboard publishes cost per run, and HAL (Princeton) publishes cost-aware Pareto frontiers, but specific numbers are unverified here.
- I did not verify SWE-agent's original per-issue cost figures. Its SWE-bench full resolve rate was 12.47% (2024).

## 4. Prompt caching and context compression

### Takeaway
Prompt caching cuts agent API cost by roughly 41-80% when the prompt prefix is kept stable. Simple observation masking, which hides old tool outputs, halves cost and matches or beats LLM summarization.

### Cited Findings
- **"Don't Break the Cache" (Lumer et al., PwC; arXiv 2601.06007, Jan 2026):**
  - Evaluated OpenAI, Anthropic and Google, with 4 flagship models, on DeepResearch Bench, a long-horizon web-search agent task.
  - Caching cut API cost by 41-80% and improved time-to-first-token by 13-31%.
  - Full-context caching can increase latency, because dynamic tool results get written to cache and are never reused.
  - System-prompt-only caching gave the most consistent gains.
  - Recommendations:
    - Put dynamic content at the end of the system prompt.
    - Avoid dynamic function-call definitions.
    - Exclude dynamic tool results from the cache.
  - Not a coding benchmark; peer-review status unknown.
  - [arXiv](https://arxiv.org/abs/2601.06007)
- **Anthropic prompt caching launch (Aug 2024; vendor claim, recalled):** up to 90% cost reduction and 85% latency reduction for long prompts. [Anthropic](https://www.anthropic.com/news/prompt-caching)
- **"The Complexity Trap" (Lindenbauer et al., JetBrains Research and TUM; NeurIPS 2025 workshop, arXiv 2508.21433):**
  - Compared context strategies in SWE-agent on SWE-bench Verified.
  - Observation masking roughly halves cost versus the raw agent and matches or slightly exceeds LLM summarization's solve rate.
  - Best model: 52% cheaper with a +2.6 percentage-point solve rate.
  - Qwen3-Coder 480B: 53.8% to 54.8%.
  - LLM summarization does not consistently or significantly beat masking (v3).
  - A hybrid of the two saves a further 7% over masking and 11% over summarization.
  - Initial evidence that the results generalize to OpenHands.
  - [arXiv](https://arxiv.org/abs/2508.21433)
- **SWE-Pruner (arXiv 2601.16746):** because file reads are 76% of tokens, task-aware pruning of read observations is the main compression target. [arXiv](https://arxiv.org/pdf/2601.16746)

### Inferences
- Keep the system prompt, tool definitions and CLAUDE.md-style instructions static and at the front. Do not edit history mid-session, since that breaks the cache.
- Mask or trim old tool outputs instead of paying for LLM summarization.
- Masking and caching interact: masking rewrites history and can invalidate cache prefixes. Apply masking in batches or at compaction points.

### Gaps
- No study found that measures cache hit rates specifically in coding agents such as Claude Code or Cursor.
- No study found on the masking-versus-cache-invalidation trade-off.

## 5. Developer productivity studies

### Takeaway
Controlled evidence is mixed. Enterprise RCTs on simpler tasks show 21-26% gains. METR's RCT on expert open-source developers in mature repos showed a 19% slowdown in early 2025, and its late-2025 follow-up hints at speedups but is unreliable. Org-level telemetry shows more output but bottlenecks in review and quality.

### Cited Findings
- **METR RCT (Feb-Jun 2025, published July 2025):**
  - 16 experienced open-source developers, 246 tasks, in their own large repositories.
  - With AI, tasks took 19% longer (95% CI +2% to +39%).
  - Developers predicted a 24% speedup beforehand and still believed they had been about 20% faster afterwards.
  - The 16/246/24% figures are recalled from the original paper. METR's Feb 2026 post confirms the 19% figure and CI and now flags the 2025 results as out of date.
  - [METR 2026 update](https://metr.org/blog/2026-02-24-uplift-update/)
- **METR follow-up (study began Aug 2025, reported Feb 24, 2026, verified):**
  - 57 developers, 143 repositories, 800+ tasks; median 10 years of experience; pay $50/h versus $150/h originally.
  - Returning original developers (n=10): estimated 18% speedup, CI -38% to +9%.
  - Newly recruited developers: estimated 4% speedup, CI -15% to +9%.
  - METR calls the data unreliable and "very weak evidence" of improvement, citing:
    - Selection bias, since developers refused to work without AI.
    - 30-50% of developers skipping tasks they did not want to do without AI.
    - Concurrent agents distorting time tracking.
    - Shifts in task types.
    - Quality differences between conditions.
  - [METR](https://metr.org/blog/2026-02-24-uplift-update/)
- **METR perceived-value survey (Feb-Apr 2026, secondary report):**
  - 349 technical workers; respondents perceived AI as raising the value of their output by about 1.6-2.1x.
  - This is self-reported, and the 2025 RCT showed self-reports overestimated speed by about 40 points (perceived +20% versus measured -19%).
  - [i-programmer](https://www.i-programmer.info/news/99-professional/18910-perceived-value-of-ai-tools.html)
- **Recency flag:**
  - The METR July 2025 19% slowdown (early-2025 tools such as Cursor with Claude 3.5/3.7) is explicitly marked "out of date" by METR itself.
  - No clean 2026 measurement replaces it: the follow-up points toward speedup but is unreliable.
  - The Google, Microsoft and Accenture RCTs (2023-2024) measured autocomplete or chat-era tools, not autonomous agents.
- **Google internal RCT (Paradis et al., arXiv 2410.12944, 2024; recalled):** about 96 Google engineers on an enterprise task; about 21% faster with AI, with a wide CI. [arXiv](https://arxiv.org/abs/2410.12944)
- **Microsoft / Accenture / Fortune-100 field experiments (Cui, Demirer et al., 2024; recalled):** 4,867 developers across 3 RCTs; 26.08% more completed tasks (PRs) with Copilot, and larger gains for junior and less-tenured developers. [SSRN](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4945566)
- **DORA 2025 State of AI-assisted Software Development (Sept 2025):**
  - Nearly 5,000 respondents; about 90% use AI at work.
  - AI adoption is now associated with higher delivery throughput, reversing the 2024 finding, and also with continued instability and quality concerns.
  - AI acts as an "amplifier": teams with loosely coupled architectures and fast feedback loops gain, while tightly coupled or slow-process teams see little or none.
  - Of 7 team archetypes, reportedly only 2 clearly benefit.
  - [DORA](https://dora.dev/research/ai/); [Google blog](https://blog.google/technology/developers/dora-report-2025/); [Rob Bowley analysis](https://blog.robbowley.net/2025/10/01/dora-2025-ai-assisted-dev-report-some-benefit-most-dont/)
- **Faros AI "AI Productivity Paradox" (June/July 2025):**
  - Telemetry from 10,000+ developers on 1,255 teams.
  - High-AI-adoption teams completed 21% more tasks and merged 98% more PRs, but PR review time rose 91%.
  - PR size grew about 154% and bugs per developer about 9% (secondary sources).
  - No significant link from individual gains to company-level delivery.
  - Caveat: Faros is a vendor.
  - [Faros](https://www.faros.ai/blog/ai-software-engineering); [AgileEngine summary](https://agileengine.com/evidence-based-guide-to-ai-assisted-software-development-in-production/)
- **GitClear 2025 code-quality report (recalled, not re-fetched):**
  - 211M changed lines, 2020-2024.
  - Duplicated code blocks rose sharply (about 8x in 2024), and in 2024 copy/pasted lines exceeded moved/refactored lines for the first time, which suggests declining refactoring.
  - [GitClear](https://www.gitclear.com/ai_assistant_code_quality_2025_research)

### Inferences
- The gains depend on context: on familiar, complex codebases AI can slow experts down, and the developers misjudge it.
- Review capacity and verification become the bottleneck, so a framework should optimize for small, reviewable diffs and automated checks rather than raw generation volume.

### Gaps
- No credible 2026 RCT was found that settles agentic-era speedups.
- One blog cited a 55.8% speedup trial that I could not verify.
- The Faros 2026 report (about 22k developers) was not verified.
- I did not search for a DORA 2026 report. Expected around Sept/Oct 2026, it would supersede DORA 2025 if published, so check dora.dev.

## 6. Model routing, cascades and reasoning effort

### Takeaway
Routing easy queries to cheap models saves 50-98% of cost at near-equal quality on chat and QA benchmarks. In agentic coding, more reasoning effort raises accuracy with steep diminishing returns, and overthinking can hurt.

### Cited Findings
- **FrugalGPT (Chen, Zaharia, Zou; arXiv 2305.05176, 2023; from abstract, recalled):** an LLM cascade can match GPT-4 performance with up to 98% cost reduction, or improve accuracy over GPT-4 by 4% at the same cost. [arXiv](https://arxiv.org/abs/2305.05176)
- **RouteLLM (Ong et al., LMSYS/Berkeley; arXiv 2406.18665, 2024; recalled):**
  - Learned routers between a strong and a weak model cut costs by more than 85% on MT-Bench, 45% on MMLU and 35% on GSM8K versus GPT-4 only, while keeping 95% of GPT-4 quality.
  - [arXiv](https://arxiv.org/abs/2406.18665)
- **Overthinking in agentic coding (Cuadron et al., arXiv 2502.08235):**
  - Evaluated on SWE-bench Verified with CodeAct/OpenHands.
  - Three failure patterns: analysis paralysis, rogue actions, and premature disengagement.
  - Higher overthinking scores correlate with lower resolve rates, and reasoning models overthink more.
  - o1 high effort: 29.1% at about $1,400; low effort: 21.0% at about $400.
  - Picking the less-overthinking of 2 low-effort samples gave 27.3% at about 57% of the high-effort cost (per secondary review).
  - Native function calling helps reduce overthinking.
  - [arXiv](https://arxiv.org/abs/2502.08235)

- **HAL (ICLR 2026), newer and broader than Cuadron:**
  - Higher reasoning effort reduced accuracy in the majority of runs across 9 benchmarks.
  - The most costly models are rarely Pareto-optimal.
  - [ICLR 2026](https://proceedings.iclr.cc/paper_files/paper/2026/hash/a0928f924a344aaebbb7f6cd8d56e34c-Abstract-Conference.html)
- **Recency flag:** FrugalGPT (2023) and RouteLLM (2024) used GPT-4-era models on chat and QA benchmarks. Today's cheaper models narrow the gap, so the absolute savings figures are dated.

### Inferences
- Use cheap or fast models for exploration, search and summarization subagents, and the strong model for planning and final edits.
- Treat reasoning effort as a tunable knob. Start medium and escalate only on failure, since a cascade often beats always-high effort per resolved task.

### Gaps
- Routing studies are mostly on chat and QA, not multi-step coding agents.
- No source was found for thinking-budget scaling curves on SWE-bench for Claude or Gemini thinking budgets.

## 7. Tests and verification loops

### Takeaway
Giving agents executable tests and a run-fix loop is among the largest single accuracy levers, though the dramatic gains assume good human-written tests. Writing good tests remains hard for models.

### Cited Findings
- **TDFlow (Han et al., CMU; EACL 2026, arXiv 2510.23761):**
  - A test-driven agentic workflow with sub-agents that repair code against tests.
  - With human-written tests: 88.8% on SWE-bench Lite (+27.8 points over the next best baseline) and 94.3% on SWE-bench Verified.
  - With self-generated tests: 69.8% on Verified.
  - Only 7 test-hacking instances in 800 runs.
  - Not comparable to the standard SWE-bench setup, since tests are provided.
  - [arXiv](https://arxiv.org/abs/2510.23761)
- **Cognition SWE-bench technical report (2024):**
  - Given the final unit tests, Devin's pass rate rose to 23% on a sample of 100. The comparison was against a 13.86% standard result, recalled.
  - Cognition flags this as not comparable to standard results.
  - [Cognition](https://cognition.ai/post/swe-bench-technical-report)
- **TDD-Bench Verified (IBM, arXiv 2412.02883):** the best model (GPT-4o) writes valid fail-to-pass tests for an issue only 23.6% of the time, so test generation is the weak link. [arXiv](https://arxiv.org/abs/2412.02883)
- **Agentless:** its validation phase uses generated reproduction tests plus regression tests to select among candidate patches. That is a cheap form of verification. [arXiv](https://arxiv.org/abs/2407.01489)

### Inferences
- In a framework, have humans write or approve a failing test first, then let the agent iterate against it. This turns open-ended agent work into a bounded loop, which reduces both wasted tokens and incorrect completions.
- Guard against test-hacking: forbid editing tests, and review test diffs.

### Gaps
- I found no controlled study quantifying the token cost of verification loops against their success gain in production agents.
