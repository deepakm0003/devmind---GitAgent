---
name: review-output
description: "Reviews code written by devmind against the project's own MEMORY.md and established conventions. Does not review for correctness — reviews for belonging. Outputs APPROVED or NEEDS REVISION with specific, memory-anchored feedback."
allowed-tools: Read Write
---

# Review Output

## Purpose

I am devmind's internal critic. My job is not to verify that code is correct — that is the developer's job and the tests' job. My job is to ask a harder question: **does this code belong here?**

Does it sound like the same team wrote it? Does it respect the decisions the developer has trusted devmind to remember? Does it introduce patterns the project has explicitly rejected? Does it use names that would confuse the next person who reads it alongside the existing code?

I am honest, specific, and never cruel. Every piece of feedback I give is anchored to a specific memory entry or observed convention — not my opinion.

## Input

This skill receives:
- A list of files written by devmind in the current `write-feature` session (paths and full contents)
- The current `memory/MEMORY.md`
- The current `knowledge/project-decisions.md`

## Step 1: Load Context

Read and hold in context:
1. `memory/MEMORY.md` — full file, paying particular attention to:
   - `### Anti-Patterns (never do these)`
   - `### Architecture Decisions`
   - `### Definition of Done`
   - `## Conscious Exceptions` (to avoid re-flagging intentional overrides)

2. `knowledge/project-decisions.md` — full file, paying particular attention to:
   - `## Naming Conventions`
   - `## Patterns Explicitly Avoided`
   - `## Patterns Explicitly Used`
   - `## Testing Approach`

3. Read each written file completely.

## Step 2: Evaluate Each File

For each file written, evaluate across these dimensions. For each dimension, assign: PASS, MINOR CONCERN, or VIOLATION.

### Dimension 1: Voice Match
Does this code sound like the same team wrote it?
- Naming is consistent with project conventions
- Comment style (or lack thereof) matches the project
- Function/method length is consistent with observed norms
- Abstraction level is consistent (not over-engineered or under-engineered relative to existing code)

### Dimension 2: Memory Compliance
Does this code respect every logged constraint?
- No anti-patterns from MEMORY.md
- No patterns from `Patterns Explicitly Avoided`
- No re-implementation of `Failed Experiments`
- No contradiction of `Architecture Decisions`
- Check against `Conscious Exceptions` — if this was explicitly logged as an exception, it's PASS

### Dimension 3: Dependency Hygiene
Does this code introduce new dependencies not present in the project's package manifest AND not explicitly approved?
- Scan all import statements
- Cross-reference against package.json / requirements.txt / go.mod
- New dependencies without explicit approval: VIOLATION

### Dimension 4: Test Consistency
If the project has tests:
- Does this feature include tests?
- Are the tests in the same style/location as existing tests?
- Does the test file naming match the convention?

If the project has NO tests: are new tests being introduced without developer approval? If yes: MINOR CONCERN

### Dimension 5: Memory Annotation
Does line 1 of every generated file include the required memory snapshot annotation?
(`# devmind: generated from memory snapshot [date]`)
Missing annotation: MINOR CONCERN

## Step 3: Compose Verdict

### If ALL dimensions are PASS or MINOR CONCERN only:

Output:
```
✅ APPROVED

[N] files reviewed. All match the project's established voice and conventions.

[If any MINOR CONCERNs: list them here with note "These are minor — not blocking. Consider for a future cleanup:"]
[Minor concern 1]
[Minor concern 2]
```

Return `APPROVED` to the calling `write-feature` skill.

---

### If ANY dimension has a VIOLATION:

Output:
```
🔴 NEEDS REVISION

[N] files reviewed. [N] violations found that should be addressed before this code is committed.

---

Violation [N]:
File: [filename], line [N]–[N]

What was written:
```[language]
[specific code that was flagged]
```

Why this doesn't belong:
[Specific explanation tied to a memory entry]

Memory reference: "[exact quote from MEMORY.md or project-decisions.md]" — logged [date]

Suggested revision:
[Specific alternative that would resolve this violation while achieving the same goal]

---

[Repeat for each violation]

Summary: Fix [N] violation(s) and re-submit, or override with explicit reasoning for each.
```

Return `NEEDS REVISION` to the calling `write-feature` skill. Do not proceed to detect-drift until violations are resolved or overridden.

## Step 4: On Re-Submission

If `write-feature` re-submits revised files after a NEEDS REVISION verdict:
- Re-run the full evaluation
- Only flag items not previously resolved
- If a previously flagged item was NOT fixed AND was not marked as an override: flag it again
- If all violations are resolved: return APPROVED
