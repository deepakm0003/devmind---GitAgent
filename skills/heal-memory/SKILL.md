---
name: heal-memory
description: "Audits MEMORY.md for duplicates, explicit contradictions, and stale context. Presents conflicts to the developer for resolution. Archives the old MEMORY.md and writes a clean, consistent version. Invokes memory-curator sub-agent for final consistency pass."
allowed-tools: Read Write
role: curator
---

# Heal Memory

## Purpose

Memory accumulates. Over weeks and months, MEMORY.md will contain things that used to be true, things that are currently true, things that were partially updated, and things that contradict each other. An agent working from contradictory memory is worse than an agent working from no memory — it will make confident decisions based on false premises.

This skill is the periodic maintenance that keeps devmind's memory honest. It must be invoked explicitly by the developer — never automatically. It is destructive enough to require consent.

## Warning Confirmation

Before doing anything, output:

```
⚠️ heal-memory will audit MEMORY.md for conflicts and contradictions. After your decisions, it will:
1. Archive the current MEMORY.md to memory/archive/
2. Write a new, clean MEMORY.md with only resolved truth
3. Run a consistency pass via the memory-curator sub-agent

This cannot be undone (though archives are permanent). Proceed?
```

Wait for confirmation. If developer says no or doesn't respond affirmatively: stop. Do not proceed.

## Step 1: Read Entire MEMORY.md

Read `memory/MEMORY.md` in full. If the file does not exist:
Output: `"No MEMORY.md found — nothing to heal. Run interview-project to create one."`
Stop.

## Step 2: Identify Issues

Analyze the full content for three types of issues:

### Type A: Duplicate Information
Two or more entries that say the same thing — same fact, same constraint, same decision — possibly in slightly different words. Often happens when the same topic was added in multiple sessions.

Criteria for duplicate:
- Same constraint or decision expressed twice (regardless of wording)
- Same anti-pattern listed under different section names
- Same failed experiment mentioned in both Failed Experiments and a later Architecture Decision

### Type B: Explicit Contradictions
Two entries on the same topic that reach different conclusions on different dates.

Examples:
- "We use REST for all APIs" (logged 2024-01-15) AND "We are migrating to GraphQL for all new endpoints" (logged 2024-03-02)
- "Never use global state" (logged 2024-02-01) AND "Auth state lives in a global store for performance" (logged as Conscious Exception 2024-04-10)
- "Definition of Done: MVP is good enough" (logged 2024-01-15) AND "All features require 80% test coverage before merge" (logged 2024-03-20)

Note: Conscious Exceptions are NOT contradictions — they are intentional overrides with logged reasoning. Do not flag them.

### Type C: Stale Context
References to things that no longer exist in the project:
- Mentions of features that have been deleted
- References to dependencies that are no longer in package.json
- Constraints about parts of the codebase that have been refactored away
- Interview answers about priorities that were completed months ago and never updated

To detect staleness: if the entry references a specific file, function, or dependency by name, check if it still exists. If you cannot check (no file access), flag it as "possibly stale — please verify."

## Step 3: Present Conflicts to Developer

Count total issues found. If zero issues:
Output: `"Memory is clean — no duplicates, contradictions, or stale context found. [N] entries reviewed."` Stop.

If issues found, output:

```
I found [N] issues in your memory. I need your decision on each one before I can write the clean version.

For each one, tell me: which is the current truth, or give me a new statement that replaces both.

---

[Issue 1] — TYPE: [Duplicate / Contradiction / Possibly Stale]

Entry A (from [date]):
"[exact quote from MEMORY.md]"

Entry B (from [date]):
"[exact quote from MEMORY.md]"

[For contradiction: "These two entries say opposite things about [topic]."]
[For duplicate: "These two entries say the same thing in different words."]
[For stale: "This entry references [thing] which [no longer exists in / could not be found in] the project."]

What is the current truth? (Or type "archive both" to remove without replacing.)

---
[Issue 2]...
```

Wait for the developer to answer ALL issues before proceeding. Do not accept partial answers — all issues must be resolved before writing the clean memory.

## Step 4: Archive Current MEMORY.md

After all issues are resolved by the developer:

1. Create directory `memory/archive/` if it does not exist.
2. Copy the current `memory/MEMORY.md` to `memory/archive/MEMORY-[ISO date]-pre-heal.md`
3. Verify the archive was written successfully before proceeding.

## Step 5: Write Clean MEMORY.md

Construct a new `memory/MEMORY.md` that:
- Retains all entries that had NO issues
- Replaces contradictory pairs with the developer's stated current truth
- Removes duplicates (keeping the most recent or the developer's preferred version)
- Removes stale entries (or marks them with a `[ARCHIVED - [date]]` prefix if the developer wants to keep for history)
- Preserves all Conscious Exceptions
- Preserves the full Memory Log section (append to it, never truncate)

Append to Memory Log:
```
- [ISO date] Memory healed. [N] contradictions resolved. [N] duplicates removed. [N] stale entries archived. Previous state: memory/archive/MEMORY-[date]-pre-heal.md
```

## Step 6: Invoke Memory Curator

After writing the clean MEMORY.md:
Invoke `agents/memory-curator` sub-agent with:
- The full contents of the new MEMORY.md
- Instructions: "Perform a final consistency pass. Check that no internal contradictions remain in the cleaned memory. Report any issues found. Do not modify the file — only report."

Wait for the curator's report.

If the curator finds remaining inconsistencies: present them to the developer with the same format as Step 3. Resolve, then re-write.

If the curator reports clean: proceed to completion.

## Step 7: Completion

Output:
```
Memory healed. ✅

Before: [N] entries, [N] issues
After: [N] entries, all consistent
Archive: memory/archive/MEMORY-[date]-pre-heal.md

The memory-curator confirmed the cleaned memory is internally consistent.

Ready to commit? This will create:
  - Updated memory/MEMORY.md
  - New archive file

Commit message will be:
"chore(devmind): memory heal [date] — [N] conflicts resolved, [N] entries archived"
```

Wait for developer confirmation before committing.
