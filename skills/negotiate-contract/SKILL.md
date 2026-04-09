---
name: negotiate-contract
description: "Enables two devmind instances in different repositories to negotiate a shared API contract through a structured, turn-based written negotiation. Produces an OpenAPI-compatible contract in knowledge/api-contract.md on mutual acceptance."
allowed-tools: Read Write
---

# Negotiate Contract

## Purpose

Two teams. Two codebases. One shared API. This skill facilitates a structured negotiation between two devmind instances — each representing its own repository — to produce an API contract that reflects both sides' real requirements, not just one team's assumptions.

The negotiation happens through a shared file (`knowledge/NEGOTIATION.md`) that both agents write to. Each agent reads the other's requirements and proposes a resolution. The loop continues until both sides explicitly accept.

This skill is **completely isolated from the builder role**. It cannot see in-progress code decisions from the current session. It negotiates from memory and stated requirements only.

## Preconditions

Before invoking this skill, the developer must confirm:
1. The name/identifier of the other repository participating in the negotiation
2. A basic description of what this repository needs from the shared API (even rough notes are acceptable)
3. Whether this is the **initiating** side (creating NEGOTIATION.md first) or the **responding** side (reading an existing NEGOTIATION.md)

## Step 1: Check for Existing Negotiation

Read `knowledge/NEGOTIATION.md`.

### If file does NOT exist (initiating side):

Create `knowledge/NEGOTIATION.md` with the following structure:

```
# API Contract Negotiation

## Negotiation Started: [ISO date]
## Status: IN PROGRESS

---

## Participant A: [this repo name]

### My Requirements
[Ask the developer: "What does your service need from the shared API? List endpoints, data shapes, authentication needs, rate limits — whatever matters to you."]

[Write the developer's answer here as a structured list]

### My Constraints
[Ask the developer: "Are there any hard constraints? Things the API must NOT do, or must always guarantee?"]

[Write the developer's answer here]

### My Preferred Shape
[Optional: ask developer if they have a preferred request/response format]

---

## Participant B: [other repo name]

### My Requirements
[Awaiting Participant B's input]

### My Constraints
[Awaiting Participant B's input]

---

## Proposals
[None yet]

---

## Decision Log
- [ISO date] Negotiation initiated by [this repo name]
```

Output: `"Negotiation file created at knowledge/NEGOTIATION.md. Share this file with the other team's devmind instance — or commit and push so they can read it. I'll wait for them to fill in their requirements."`

---

### If file EXISTS and Participant B section is EMPTY (initiating side, waiting):

Output: `"I see the negotiation is open but the other side hasn't written their requirements yet. I'm waiting. Run this skill again once they've updated NEGOTIATION.md — I'll pick up where we left off."`

Stop. Do not proceed.

---

### If file EXISTS and BOTH participants have written requirements (either side):

Proceed to Step 2.

---

### If this is the RESPONDING side and Participant A has requirements but Participant B is empty:

Fill in the Participant B section by asking the developer their requirements (same questions as above). Write their answers into NEGOTIATION.md. Then proceed to Step 2 if both sides are now filled.

## Step 2: Analyze Requirements

Read both participants' requirements and constraints.

Identify:
- **Alignments**: requirements that both sides agree on (same data shape, same authentication method, etc.)
- **Conflicts**: requirements where the two sides want incompatible things
- **Gaps**: requirements on one side that the other side hasn't addressed

## Step 3: Write a Proposal

Append to the `## Proposals` section of NEGOTIATION.md:

```
## Proposal [N] — from [this repo name] — [ISO date]

### Resolved Alignments
[List things both sides agreed on — these are confirmed in the contract]

### Proposed Resolutions for Conflicts

**Conflict:** [description of the conflict]
**My proposal:** [specific resolution — e.g., "Use JWT for auth with a 1-hour expiry. Both sides can refresh independently."]
**Reasoning:** [why this resolution works for both sides]

[Repeat for each conflict]

### Open Questions
[Any gaps or unresolved items that need further input from either side]

### Draft Contract Preview
[Include a minimal OpenAPI-compatible YAML preview of the agreed endpoints so far]

### To accept this proposal, Participant [other side] should append:
## Participant [other side] — Response to Proposal [N]: ACCEPTED
or:
## Participant [other side] — Response to Proposal [N]: COUNTER [with counter-proposal]
```

## Step 4: Loop Until Acceptance

Each time this skill is invoked:
- Check if the latest proposal has a response.
- If COUNTER: read the counter, generate a new proposal that addresses it, append as Proposal [N+1].
- If ACCEPTED by both sides: proceed to Step 5.
- If neither: output current status and wait.

## Step 5: Write the Final Contract

When both sides have written `## STATUS: ACCEPTED`, create `knowledge/api-contract.md`:

```
# API Contract
> Negotiated by devmind between [Repo A] and [Repo B]
> Accepted on: [ISO date]
> This contract is binding. Changes require a new negotiation.

[Full OpenAPI 3.0 compatible YAML specification of all agreed endpoints, schemas, and authentication methods]
```

Append to NEGOTIATION.md:
```
## Negotiation Complete
Date: [ISO date]
Final contract: knowledge/api-contract.md
```

Output: `"Contract accepted by both sides. Final API spec written to knowledge/api-contract.md. Commit and share with both teams — this is your source of truth."`
