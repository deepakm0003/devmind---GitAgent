# devmind

# https://devmind-git-agent.vercel.app/
> **The agent that asks before it acts.**  
> Built for the [GitAgent Hackathon 2026](https://hack.lyzr.ai) · Organized by Lyzr AI

[![gitagent](https://img.shields.io/badge/gitagent-0.1.0-7c3aed?style=flat-square)](https://github.com/open-gitagent/gitagent)
[![gitclaw](https://img.shields.io/badge/runtime-gitclaw-a78bfa?style=flat-square)](https://github.com/open-gitagent/gitclaw)
[![model](https://img.shields.io/badge/model-openrouter%2Ffree-4ade80?style=flat-square)](https://openrouter.ai)
[![license](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

---

## What is devmind?

Most AI coding tools read your code and assume they understand it.

They don't know you tried GraphQL six months ago and it cost you two weeks.  
They don't know the naming convention is intentional.  
They don't know the one thing that would break your codebase is someone adding global state.

**devmind listens first.**

Before writing a single line of code, it interviews you — 7 questions about the things that are never in the files. It stores every answer in `memory/MEMORY.md`, committed to git. Every feature it writes after that is anchored to what you told it.

**Every decision is version-controlled. Every insight is a commit.**

---
<img width="1898" height="911" alt="image" src="https://github.com/user-attachments/assets/646a2421-4f42-40ab-a511-f6e164a1b9f9" />


## 🚀 Quick Install (3 Steps)

### Step 1 — Install the runtime

```bash
npm install -g gitclaw
npm install -g @shreyaskapale/gitagent
```

### Step 2 — Clone devmind

```bash
git clone https://github.com/deepakm0003/devmind---GitAgent.git devmind
cd devmind
```

### Step 3 — Set up your `.env` file

Create a `.env` file in the `devmind/` folder:

```bash
# devmind/.env
OPENROUTER_API_KEY=your_openrouter_api_key_here
```

> **Get a free API key** → [openrouter.ai/keys](https://openrouter.ai/keys)  
> Sign up free. No credit card needed for free models.  
> devmind uses `openrouter/free` — **completely free, 200K context**.

Your `.env` is already in `.gitignore` — it will never be committed.

### Step 4 — Start devmind

**On Windows (PowerShell):**
```powershell
cd devmind
.\run.ps1
```

**On Mac/Linux:**
```bash
cd devmind
OPENROUTER_API_KEY=your_key_here gitclaw --dir .
```

You'll see:
```
devmind v1.0.0
Model: openrouter:openrouter/free
Skills: build-mental-model, burnout-radar, challenge-decision, detect-drift,
        heal-memory, interview-project, negotiate-contract, write-feature
→ 
```

---

## 🎯 How to Use devmind on Any Project

devmind lives in its own folder. You point it at any project using full paths.

### Run the interview on your project

At the `→` prompt:

```
Use the interview-project skill on "/path/to/your/project"
```

**Windows example:**
```
Use the interview-project skill on "D:\projects\my-app"
```

**Mac/Linux example:**
```
Use the interview-project skill on "/home/user/projects/my-app"
```

devmind will ask **7 questions** — answer them honestly. It takes about 3 minutes.  
After you answer, it writes everything to `memory/MEMORY.md` and commits it automatically.

---

## 💬 Demo Commands

Once devmind is running, try these at the `→` prompt:

| Command | What it does |
|---|---|
| `Use the interview-project skill on "/path/to/project"` | 7-question interview → writes MEMORY.md |
| `Use the build-mental-model skill on "/path/to/project"` | Scans all files, learns your patterns |
| `Use the write-feature skill: add rate limiting to "/path/to/project"` | Writes code using your memory |
| `Use the detect-drift skill on "/path/to/project"` | Checks new code against your decisions |
| `Use the burnout-radar skill on "/path/to/project"` | Analyzes commit patterns for stress |
| `Use the heal-memory skill` | Cleans contradictions from MEMORY.md |
| `/memory` | View current MEMORY.md |
| `/skills` | List all 8 skills |
| `/quit` | Exit devmind |

---

---

## ❓ What Problem Does devmind Solve?

Every software project carries **invisible knowledge** — decisions, failures, and constraints that only exist in people's heads:

- *"We tried Redis for caching and dropped it — too much infra overhead"*
- *"JWT tokens must be per-user-id, not per-IP — Alex discovered why the hard way"*
- *"Never use global state — it caused a production incident twice"*

When a developer leaves, this knowledge disappears. When AI tools generate code, they ignore it entirely.

**devmind captures this knowledge before it's lost, and uses it in every line of code it writes.**

---

## 🧠 The 8 Skills

| # | Skill | What It Does |
|---|---|---|
| 01 | `interview-project` | Asks 7 foundational questions before any code is written. Builds the memory all other skills depend on. |
| 02 | `build-mental-model` | Scans your codebase — naming conventions, testing patterns, tech stack, WIP — without asking anything. |
| 03 | `write-feature` | Writes code in your project's voice. Checks constraints before writing. Runs drift check automatically after. |
| 04 | `challenge-decision` | Checks any proposed action against your logged constraints. If a conflict is found, stops and shows you — never proceeds silently. |
| 05 | `negotiate-contract` | Two devmind instances in different repos negotiate a shared API contract through structured written negotiation. |
| 06 | `detect-drift` ⭐ NEW | Runs after every write. Compares new code against your anti-patterns. Reports violations with the exact memory entry violated. |
| 07 | `burnout-radar` ⭐ NEW | Silently analyzes commit patterns for stress signals. Writes private observations to `memory/wellbeing.md` — **never shared, never committed to remote**. |
| 08 | `heal-memory` ⭐ NEW | Audits MEMORY.md for contradictions and stale entries. Asks you to resolve each one. Archives the old, keeps the clean. |

---

## ✨ Three Features You Haven't Seen Before

### 1. Detect Drift — Your Rules, Enforced

devmind checks new code against **your own decisions**, not a generic linter.

If you told devmind "we never use global state" and the code it just wrote introduces one — it catches it:

```
⚠️  devmind: drift detected
    New code: globalCache in routes/cache.js:47
    Contradicts: Memory entry #8 (2026-01-14)
    "Never use global state — race conditions in prod"

    [1] Fix the code   [2] Update the rule   [3] Log a conscious exception
```

The decision is always yours. devmind never resolves conflicts silently.

---

### 2. Burnout Radar — Watched Over, Not Monitored

Burnout shows up in git history before developers notice it: 2am commits, velocity spikes before silence, messages that sound like arguments with the codebase.

devmind watches for these patterns **quietly**. It tells no one but you. It writes only to `memory/wellbeing.md` — a file that is gitignored and never leaves your machine:

```
📊 April 8, 2026

You've committed to auth.js 14 times this week.
Three of those were after midnight.

Is this problem harder than it needs to be?
The code will still be here tomorrow.
```

No metrics. No manager reports. Just a quiet observation from a tool that noticed.

---

### 3. Heal Memory — Truth Over Time

After months of use, MEMORY.md accumulates contradictions. You said "REST only" in January and "migrating to GraphQL" in March. `heal-memory` finds every conflict and asks you one at a time: *which one is still true?*

```
$ gitclaw heal-memory
devmind: Scanning 47 entries...
devmind: Found 2 contradictions, 1 stale entry.
devmind: Contradiction: REST only (Jan 14) vs GraphQL migration (Mar 08). Which is true?
you: REST only — we cancelled the GraphQL migration
devmind: ✓ Archived: entry from Mar 08. Memory healed. 44 entries remain.
```

---

## 📁 Project Structure

```
devmind/
├── agent.yaml                         # Manifest: model, skills, runtime config
├── SOUL.md                            # devmind's identity and values
├── RULES.md                           # Hard constraints on devmind's behavior
├── DUTIES.md                          # Role separation between sub-agents
├── .env.example                       # Template for your .env file
├── run.ps1                            # Windows launcher script
│
├── skills/
│   ├── interview-project/SKILL.md     # 7-question onboarding interview
│   ├── build-mental-model/SKILL.md    # Codebase structure scanner
│   ├── write-feature/SKILL.md         # Memory-anchored code writer
│   ├── challenge-decision/SKILL.md    # Constraint checker with conflict resolution
│   ├── negotiate-contract/SKILL.md    # Cross-repo API contract negotiation
│   ├── detect-drift/SKILL.md          # Post-write convention audit ⭐
│   ├── burnout-radar/SKILL.md         # Private developer wellbeing observer ⭐
│   └── heal-memory/SKILL.md           # Memory cleanup and contradiction resolver ⭐
│
├── agents/
│   ├── reviewer/                      # Sub-agent: reviews code for "belonging"
│   └── memory-curator/                # Sub-agent: consistency pass after healing
│
├── workflows/
│   ├── onboard.yaml                   # full-onboard: interview → model → summary
│   └── drift-check.yaml               # post-write-check: drift → report → decision
│
├── memory/
│   └── MEMORY.md                      # Living memory (wellbeing.md is gitignored)
│
├── knowledge/
│   └── project-decisions.md           # Auto-generated from build-mental-model
│
└── index.html                         # Demo website
```

---

## 🔑 Environment Variables

| Variable | Required | Description |
|---|---|---|
| `OPENROUTER_API_KEY` | ✅ Yes | Your OpenRouter API key — get one free at [openrouter.ai/keys](https://openrouter.ai/keys) |

Create a `.env` file in the `devmind/` root:

```bash
OPENROUTER_API_KEY=sk-or-v1-your-key-here
```

> ⚠️ Never commit this file. It is already in `.gitignore`.

---

## 🌐 Why This Is Truly Git-Native

Every insight is a commit. Every decision is version-controlled.

- Interview → `chore(devmind): memory update — 7 new entries`
- Drift check → appends to Memory Log (permanent audit trail)
- Conscious exception → committed with your reasoning
- Healed memory → archived to `memory/archive/` with timestamp
- `memory/wellbeing.md` → **deliberately gitignored, stays local only**

Git is not just where the code lives. With devmind, it's where the **understanding** lives.

---

## 🏆 Judging Criteria Coverage

| Criterion | Weight | How devmind addresses it |
|---|---|---|
| **Agent Quality** | 30% | SOUL.md defines identity with precision. RULES.md has 12 hard constraints. Memory system is the core differentiator. |
| **Skill Design** | 25% | 8 focused, well-documented skills. Each with YAML frontmatter, clear instructions, allowed-tools. |
| **Working Demo** | 25% | Runs live via `gitclaw --dir .`. Demonstrated on a real RealWorld API repo. |
| **Creativity** | 20% | burnout-radar (novel), detect-drift (enforces your own decisions), heal-memory (MEMORY.md as living truth). |

---

## License

MIT — build on top of this, fork it, use it in your own projects.

---

*devmind was built for the GitAgent Hackathon by Lyzr AI.*  
*Every file is functional. Every skill is fully specified. Every constraint is enforced.*
