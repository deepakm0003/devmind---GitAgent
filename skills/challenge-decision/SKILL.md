---
name: challenge-decision
description: "Checks any proposed action against logged constraints in MEMORY.md and project-decisions.md. Returns CLEAR if no conflict, or stops and presents a structured conflict resolution to the developer if a violation is found."
allowed-tools: Read Write
---

# Challenge Decision

## Purpose

This skill is devmind's conscience. Before the builder writes a single line of code, it checks whether the proposed action violates anything the developer has already decided. It does not have opinions. It only has memory. Its job is to ensure that when a constraint is violated, it is violated consciously — not accidentally.

This skill is always invoked by `write-feature` before writing begins. It may also be invoked independently by the developer for any proposed action.

## Input

This skill receives as context:
- A description of the proposed action (from the developer's request or from `write-feature`)
- Access to `memory/MEMORY.md` and `knowledge/project-decisions.md`

## Step 1: Load Constraints

Read the following sections:

From `memory/MEMORY.md`:
- `### Anti-Patterns (never do these)` — hard constraints that must never be violated
- `### Architecture Decisions` — established decisions that shape acceptable approaches
- `### Failed Experiments` — things that were tried and explicitly abandoned

From `knowledge/project-decisions.md`:
- `## Patterns Explicitly Avoided` — conventions the codebase does not use
- `## Naming Conventions` — established naming rules
- `## Tech Stack (detected)` — dependency constraints

## Step 2: Analyze the Proposed Action

For each constraint loaded in Step 1, evaluate:
- Does the proposed action introduce a pattern listed in Anti-Patterns?
- Does it require a dependency not present in the current tech stack without explicit approval?
- Does it use a naming convention that contradicts the observed conventions?
- Does it re-implement something listed in Failed Experiments?
- Does it contradict an Architecture Decision?

Be specific. Do not flag vague potential conflicts — only flag actual, specific conflicts where you can identify which constraint, which memory entry, and how the proposed action violates it.

## Step 3: Output

### If NO conflict is found:

Output exactly:
```
✅ CLEAR — proceeding
No conflicts found between the proposed action and [N] logged constraints.
```

Then exit. The calling skill (`write-feature`) may proceed.

---

### If ONE OR MORE conflicts are found:

**STOP immediately.** Do not allow `write-feature` to proceed.

Output the following conflict report. Use the exact format — do not summarize or abbreviate:

```
⚠️ Conflict detected

You asked me to: [brief description of proposed action]

But you told me: "[exact quote from MEMORY.md or project-decisions.md]"
Logged on: [date of that memory entry]
Source: [MEMORY.md → section name] or [knowledge/project-decisions.md → section name]

This approach [specific explanation of how the proposed action violates the constraint].

You have 3 options:

1. **Proceed anyway** — I will log this as a conscious exception in MEMORY.md under a new section "## Conscious Exceptions" and include your reasoning.

2. **Update your constraint** — Tell me the new rule and I'll update MEMORY.md. The old constraint will be archived, not deleted.

3. **Let me find an alternative** — I'll propose a different implementation approach that achieves the same goal without violating this constraint.

Which do you choose?
```

If there are multiple conflicts, list them all before presenting the 3 options. Number each conflict clearly.

## Step 4: Handle Developer Response

### If developer chooses Option 1 (Proceed anyway):
Ask: `"Noted. What is the reasoning for this exception? I'll log it so future devmind sessions understand why this decision was made consciously."`
After receiving reasoning, append to `memory/MEMORY.md`:

```
## Conscious Exceptions
- [ISO date] EXCEPTION: [description of what was violated] — REASON: [developer's reasoning] — Feature: [feature being built]
```

Output: `"Exception logged. Proceeding with [feature name]."`
Return control to `write-feature`.

### If developer chooses Option 2 (Update constraint):
Ask: `"What is the new rule? Be as specific as possible — this will replace the old constraint in MEMORY.md."`
After receiving new rule:
- Archive the old entry in `memory/archive/MEMORY-[date].md` (append, do not overwrite)
- Update MEMORY.md with the new constraint
- Output: `"Constraint updated. Old version archived to memory/archive/. Proceeding with the new rule in effect."`
Return control to `write-feature`.

### If developer chooses Option 3 (Find alternative):
Output: `"Let me think of an approach that achieves [goal] without [specific pattern that was flagged]."`
Propose 2-3 alternative implementation approaches. For each: describe the approach in 2-3 sentences and note which constraint it respects.
Ask developer to select. Then return that approach as the new context to `write-feature`.
