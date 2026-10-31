# Harness engineering, loop engineering, spec-driven development, and the "Karpathy CLAUDE.md" (as of 2026-10-31)

Note on source quality: openai.com and adtmag.com returned 403 to my fetches, so the OpenAI figures come from InfoQ and secondary write-ups that quote the post. The Anthropic, martinfowler.com, addyosmani.com and GitHub pages were fetched directly. Many search results were SEO or aggregator blogs; I flag those wherever I use them.

## 1. Harness engineering: meaning, origin, practices, results, cost

### Takeaway
"Harness engineering" means designing everything around the model: repo docs, linters, tests, architectural rules, init scripts, progress files, sandboxes and observability. The goal is reliable agent output. Mitchell Hashimoto's "engineer the harness" step, from his "My AI Adoption Journey" post (early 2026), was an early use of the term. OpenAI made it mainstream with its February 2026 Codex post, and Böckeler (Thoughtworks/martinfowler.com) gave it a framework in April 2026. The best-known result is OpenAI's: about 1M lines of code and about 1,500 PRs with no hand-written code. That is a vendor claim from an internal experiment, with no cost data.

### Cited Findings
**Origin and definitions**
- Mitchell Hashimoto (HashiCorp co-founder) listed "engineer the harness" as one step of his AI adoption journey. He used it to mean that each time an agent makes a mistake, you add a fix (an AGENTS.md update or a helper script such as a screenshot tool or a filtered test run) so the mistake can't recur. Another step was "always have an agent running." These details come from secondary summaries; I did not fetch the original post. — [besthub summary](https://www.besthub.dev/articles/my-ai-adoption-journey-lessons-from-the-terraform-and-ghostty-creator-81d3557d2212); [lavx summary](https://news.lavx.hu/article/mitchell-hashimoto-s-ai-adoption-journey-from-skeptic-to-believer)
- HN and forum users argue that Hashimoto used the term before OpenAI did. These are user comments and I could not verify them. — [hn.svelte.dev thread](https://hn.svelte.dev/item/49464970)
- OpenAI published "Harness engineering: leveraging Codex in an agent-first world" in February 2026. Ryan Lopopolo, a member of OpenAI's technical staff, is quoted as the source. Secondary sources date the post to Feb 11, 2026; InfoQ covered it on Feb 21, 2026. — [InfoQ, 2026-02-21](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex); [OpenAI post (403 to fetch)](https://openai.com/index/harness-engineering/)
- Anthropic's "Effective harnesses for long-running agents" (Justin Young, 2025-11-26) predates the OpenAI post and uses "harness" for the scaffolding around Claude Agent SDK sessions. — [Anthropic Engineering, 2025-11-26](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- Böckeler published "Harness Engineering – first thoughts" (memo, Feb 2026) and then "Harness engineering for coding agent users" (2026-04-02). Her framing is "Agent = Model + Harness". The *built-in harness* comes from the vendor (Claude Code, Codex). The *outer harness* is what the user builds for their own codebase. — [martinfowler.com, 2026-04-02](https://martinfowler.com/articles/harness-engineering.html); [memo](https://www.martinfowler.com/articles/exploring-gen-ai/harness-engineering-memo.html)
- One secondary source distinguishes the two terms this way: context engineering asks what the agent should see, while harness engineering asks what the system should prevent, measure, and correct. — [zby commonplace notes](https://zby.github.io/commonplace/sources/harness-engineering-leveraging-codex-agent-first-world)

**Core practices**
- OpenAI's practices:
  - A structured `docs/` directory serves as the source of truth (maps, execution plans, design specs), and linters and CI check that it is cross-linked and fresh.
  - A strict layered dependency order (Types → Config → Repo → Service → Runtime → UI) is enforced mechanically with structural tests.
  - Agents get observability tools (logs, metrics, spans) and reproduce bugs in isolated environments.
  - Codex opens PRs, reviews them and iterates until the criteria are met.
  - [InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
- OpenAI first tried one large AGENTS.md and it "failed in predictable ways". They replaced it with a file of about 100 lines that works as a *map* pointing to deeper docs. — [zby notes](https://zby.github.io/commonplace/sources/harness-engineering-leveraging-codex-agent-first-world); [rustman blog](https://rustman-blog.pages.dev/posts/harness-engineering)
- OpenAI also advises making checks runnable by agents and writing failure messages as fix instructions. This is a secondary summary. — [Morph](https://www.morphllm.com/harness-engineering)
- Anthropic's practices:
  - An **initializer agent** writes `init.sh`, a `claude-progress.txt` file, and a JSON **feature list** (200+ features for a claude.ai clone, all starting as failing). JSON was chosen because the model is less likely to wrongly overwrite it than Markdown.
  - Each coding session handles **one feature**, ends with a git commit and a progress update, and leaves the code in a clean state.
  - Each session starts the same way: run pwd, read the progress file and the git log, run init.sh, and run a basic end-to-end test.
  - End-to-end testing through browser automation (Puppeteer MCP) "dramatically improved performance".
  - [Anthropic, 2025-11-26](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- Failure modes Anthropic designed against: trying to one-shot the whole app, running out of context mid-feature, declaring victory early, marking features done without end-to-end tests, and spending time working out how to run the app. — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- Böckeler's taxonomy:
  - **Guides** are feedforward controls: AGENTS.md, specs, skills.
  - **Sensors** are feedback controls. *Computational* sensors (tests, linters, type checkers, structural analysis) are cheap and deterministic and run on every change. *Inferential* sensors (AI review, LLM-as-judge) are slower, costlier and non-deterministic, and should be used selectively.
  - "Feedback alone leads to repeated mistakes; feedforward alone never checks whether rules worked."
  - **Harnessability**: strong typing, clear module boundaries and opinionated frameworks make a codebase easier to harness.
  - **Steering loop**: when an issue recurs, the human improves a guide or sensor.
  - "Keep quality left": fast checks run before integration and expensive ones after.
  - Treat AI-generated tests with caution.
  - [martinfowler.com, 2026-04-02](https://martinfowler.com/articles/harness-engineering.html)
- Böckeler also says the functional spec is the main feedforward guide for behaviour, and that correctness "is beyond any sensor's reach if the human never clearly specified what they wanted." — [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)
- OpenAI's reference implementation, "Symphony", reportedly polls Linear issues, spawns an isolated Codex agent for each task and returns PRs. This comes from secondary coverage and I did not verify it. — [Morph](https://www.morphllm.com/harness-engineering)

**Results and claims**
- OpenAI's experiment ran 5 months from an empty repo and produced a beta product of about 1M LOC with no manually written source. — [InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
- The team merged about 1,500 PRs. It started with 3 engineers and later had 7, averaging about 3.5 PRs per engineer per day. These figures come from secondary summaries of the OpenAI post. — [zby notes](https://zby.github.io/commonplace/sources/harness-engineering-leveraging-codex-agent-first-world); [OpenAI mt-MT mirror](https://openai.com/mt-MT/index/harness-engineering/)
- OpenAI's key lesson was that early progress was slow because the environment was underspecified, not because Codex lacked capability. The fixes went into the repo and the tooling. — [Morph](https://www.morphllm.com/harness-engineering); [InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
- Anthropic says Opus 4.5 in a plain Agent SDK loop with only a high-level prompt falls short of a production-quality app. Its claims are qualitative and come with no benchmarks. — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- One engineering team graded itself against the OpenAI playbook (2026-07-22). This is an example of practitioner adoption; I did not read its findings. — [Orbital Witness](https://tech.orbitalwitness.com/posts/2026-07-22-grading-ourselves-against-the-harness-engineering-playbook/)

**Cost**
- Neither OpenAI nor Anthropic published token or dollar costs. Böckeler says computational sensors are cheap and should always run, inferential sensors are expensive and shouldn't run on every commit, and a full harness is costly to build, so you should prioritize. — [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html); [InfoQ (no cost info)](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)

### Inferences
- For a solo dev the cheap, high-value part of a harness is: a short AGENTS.md/CLAUDE.md that acts as a map, deterministic linters, type checks and tests whose error messages tell the agent what to fix, a progress file plus git commits for continuity across sessions, and an e2e smoke test. Everything else, such as LLM-judge review on every commit or multi-agent QA, adds cost and has weaker evidence behind it.
- Harness engineering does not replace specs. In Böckeler's model the spec is a guide that sits inside the harness.

### Gaps
- I found no independent, controlled measurement of harness engineering's effect on quality or cost. All headline numbers come from vendors.
- I did not fetch the original OpenAI post (403) or Hashimoto's post, so the AGENTS.md "~100 lines" detail and the step numbering are secondhand.
- I did not find a LangChain-specific "harness engineering" source.

## 2. Loop engineering: meaning, originators, practices, evidence, cost, risks

### Takeaway
"Loop engineering" took off in June 2026, mainly through Addy Osmani's essay of 2026-06-07. It means designing systems that prompt the agent: scheduled or event-triggered runs, a machine-checkable stop condition, persistent state, and verification by a separate checker. Osmani credits Peter Steinberger with the framing "designing loops that prompt your agents". Huntley's "Ralph Wiggum" bash loop (mid-2025) is its crude ancestor. There is essentially no hard evidence for it: the support is anecdotes plus loud warnings about cost and "comprehension debt".

### Cited Findings
- **Osmani's definition (2026-06-07):** you stop prompting the agent turn by turn and design a system that prompts it. His five components plus memory are:
  - automations (scheduled discovery and triage)
  - git worktrees (so parallel agents don't collide)
  - skills (SKILL.md project knowledge)
  - plugins and connectors (MCP)
  - sub-agents (one writes, another verifies)
  - state (a markdown file or Linear board kept outside the conversation)
  - [addyosmani.com, 2026-06-07](https://addyosmani.com/blog/loop-engineering/)
- **Layering:** the harness is the environment one agent runs in, and the loop sits a level above it, running on a timer, spawning helpers and feeding itself. Osmani says loop engineering is *harder* than prompt engineering, not easier. — [Osmani](https://addyosmani.com/blog/loop-engineering/)
- **Stop condition:** `/goal` in both Claude Code and Codex keeps working until a verifiable condition holds, such as tests passing and lint clean. In Claude Code a separate small model judges whether the goal is met. Osmani's rule is to keep the maker separate from the checker. — [Osmani](https://addyosmani.com/blog/loop-engineering/)
- A guide that appears vendor-affiliated says Claude Code supports `/loop`, cron scheduling and hooks natively in 2026. — [aibuilderclub guide](https://www.aibuilderclub.com/blog/loop-engineering-guide-2026)
- One practitioner definition: "automated control structures that repeatedly invoke coding agents, triggered on a schedule or by events, with each run bounded by a machine-checkable stop condition", with state kept across runs and independent verification. — [requesty.ai blog](https://www.requesty.ai/blog/loop-engineering-how-to-build-ai-agent-loops-that-run-themselves)
- **Andrew Ng's framing** (per ADTmag, 2026-07-01) describes three nested loops: the agentic coding loop, the developer feedback loop and the external (user/market) feedback loop. — [ADTmag, 2026-07-01 (403 to fetch; via search snippet)](https://adtmag.com/articles/2026/07/01/loop-engineering-emerges-as-developers-put-ai-coding-agents-on-repeat.aspx)
- **Academic uptake** includes arXiv papers "Loop Engineering: Building Blocks, Adoption, and Impact" (2608.21884) and "Stop Hand-Holding Your Coding Agent: Engineering the Loops…" (2607.00038). One paper places loop engineering after prompt, context and harness engineering. I did not read either paper's results. — [arXiv 2608.21884](https://arxiv.org/pdf/2608.21884); [arXiv 2607.00038](https://arxiv.org/pdf/2607.00038)
- **Ralph Wiggum loop:** Geoffrey Huntley created it in mid-2025. It is essentially a bash `while` loop that pipes the same prompt into an agent repeatedly. Recommended safeguards are a max-iterations cap and a completion signal. Huntley's stated aim is to cut software maintenance costs below "a fast food worker's wage". — [Rutigliano blog, Jan 2026](https://daviderutigliano.github.io/portfolio-website/posts/2026/01/the-ralph-wiggum-technique/); [Dev Interrupted podcast](https://www.podrocket.ai/podcast/d83c13e2-ebdf-4cb8-8985-cd58897be75e/episode/3fbdbf91-1861-46ee-9137-7803e7f79fb8)
- A claim attributed to Huntley, that a $50k contract was delivered for $297 in API costs, appears only in blogs and I could not verify it against a primary source. — [Ralph loop critique](https://piperstreetsoftware.pages.dev/articles/ralph-loop-isnt-a-strategy.html)
- **Critiques of Ralph loops:** they are only worth running when success is checkable, failures are actionable, regressions can be rejected and cost is bounded. "A loop that feels smart to the user can look very different on an invoice." — [Piper Street, "The Ralph Wiggum Loop Isn't a Strategy"](https://piperstreetsoftware.pages.dev/articles/ralph-loop-isnt-a-strategy.html); [DEV: agent loops need cost discipline](https://dev.to/jacob_is_surfing/agent-loops-need-cost-discipline-now-1i5o)
- **Cost:** Osmani says you "absolutely have to be careful" about tokens, because each sub-agent does its own model and tool work, so use them only where a second opinion is worth it. — [Osmani](https://addyosmani.com/blog/loop-engineering/)
- **Risks:** Osmani names four:
  - "done" is a claim, not proof, so verification stays with the human
  - **comprehension debt**: you ship code you didn't write and don't understand
  - **intent debt**: agents fill gaps with confident guesses
  - **cognitive surrender**: letting the loop replace your judgment
  - Follow-up rule: "agents run the inner loop — you own the outer."
  - [Osmani](https://addyosmani.com/blog/loop-engineering/); [aibuilderclub summary](https://www.aibuilderclub.com/blog/loop-engineering-addy-osmani)
- An arXiv paper documents infinite or non-terminating agentic loops, which shows runaway loops are a real failure mode. — [arXiv 2607.01641](https://arxiv.org/pdf/2607.01641)
- **Evidence status:** Osmani's essay has no benchmarks or metrics. It rests on his own workflow and on social posts by Steinberger and Boris Cherny. Claimed figures like "60–80% cost reduction" in vendor blogs are unverified. — [Osmani](https://addyosmani.com/blog/loop-engineering/); [search-level caveat on requesty/vendor content](https://www.requesty.ai/blog/loop-engineering-how-to-build-ai-agent-loops-that-run-themselves)

### Inferences
- A loop is only as good as its stop condition and its verifier. Without the harness (deterministic tests and lint) a loop just burns tokens, so loop engineering *depends on* harness engineering.
- For a solo dev with a cost-sensitive budget, the defensible use is narrow, bounded loops: fix until tests and lint pass, with an iteration cap, or scheduled triage. Open-ended overnight "build the app" loops are hard to justify on cost or comprehension grounds.

### Gaps
- I found no published token or dollar figures for real loop runs from a primary source.
- I did not read the arXiv loop-engineering papers' empirical results.
- I could not fetch the ADTmag article (403), so Ng's framing is from the search snippet.

## 3. Spec-driven development in 2026: still best practice? Critiques; relation to harness and loops

### Takeaway
SDD is not dead in 2026, but heavyweight SDD tooling such as Spec Kit and Kiro-style requirements→design→tasks is widely criticized as overkill for small changes and as a drift toward waterfall or MDD. Practitioners converge on lightweight, *spec-first* (not spec-as-source) specs: short, revisable, sized to the change, with verifiable acceptance criteria that feed the harness's sensors and the loop's stop condition.

### Cited Findings
- **Böckeler's taxonomy (martinfowler.com, 2025-10-15)** has three levels: *spec-first* (a spec written for the current task), *spec-anchored* (the spec is kept to guide later evolution) and *spec-as-source* (humans edit only the spec). Her verdict: spec-first is valuable, while spec-anchored and spec-as-source call for caution because they risk combining "MDD's inflexibility with LLMs' non-determinism." — [martinfowler.com, 2025-10-15](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)
- **Her test results:**
  - **Kiro:** a small bug fix generated 4 user stories with 16 acceptance criteria, "like using a sledgehammer to crack a nut".
  - **Spec Kit:** produced many interlinked markdown files for a 3–5 point feature. She could have done the feature faster with plain AI-assisted coding, and the agent ignored research notes and created duplicate classes.
  - **Tessl:** spec-as-source, with 1:1 spec-to-file mapping. Repeated generations from the same spec produced different code.
  - She would "rather review code than all these markdown files". Agents often ignored or over-applied the spec.
  - She closes by asking, "Are we making something worse in the attempt of making it better?"
  - [martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)
- A Scott Logic review of Spec Kit (cited secondhand) criticized its rigidity, its "sea of markdown" and its overhead. — [daniliants summary](https://daniliants-com.pages.dev/insights/understanding-spec-driven-development-kiro-spec-kit-and-tessl)
- **The waterfall critique:** Marmelab's "The Waterfall Strikes Back" is the reference point. Others argue SDD "isn't waterfall, but it keeps ending up there" without good tooling. — [dev.to/pacheco](https://dev.to/pacheco/spec-driven-development-isnt-waterfall-but-it-keeps-ending-up-there-4eei); [DEV: "renamed an old problem"](https://dev.to/sam_curatedmcp/spec-driven-development-renamed-an-old-problem-it-didnt-solve-it-tags-ai-productivity-347a)
- **The defense:** specs are living, versioned, iterative artifacts, not frozen phase gates (Marc Brooker's position; Allstacks, a vendor). — [Allstacks](https://www.allstacks.com/blog/spec-driven-development-isnt-waterfall-why-the-ai-coding-bottleneck-changed-everything)
- One practitioner's test: about 30 minutes to write a spec and 5–15 minutes for the agent to generate code, with total time roughly the same as without a spec. — [alexcloudstar, 2026](https://alexcloudstar.com/blog/spec-driven-development-2026/)
- **Proportionality:** a June 2026 commentary argues the mistake is applying the same amount of SDD to every change ("when structure helps and when it becomes tax"). — [ainexusdaily, 2026-06-01](https://ainexusdaily.vercel.app/article/2026-06-01-spec-driven-development-when-structure-helps-and-when-it-becomes-tax)
- **Relation to harness engineering:** in Böckeler's harness model the functional spec is the main feedforward guide. — [martinfowler.com, 2026-04-02](https://martinfowler.com/articles/harness-engineering.html)
- OpenAI's harness also contains specs in the form of a docs directory with execution plans and design specs. Those docs are mechanically checked for freshness, which is a direct answer to spec drift. — [InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)
- Several 2026 opinion pieces frame spec and harness as complementary: "a strong spec in a weak harness produces inconsistent output; a weak spec in a strong harness produces confident but wrong output." These are blog opinions. — [codagent newsletter](https://codagent.beehiiv.com/p/think-before-you-prompt); [besthub](https://besthub.dev/articles/why-spec-driven-development-remains-crucial-in-the-age-of-harness-engineering-769840a104bb)
- **Relation to loops:** loops need a verifiable stop condition (`/goal`, tests passing), and Osmani names "intent debt" (agents fill gaps in intent with guesses) as a core risk. An explicit spec or acceptance criteria are what pay that debt down. — [Osmani](https://addyosmani.com/blog/loop-engineering/)
- Anthropic's long-running harness uses a JSON feature list with pass/fail status per end-to-end feature. This is a minimal, machine-checkable form of spec. — [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

### Inferences
- The 2026 consensus pattern is "spec-lite inside a harness": a short spec per feature (goal, constraints, acceptance criteria written as tests or checks), a machine-readable feature or progress list, a short AGENTS.md map, and deterministic sensors. Specs are discarded or folded into docs after the change rather than maintained as the source of truth.
- A solo dev already doing SDD should keep the *spec-first* habit for non-trivial features, cut ceremony for bug fixes and small changes, and shift effort toward turning acceptance criteria into executable checks. That is the point where SDD, harness engineering and loop engineering meet.

### Gaps
- There are no controlled studies comparing SDD tools with lightweight specs on cost or quality. The evidence is case reports and opinion.
- I did not verify the 2026 status or adoption numbers of Kiro, Spec Kit or Tessl.

## 4. The "Karpathy CLAUDE.md"

### Takeaway
It is the GitHub repo **forrestchang/andrej-karpathy-skills**, which the fetch showed at **multica-ai/andrej-karpathy-skills** (install commands still point to forrestchang) with about **227k stars and 22.7k forks** as of today. It is a single CLAUDE.md, also packaged as a Claude Code plugin/skill, written by Forrest Chang, not by Karpathy. It distills Karpathy's X post of **2026-01-26** on LLM coding pitfalls into four rules. Karpathy is an OpenAI co-founder and former Tesla AI director, not ex-Anthropic. There is no benchmark evidence that the file works; the support is popularity plus qualitative anecdotes.

### Cited Findings
- **Repo and status:** the GitHub page (fetched 2026-10-31) shows multica-ai/andrej-karpathy-skills with 227.3k stars, 22.7k forks and 28 commits. Its install commands reference forrestchang/andrej-karpathy-skills. It "describes itself as derived from" Karpathy's observations, so Karpathy did not author it. — [GitHub](https://github.com/forrestchang/andrej-karpathy-skills)
- Reported star counts grew fast but are inconsistent across aggregators: "5,800" and "16k" in early DEV posts, 111k in spring, 176k in June 2026 and 227k now. Some sources credit "Jiayuan Chang" rather than Forrest Chang. — [DEV 5.8k](https://dev.to/max_quimby/karpathys-claudemd-template-5800-stars-and-what-it-does-4a09); [mer.vin, Jun 2026, 176k](https://mer.vin/2026/06/claude-skills-star-surge-how-one-claude-md-file-hit-176k-github-stars/); [pasqualepillitteri](https://pasqualepillitteri.it/en/news/1872/karpathy-claude-md-trending-github-llm-coding)
- Alvaro Cintas's tweet of 2026-05-03 is credited with amplifying it. — [search-level secondary](https://pasqualepillitteri.it/en/news/1872/karpathy-claude-md-trending-github-llm-coding)
- **Source post:** Karpathy's post is at https://x.com/karpathy/status/2015883857489522876 (2026-01-26). The README quotes it:
  - "The models make wrong assumptions on your behalf and just run along with them without checking."
  - "implement a bloated construction over 1000 lines when 100 would do."
  - [GitHub README](https://github.com/forrestchang/andrej-karpathy-skills)
- **Karpathy's background and context:** The Decoder (2026-01-27) calls him a "former OpenAI and Tesla AI researcher". He said agents "just don't work" in Oct 2025, then by Dec 2025 shifted to about 80% agent coding and 20% manual edits. His complaints:
  - "subtle conceptual errors that a slightly sloppy, hasty junior dev might do"
  - no clarifying questions and no surfacing of inconsistencies or tradeoffs
  - too sycophantic
  - bloated abstractions and dead code
  - His advice: watch code that matters closely.
  - (He co-founded OpenAI, was Tesla's AI director and later founded Eureka Labs; that is general knowledge, and the Decoder article confirms only ex-OpenAI and ex-Tesla.)
  - [The Decoder, 2026-01-27](https://the-decoder.com/former-tesla-ai-chief-andrej-karpathy-now-codes-mostly-in-english-just-three-months-after-calling-ai-agents-useless/)
- **The four rules (from the README and CLAUDE.md, paraphrased; the file says it "biases toward caution over speed"):**
  1. **Think Before Coding:** state assumptions, present multiple interpretations instead of silently picking one, suggest simpler approaches, and stop and name what is unclear.
  2. **Simplicity First:** write the minimum code that solves the problem, with no speculative features, single-use abstractions, unrequested configurability or handling of impossible cases. Simplify if a senior engineer would call it overcomplicated.
  3. **Surgical Changes:** touch only what the request needs and match the existing style. Don't refactor adjacent code. Mention unrelated dead code but don't delete it, and remove only the orphans your own change created. Every changed line should trace to the request.
  4. **Goal-Driven Execution:** turn tasks into verifiable goals, for example write a failing test that reproduces a bug before fixing it. For multi-step work, state a brief plan with a verification check per step.
  - [GitHub](https://github.com/forrestchang/andrej-karpathy-skills); [raw CLAUDE.md](https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md)
- **Effectiveness evidence:** the README's "How to know it's working" lists only qualitative signals: fewer unnecessary diff changes, fewer overcomplicated rewrites, clarifying questions before implementation, cleaner PRs. It admits the rules can be overkill for trivial tasks. There are no benchmarks. — [GitHub](https://github.com/forrestchang/andrej-karpathy-skills)
- I found no published benchmark or A/B result for this file. A tool called MDArena exists to benchmark CLAUDE.md files against real PRs, but I found no results for this file. Reviews are opinion pieces. — [shiporskip comparison](https://shiporskip.io/compare/karpathy-skills-claudemd-four-principles-claude-code-behavior-2026-vs-mdarena-claude-md-benchmarking-pr-performance-agent); [mcp.directory annotated](https://mcp.directory/blog/karpathy-claude-md-annotated-2026)
- Its rules overlap with harness guidance. Rule 4 is a guide that points the agent at sensors (tests), which matches Böckeler's guides+sensors model. Rule 1 targets the "intent debt" Osmani describes. — [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html); [Osmani](https://addyosmani.com/blog/loop-engineering/)

### Inferences
- The file is short, cheap in context tokens and low risk. Its four rules are generic good behavior that mostly duplicate what a good project CLAUDE.md or AGENTS.md says. Adopting it is reasonable, ideally by merging the four rules into your own short CLAUDE.md map rather than adding a plugin. Its star count reflects virality, not measured effectiveness.
- "Think before coding / ask when unclear" can conflict with autonomous loops, where nobody is there to answer questions. In loop mode, write assumptions to the progress file instead of blocking.
- Given Böckeler's point that feedforward alone never checks whether its rules worked, the file's value depends on having real sensors (tests, lint) that rule 4 can point at.

### Gaps
- There is no controlled evaluation of the file. I could not read Karpathy's X post directly (X is not fetchable), so the wording is via the README and The Decoder.
- The repo's creation date and the reason for the forrestchang to multica-ai redirect are not shown on the page.
- I found no substantive HN criticism thread.
