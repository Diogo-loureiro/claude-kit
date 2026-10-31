# Playbook: how to work with claude-kit

The idea in one sentence: **you define what "correct" means with examples; the agent builds it;
automated checks decide when it's done.** You don't review code; you review intent.

## The cycle of a task

1. **One task = one session.** Open Claude in the project. When done, `/clear`.
2. **Ask in 4 parts**, briefly (see below).
3. The agent works. Every edited file is formatted; at the end of each turn the `Stop` hook
   runs `scripts/check stop` and won't let it stop while something fails.
4. `/ship` → full checks, review in a fresh context, commit and PR with evidence.
5. CI runs the same checks + secrets scan + gates. You read **the PR summary**, not the code.
6. **Validate by running it** before merging: use the feature for real (send the real input, look
   at the output). Tests prove what you specified; using it proves it's what you wanted.
   That's how you "keep your hands on the wheel" without reading code.

## Prompts: short, with a definition of done

No giant prompts needed. Permanent rules already live in CLAUDE.md, hooks and CI; the prompt only
says **what changes now**. Use the 4 parts (one line each is enough):

```
Goal: <what the user can now do>
Approach: <only if you have a preference; otherwise omit>
Don't: <limits: no new dependency, don't touch X>
Done when: <verifiable test/command/behavior>
```

Real example:
```
Goal: import a Nubank OFX statement into the selected account.
Don't: add a dependency without asking me; touch the balance calculation.
Done when: importing the same file twice doesn't duplicate transactions and scripts/check stop passes.
```

A long prompt only makes sense as a **spec** (below), and the agent writes the spec by interviewing you.

## By task size

| Size | How to ask | What you approve |
|---|---|---|
| Trivial (typo, config, 1-file bug) | Direct prompt, 1–2 lines | Nothing: hooks + CI |
| Medium (2–10 file feature) | 4 parts; "start with a failing test" | The PR (summary + evidence) |
| Large/critical (money, auth, import, schema) | `/spec <feature>` → approve → `/clear` → `/goal acceptance tests and scripts/check stop pass` | **The example table** (commit = lock) |
| Bulk mechanical (rename across 40 files) | `/model sonnet` in its own session, or `/batch` | Green CI |

Large tasks: `Shift+Tab` (plan mode) before coding shows the plan in 10 lines.

## The 3 things only you decide
1. **Acceptance examples** (what's correct). Committing `tests/acceptance/` = approving.
2. **New dependencies**: CI requires the `deps-approved` label on the PR.
3. **Harness changes** (hooks, lint, CI, approved tests): `harness-approved` label.
   To edit those files yourself in a session: `KIT_UNLOCK=1 claude`.

## Everyday commands
- `/clear` between tasks · `/rewind` to undo a bad path · `/btw` for a side question
- `/effort low|medium|high` (default: medium; high only for hard bugs or unfamiliar code)
- `/usage` and `/context`: cost and what's taking up context
- Two failed corrections? `/clear` and a better prompt, instead of insisting.
- **One session per area at a time.** Two sessions editing the same files overwrite each other.
  For real parallel work, give each session its own copy: `claude -w` (git worktree).

## Is this "loop engineering"?
Partly, in the right dose:
- **Inner loop** (agent ↔ checks): the Stop hook and `/goal` make the agent iterate until checks
  pass. That's harness engineering, and it pays off the most.
- **Outer loop** (scheduled): the `kit-update` workflow every Monday and, later, narrow routines
  (e.g., triaging Renovate PRs). Always with a machine-checkable stop condition and a cost cap.
- **What we avoid**: open loops ("build the app overnight"), multi-agent factories and per-specialty
  subagents. They spend far more tokens with no proven gain for a solo developer.

## More agents or more structure? (for your work and for agentic apps)
Anthropic's checklist ("Common workflow patterns", Mar 2026), in order:
1. Can a single agent handle it? **Stop here** (almost always the case).
2. Clear dependencies between steps? **Sequential** workflow.
3. Independent subtasks and speed matters? **Parallel**, with the way to merge results decided upfront.
4. Does refinement improve quality **measurably**? **Evaluator-optimizer**, with an iteration cap.
   If a linter or test can do the evaluation, use it instead of an evaluator agent.

Always keep the single-agent version as a baseline to prove the extra structure helps.

## Cost routine
- **Daily:** check `/usage`.
- **Weekly:** `npx ccusage@latest`; prune plugins marked "Not used recently".
- **Monthly:** `/doctor prompt-audit`; move repeated mistakes into the kit (each project's "Pitfalls" section).
- If you hit limits: `/clear` earlier → lower effort → Sonnet for mechanical work → only then a bigger plan.

## Improving the framework
Every improvement starts **in claude-kit**, never directly in a project. See the kit README.
