---
name: spec
description: Turns a large or critical request (money, auth, import, schema) into a short spec with an example table and failing acceptance tests. The human approves the examples, not the code.
disable-model-invocation: true
argument-hint: <feature>
---

# Spec: $ARGUMENTS

The human approves **intent** (concrete examples), never code. The output of this skill is executable.
Write the spec in English; keep verbatim inputs (e.g. notification texts) in their original language.
Explain the table to the human in their language.

1. Read only what you need: the project's CLAUDE.md and related modules (LSP or grep, by section).
2. Ask, all at once, the questions (at most 5) about decisions the code can't answer.
   No human available: record them under "Assumptions" and take the most conservative option.
3. Write `docs/specs/<feature>.md`, at most 60 lines:
   - **Goal** (1–3 sentences) and **Out of scope**
   - **Examples**: table `scenario | input | expected result`. Include edges: zero, negative,
     rounding, duplicate, time zone/month boundary, invalid input.
   - **Invariants** (become property tests), **Decisions** and **Assumptions**
4. Write one test per table row in `tests/acceptance/` and run them: all must **fail** now
   for the right reason (show the output).
5. Stop. Show the table and ask for approval. The human approves by committing:
   `git add docs/specs tests/acceptance && git commit -m "spec: <feature>"`. Committed = locked.
6. State the next step: `/clear`, then
   `/goal the tests in tests/acceptance/<feature>* and scripts/check stop pass`.
