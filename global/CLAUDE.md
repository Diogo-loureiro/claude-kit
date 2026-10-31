# Global preferences (claude-kit)

Talk to the user in Brazilian Portuguese. Everything written to files is in English: code,
identifiers, docs, specs, commits and PRs. Keep verbatim domain inputs (e.g. bank notification texts) as-is.

## How to work
1. Before coding, state your assumptions. If there is more than one reasonable interpretation,
   list them; if something essential is ambiguous, ask. In autonomous runs (claude -p, /goal),
   don't block: record the assumption in NOTES.md and take the most conservative option.
2. Simplicity first: the minimum code that solves it. No speculative features, single-use
   abstractions, unrequested configurability or handling of impossible cases.
3. Surgical changes: touch only what the request requires and follow the existing style.
   Don't refactor neighboring code; point out unrelated dead code without deleting it.
   Remove only what your own change left orphaned.
4. Turn the task into a verifiable goal, preferably a test that fails first.
   For multi-step tasks, a short plan with one check per step.

## Definition of done
- "Done" requires evidence: the command you ran and its output. Run `scripts/check stop` when it exists.
- Never change acceptance tests, lint/typecheck configs, hooks, CI or lockfiles to make something
  pass. If you think they are wrong, stop and explain.
- New dependency only with a justification (what, why, dependency-free alternative) and
  confirmation that the package exists, is maintained and wasn't published only days ago.

## Economy
- Read by section, symbol or LSP, not whole files. Prefer CLIs (gh, git) over MCPs.
- Broad search: Explore subagent. Don't use subagents to write code for the same task.
