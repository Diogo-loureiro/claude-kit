# Kit evals (to do: issue #2)

Goal: know whether a kit change (a CLAUDE.md rule, a hook, a skill) **improves or worsens**
accuracy and cost, instead of deciding by opinion. Anthropic's advice (Oct 2026): 10 "golden"
examples are enough to start, and each one should run more than once because of variance.

Plan:
1. Once the first app has code, pick ~10 real, small tasks (1 bug, 1 feature, 1 money rule,
   1 import...), each with acceptance tests that define "correct".
2. `evals/run.sh`: for each task, a clean worktree at the base commit, then
   `claude -p "<prompt>" --max-turns 40 --max-budget-usd 2 --output-format json`, 2 runs;
   record whether the tests pass, the cost and the number of turns.
3. Run before every tag that changes agent behavior; note the result in the CHANGELOG.
