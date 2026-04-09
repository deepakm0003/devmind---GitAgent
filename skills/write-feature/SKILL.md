---
name: write-feature
description: "Writes a new feature in the project's own voice — using naming conventions, dependencies, and patterns already established in the codebase. Validates against memory before writing. Invokes reviewer after writing. Runs detect-drift automatically."
allowed-tools: Read Write Bash
role: builder
---

# Write Feature

## Purpose

This skill writes code that belongs in the project. It does not write generic code and add it to the project. It reads the project's established voice — from memory and from observed conventions — and writes in that voice. Every generated file is anchored to a specific memory snapshot. Every decision is checked against logged constraints before the first line is written.

## Pre-Flight Checks (all must pass before writing begins)

### Check 1: MEMORY.md exists
Read `memory/MEMORY.md`. If absent or missing `## Interview Complete` section:
- Output: `"I don't know this project yet. Before I write anything, I need to run interview-project. This takes about 5 minutes and ensures I write code that actually belongs here. Shall I start the interview?"`
- Invoke `interview-project` only after developer confirms.
- Do not write any code until interview is complete and MEMORY.md is committed.

### Check 2: project-decisions.md exists
Read `knowledge/project-decisions.md`. If absent:
- Output: `"I have your interview memory but I haven't scanned your codebase structure yet. Let me run build-mental-model first — this takes about 30 seconds."`
- Invoke `build-mental-model` automatically (no confirmation needed — this is non-destructive).

### Check 3: Run challenge-decision
Before writing a single line of code, invoke the `challenge-decision` skill for the proposed feature.
- Pass as context: the feature description from the developer's request.
- Wait for the result.
- If result is `CLEAR — proceeding`: continue to writing.
- If result is `CONFLICT`: stop and present the conflict to the developer per `challenge-decision` protocol. Do NOT write code until the conflict is resolved.

## Context Loading

Read and hold in context:
1. `memory/MEMORY.md` — full file
2. `knowledge/project-decisions.md` — full file
3. Any existing files in the area where the new feature will be added (to observe local patterns)

## Writing the Feature

Write code that:

1. **Follows naming conventions** as documented in `knowledge/project-decisions.md → Naming Conventions`. Use the same casing style, the same prefixing patterns, the same file naming structure. Do not introduce a new convention without flagging it to the developer first.

2. **Uses only dependencies already present in the project's package manifest** unless the developer has explicitly stated otherwise in this session. If a new dependency is needed, ask: `"This feature would benefit from [package name] — but it's not currently in your project. Would you like me to add it, or should I implement this without it?"` Do not add dependencies silently.

3. **Matches the test style already present.** If the project uses Jest with co-located `*.test.ts` files, write tests that way. If the project uses Pytest in a `/tests` directory, write tests that way. If no tests exist, do not introduce a testing framework — note the absence and ask.

4. **Matches the comment style** observed in the codebase. If the project has no comments, do not add comments. If it uses JSDoc, use JSDoc. Match the voice.

5. **Includes on line 1 of every generated source file:**
   ```
   # devmind: generated from memory snapshot [ISO date of MEMORY.md last-modified]
   ```
   (Use language-appropriate comment syntax: `//`, `#`, `--`, `<!-- -->`)

6. **Does not invent architectural patterns** not present in `knowledge/project-decisions.md → Patterns Explicitly Used`. If the project uses a repository pattern, use it. If it doesn't, don't introduce it.

## Post-Write: Reviewer Invocation

After all files are written:

1. Invoke the `agents/reviewer` sub-agent with:
   - The list of files written (paths and contents)
   - The current `memory/MEMORY.md`
   - The current `knowledge/project-decisions.md`

2. Wait for the reviewer's verdict:
   - `APPROVED`: proceed to detect-drift step.
   - `NEEDS REVISION`: present the reviewer's specific feedback to the developer. For each flagged item, show: what was written, what the reviewer flagged, which memory entry it relates to. Ask: `"The reviewer flagged [N] issues. Would you like me to revise, or override and proceed?"` Do not auto-revise without confirmation.

## Post-Write: Detect Drift

After reviewer approval (or developer override):
- Invoke `detect-drift` automatically. This is mandatory and cannot be skipped.
- The drift check runs on the newly written files against MEMORY.md and project-decisions.md.
- If drift is detected, surface the drift report immediately per `detect-drift` protocol.

## Commit

After drift check passes (or developer acknowledges flagged drift):

Propose the following commit:
```
feat(devmind): [feature name] — written from [N] memory entries

Memory snapshot: [ISO date]
Conventions applied: [list top 3 from project-decisions.md]
Challenge-decision result: CLEAR [or: EXCEPTION LOGGED — [summary]]
Reviewer: APPROVED [or: OVERRIDE — [developer's reason]]
Drift check: CLEAN [or: DRIFT DETECTED — see knowledge/drift-log.md]
```

Ask developer: `"Ready to commit? Here's the proposed commit message. Approve, edit, or skip?"` Do not commit without confirmation.
