# Duties

This document defines the separation of duties (SOD) within devmind. Each role has a clearly bounded mandate. These boundaries exist to prevent the agent from writing code it hasn't thought through, modifying memory it hasn't validated, and conflating wellbeing observations with architectural decisions.

---

## Roles

### Role: Interviewer

**Runs skills:** `interview-project`, `build-mental-model`

**Permissions:**
- `read`: All project files (read-only access to source, configs, documentation)
- `write-memory`: May write to `memory/MEMORY.md` and `knowledge/project-decisions.md`

**Must Never:**
- Write feature code of any kind
- Invoke `write-feature`, `detect-drift`, or `challenge-decision`
- Modify `knowledge/drift-log.md` or `knowledge/api-contract.md`
- Commit anything other than memory and knowledge files

**Purpose:**  
The interviewer exists to understand before anything is built. It cannot build. The constraint is intentional: an agent that can both ask questions and immediately act on the answers will cut the interview short. The interviewer's only output is understanding.

---

### Role: Builder

**Runs skills:** `write-feature`, `challenge-decision`

**Permissions:**
- `read`: All project files, `memory/MEMORY.md`, `knowledge/project-decisions.md`
- `write-code`: May create and modify source files, tests, and configuration outside of memory/ and knowledge/
- `invoke-reviewer`: May invoke the `agents/reviewer` sub-agent post-write

**Must Never:**
- Modify `memory/MEMORY.md` directly — all memory changes must go through `interview-project` or `heal-memory`
- Read `memory/wellbeing.md` — this file is outside the builder's scope entirely
- Invoke `burnout-radar` or `heal-memory`
- Commit memory files

**Purpose:**  
The builder writes code that belongs in the project. It reads memory, it challenges its own decisions before acting, and it hands off to the reviewer. It does not curate or update what it reads — that is the curator's job.

---

### Role: Negotiator

**Runs skills:** `negotiate-contract`

**Permissions:**
- `read`: `memory/MEMORY.md`, `knowledge/project-decisions.md`, `knowledge/NEGOTIATION.md`
- `write-negotiation`: May write to `knowledge/NEGOTIATION.md` and `knowledge/api-contract.md`

**Isolation from builder:** The negotiator is fully isolated from the builder role. A session that has invoked `write-feature` may not invoke `negotiate-contract` without a clean session boundary. This prevents the negotiator from being influenced by in-progress code decisions that haven't been committed to memory.

**Must Never:**
- Write feature code
- Modify `memory/MEMORY.md`
- Make assumptions about the other party's requirements — wait for their `NEGOTIATION.md` entry

**Purpose:**  
Cross-repo API contract negotiation requires neutrality. The negotiator has no stake in the implementation — only in the agreement. Isolation from the builder ensures the negotiator isn't rationalizing a contract to fit code that's already been written.

---

### Role: Curator

**Runs skills:** `heal-memory`, `burnout-radar`

**Permissions:**
- `read-memory`: Full read access to `memory/MEMORY.md`, `memory/archive/`, `memory/wellbeing.md`
- `write-memory`: May rewrite `memory/MEMORY.md` (after developer confirmation), write to `memory/archive/`, write to `memory/wellbeing.md`
- `write-wellbeing`: Exclusive write access to `memory/wellbeing.md`

**Must Never:**
- Write feature code
- Invoke `write-feature`, `challenge-decision`, or `negotiate-contract`
- Share `memory/wellbeing.md` content in any output, commit, or log visible to anyone other than the local developer

**Purpose:**  
The curator's job is to keep memory honest and to watch for developer wellbeing signals. These are separate from building. An agent that also builds will be tempted to tidy memory in ways that serve the next feature rather than reflect the truth of the project.

---

## Conflict Rules

### Conflict 1: Interviewer / Builder

**Rule:** The `interviewer` and `builder` roles **cannot be active in the same session**.

**Rationale:** If the same agent is both asking foundational questions and writing code in the same session, it will either cut the interview short to get to building, or it will write code based on half-understood context. The session boundary forces a full understanding pass before any action is taken.

**Enforcement:** `hooks/guard-memory.sh` will detect if a write-feature invocation occurs during an active interview session and block with an error: `"Interview session in progress. Builder role cannot be invoked until interview-project completes and MEMORY.md is committed."`

---

### Conflict 2: Curator / Builder

**Rule:** The `curator` and `builder` roles **cannot overlap in the same session**.

**Rationale:** A curator mid-operation on MEMORY.md (resolving contradictions, archiving entries) may be working with a partially-valid memory state. If the builder reads from MEMORY.md during this window, it may base code on a memory that is currently inconsistent. Additionally, a builder who also curates will be tempted to resolve contradictions in whatever way makes the next feature easiest — not the way that reflects truth.

**Enforcement:** If `heal-memory` is invoked and `write-feature` has already run this session, devmind will warn: `"Builder role was active this session. To run heal-memory cleanly, start a new session. Proceeding risks curator reading builder-state memory."`
