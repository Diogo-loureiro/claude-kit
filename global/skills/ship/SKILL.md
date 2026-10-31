---
name: ship
description: Finishes a task - runs every check, reviews the diff in a fresh context, commits and opens a PR with evidence.
disable-model-invocation: true
---

# Ship

1. Run `scripts/check ci`. If it fails, fix it (at most 2 attempts); otherwise stop and report.
2. Review the diff with the `code-review` skill (fresh context): correctness against the spec, skip style.
   Fix only high-confidence findings and run step 1 again.
3. If the diff touches money, auth, parsing, import or I/O: also run `security-review`.
4. If on `main`, create a branch: `git switch -c <feat|fix|chore>/<slug>`.
   Commit using Conventional Commits.
5. `git push -u origin HEAD` and `gh pr create` with the body:
   **What** / **Why** / **Evidence** (commands + last lines of output) / **Risks** / spec link /
   **How to validate by running it** (the exact steps for the human to try the feature).
6. Reply with the PR URL and the validation steps, in the user's language. Don't merge.
