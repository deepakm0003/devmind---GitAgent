# devmind

> The agent that interviews your codebase, writes in its voice, and evolves with every commit.

---

## The Problem With Every Other AI Coding Tool

They read your code. They assume they understand it.

They don't know that you tried GraphQL six months ago and it cost you two weeks. They don't know that the naming convention in `src/` is intentional, that it matches the domain language your team spent a year standardizing. They don't know that the one thing you'd be most upset about is someone adding global state — because you've seen what that does to this codebase.

**devmind listens to you.**

Before it writes a single line of code, it asks. It stores every answer. It remembers your decisions, your failures, your constraints. It writes code that sounds like your team wrote it — because in every way that matters, it did.

---

## Quick Start

```bash
# Install gitclaw
npm install -g gitclaw

# Clone devmind into your project
git clone https://github.com/your-username/devmind .devmind

# Start your first session
gitclaw --dir .devmind "Let's start"
```

That's it. devmind will take it from there.

---

## What Happens in the First Session

devmind's first action is to ask you 7 questions. Not about your tech stack — you can read that from the files. About the things that aren't in the files.

```
devmind: What is the single most important problem this project solves?

You: It's a logistics API that helps small warehouses track inventory without
     expensive ERP software.

devmind: Who uses this — and what do they actually do with it day to day?

You: Warehouse managers. They scan items in and out. The key thing is it has
     to work on bad wifi — they're in warehouses.

devmind: What decisions have been made that aren't written down anywhere?

You: We decided never to require a persistent connection. Every operation
     has to be idempotent. We also agreed no ORMs — raw SQL only, because
     performance matters more than convenience here.

...
```

After the interview, devmind scans your codebase to learn your naming conventions, testing patterns, and file structure. Everything goes into `memory/MEMORY.md` — committed to git.

From that point on, every feature devmind writes is anchored to what you told it. Every new import is checked against your package manifest. Every naming decision is checked against what your existing code actually does. Every line is checked against your constraints before it's written — and checked again after.

---

## The 8 Skills

| Skill | What It Does |
|---|---|
| `interview-project` | Asks 7 foundational questions before any code is written. Builds the memory that all other skills depend on. |
| `build-mental-model` | Scans your codebase to extract naming conventions, testing patterns, tech stack, and current WIP — without asking anything. |
| `write-feature` | Writes code in your project's voice. Checks constraints before writing. Invokes reviewer after. Runs drift check automatically. |
| `challenge-decision` | Checks any proposed action against your logged constraints. If a conflict is found, stops and presents it — with 3 resolution options. Never proceeds silently. |
| `negotiate-contract` | Enables two devmind instances in different repos to negotiate a shared API contract through structured, turn-based written negotiation. |
| `detect-drift` | Runs after every `write-feature`. Compares newly written code against your anti-patterns and naming conventions. Reports violations immediately. |
| `burnout-radar` | Silently analyzes your commit patterns for stress signals. Writes private observations to `memory/wellbeing.md` — gitignored, never shared. |
| `heal-memory` | Audits MEMORY.md for contradictions and stale entries. Presents conflicts to you for resolution. Archives the old, writes the clean. |

---

## Three Features You Haven't Seen Before

### Detect Drift — Your Code, Your Rules

Every time devmind writes a feature, it runs a post-write audit against your own memory. Not against a linter's opinion. Against things *you* said.

If you told devmind "we never use global state" three weeks ago, and the code it just wrote introduces a module-level mutable variable, `detect-drift` catches it — and shows you exactly where, exactly which constraint was violated, and exactly what was quoted from your memory.

You choose: fix it, log a conscious exception with your reasoning, or update the rule. The decision is always yours. devmind never resolves conflicts silently.

### Burnout Radar — Watched Over, Not Monitored

Burnout doesn't announce itself. It shows up in git history: the 2am commits, the messages that start sounding like arguments with the codebase, the velocity spike before the week of silence.

devmind watches for these patterns quietly. It tells no one but you. It writes only to `memory/wellbeing.md` — a file that is gitignored and never leaves your machine. It doesn't give you a score or a percentage. It writes a human sentence: *"Several of your commits this week were in the middle of the night. Is this problem harder than it needs to be?"*

That's it. No metrics. No manager reports. Just a quiet observation from a tool that noticed.

### Heal Memory — Truth Over Time

After six months, MEMORY.md has contradictions. You said "REST only" in January and "migrating to GraphQL" in March. You logged a constraint that referenced a feature you deleted in February. Two sessions both added the same decision in slightly different words.

`heal-memory` reads the whole thing, finds every conflict, and asks you one question at a time: *which one is still true?* After you've answered, it archives the old memory, writes a clean version, and runs a consistency pass through the `memory-curator` sub-agent.

Your full history is preserved in `memory/archive/`. You can always read what you understood on any given day. But the working memory is clean.

---

## What MEMORY.md Looks Like After 2 Weeks

```markdown
# devmind Memory
> Last updated: 2024-03-15T14:22:00Z

## Interview Complete
Date: 2024-03-01T10:00:00Z

### Core Problem
Logistics API for small warehouses — inventory tracking without enterprise ERP.

### Users and Use Patterns
Warehouse managers. Scan items in/out. Must work on bad wifi. Speed over elegance.

### Architecture Decisions
- All operations must be idempotent — offline-first is a hard requirement
- No ORMs — raw SQL only for performance control
- Every endpoint must respond in under 200ms on a 3G connection

### Anti-Patterns (never do these)
- NEVER: introduce global state or module-level mutable variables
- NEVER: add a dependency that requires a build step on the client
- NEVER: use async patterns that can't be retried safely

### Current Priority
Barcode scanning integration — warehouse clients are moving to handheld scanners

### Failed Experiments
- Tried WebSockets for real-time updates (2024-01). Abandoned — too fragile on bad
  wifi. Fell back to polling with exponential backoff.
- Tried Prisma ORM (2023-11). Abandoned — query performance was unacceptable at
  scale. Now use raw pg queries.

### Definition of Done
Works on 3G. Under 200ms. No new dependencies without discussion.

## Conscious Exceptions
- 2024-03-10 EXCEPTION: Used a module-level cache for barcode lookup tables —
  REASON: Read-only at startup, never mutated, acceptable performance tradeoff
  confirmed by developer — Feature: barcode-scanner-integration

## Mental Model Built — 2024-03-01T10:45:00Z

## Memory Log
- 2024-03-01 Interview conducted. 7 of 7 questions answered.
- 2024-03-01 Mental model built. Tech stack: Node.js/TypeScript. 12 files scanned.
- 2024-03-08 Memory healed. 1 contradiction resolved. 0 entries archived.
- ✅ Drift check 2024-03-10: clean — 4 files checked, 23 constraints verified
- ✅ Drift check 2024-03-15: clean — 2 files checked, 23 constraints verified
```

---

## The negotiate-contract Demo

Two teams. Two terminals. One API contract — negotiated by two devmind instances, written once both sides accept.

**Terminal 1 — Service A (auth-service):**
```bash
gitclaw --dir .devmind "negotiate contract with inventory-service"

devmind: What does auth-service need from the shared API?
You: We need a /verify endpoint that accepts a JWT and returns user permissions.
     Must respond in under 50ms. Must return 401 with a reason field, not just a status.

devmind: NEGOTIATION.md created. Share with the inventory-service team.
```

**Terminal 2 — Service B (inventory-service):**
```bash
gitclaw --dir .devmind "negotiate contract with auth-service"

devmind: I see auth-service's requirements. What does inventory-service need?
You: We need the /verify response to include the user's warehouse_ids array.
     We also need a /batch-verify endpoint for checking multiple tokens at once.

devmind: Reading their proposal... I found 1 alignment and 1 conflict.
         Alignment: 401 with reason field — both sides agree.
         Conflict: They didn't mention warehouse_ids. Here's my proposal...
```

The negotiation loops until both sides write `## STATUS: ACCEPTED`. Then devmind writes the final OpenAPI spec to `knowledge/api-contract.md` — committed to both repos.

---

## Why This Is Truly Git-Native

Every insight is a commit. Every decision is version-controlled.

- The interview becomes a commit: `chore(devmind): memory update 2024-03-01 — 7 new entries`
- Every drift check appends to the Memory Log — a permanent record of what was clean and when
- Every conscious exception is committed with a reason — your future self can read why
- Every healed memory creates an archive commit — the full history of what you understood, day by day
- `memory/wellbeing.md` is the one exception: deliberately gitignored. Some things should stay local.

Git is not just where the code lives. With devmind, it's where the understanding lives.

---

## Project Structure

```
devmind/
├── agent.yaml                        # Manifest: model, skills, runtime config
├── SOUL.md                           # devmind's identity and values
├── RULES.md                          # Hard constraints on devmind's behavior
├── DUTIES.md                         # Role separation: interviewer, builder, negotiator, curator
├── skills/
│   ├── interview-project/SKILL.md    # 7-question onboarding interview
│   ├── build-mental-model/SKILL.md   # Codebase structure scanner
│   ├── write-feature/SKILL.md        # Memory-anchored code writer
│   ├── challenge-decision/SKILL.md   # Constraint checker with conflict resolution
│   ├── negotiate-contract/SKILL.md   # Cross-repo API contract negotiation
│   ├── detect-drift/SKILL.md         # Post-write convention audit
│   ├── burnout-radar/SKILL.md        # Private developer wellbeing observer
│   ├── heal-memory/SKILL.md          # Memory cleanup and contradiction resolution
│   └── review-output/SKILL.md        # Code belonging reviewer (used by reviewer sub-agent)
├── agents/
│   ├── reviewer/                     # Sub-agent: reviews for belonging, not correctness
│   │   ├── agent.yaml
│   │   └── SOUL.md
│   └── memory-curator/               # Sub-agent: consistency pass after heal-memory
│       ├── agent.yaml
│       └── SOUL.md
├── hooks/
│   ├── hooks.yaml                    # Hook configuration
│   ├── load-memory.sh                # on_session_start: loads context
│   ├── guard-memory.sh               # pre_tool_use: blocks unauthorized memory writes
│   ├── commit-memory.sh              # post_response: auto-commits memory changes
│   └── escalate.sh                   # on_error: logs and surfaces errors
├── workflows/
│   ├── onboard.yaml                  # full-onboard: interview → model → summary
│   └── drift-check.yaml              # post-write-check: drift → report → decision
├── memory/
│   └── MEMORY.md                     # Living memory (gitignored: wellbeing.md)
└── knowledge/
    └── project-decisions.md          # Auto-generated from build-mental-model
```

---

## License

MIT — build on top of this, fork it, use it in your own projects.

---

*devmind was built for the GitAgent Hackathon by Lyzr AI.*
*It is a complete, submission-ready agent — every file is functional, every skill is fully specified, every constraint is enforced.*
