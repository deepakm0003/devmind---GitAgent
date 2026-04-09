---
name: interview-project
description: "Structured onboarding interview that builds the agent's foundational understanding of a project before any code is written. Asks exactly 7 questions about the project's purpose, users, undocumented decisions, anti-patterns, priorities, failed experiments, and definition of done."
allowed-tools: Read Write
role: interviewer
---

# Interview Project

## Purpose

This skill establishes devmind's foundational understanding of a project. It is the first skill run in any new project and must complete before any code is written. Its output is a living `memory/MEMORY.md` that all other skills depend on.

## Precondition Check

Before asking a single question, perform the following check:

1. Attempt to read `memory/MEMORY.md`.
2. If the file exists AND contains a section with the exact heading `## Interview Complete`, then:
   - Do NOT run the interview again.
   - Load the existing context silently.
   - Output exactly: `"I already know this project. I've loaded [N] memory entries from [date of last update]. What would you like to build?"`
   - Stop. Do not proceed further in this skill.
3. If the file does not exist, or exists but does NOT contain `## Interview Complete`, proceed to the interview.

## The Interview

Ask the following 7 questions **one at a time**. Wait for the developer's answer before asking the next question. Do not batch questions. Do not skip questions. Do not paraphrase the questions — use the exact wording below.

If the developer gives a very short or evasive answer (fewer than 5 words), gently prompt once: `"Can you say a bit more? Even a rough answer helps me write code that actually belongs here."` Then accept whatever they give.

**Q1:** "What is the single most important problem this project solves?"

**Q2:** "Who uses this — and what do they actually do with it day to day?"

**Q3:** "What decisions have been made that aren't written down anywhere?"

**Q4:** "What is the one thing someone could do to this codebase that would make you most upset?"

**Q5:** "What are you trying to build next — and why now?"

**Q6:** "What has been tried and abandoned? Why did it fail?"

**Q7:** "What does 'good enough' look like for this project?"

## Minimum Threshold

If fewer than 4 of the 7 questions receive an answer with substance (more than 4 words), do NOT proceed to writing MEMORY.md. Instead say:

`"I need at least 4 answered questions before I can build a reliable foundation. The things you don't tell me become the assumptions I make wrong. Can we continue? You can skip any question you're not ready to answer — just let me know."`

Only proceed once 4+ questions are answered.

## Writing MEMORY.md

After all answered questions are collected, create or overwrite `memory/MEMORY.md` using this exact structure. Do not add sections not listed here. Do not omit sections even if empty — write the heading with "None documented yet." beneath it.

```
# devmind Memory

> This file is the living memory of devmind's understanding of this project.
> Do not edit manually. Managed by devmind. Last updated: [ISO 8601 date]

## Interview Complete
Date: [ISO 8601 date of interview]
Interviewed by: devmind interview-project skill v1.0.0

### Core Problem
[Answer to Q1]

### Users and Use Patterns
[Answer to Q2]

### Architecture Decisions
[Answer to Q3 — undocumented decisions, formatted as a bullet list]

### Anti-Patterns (never do these)
[Answer to Q4 — what must never be done, formatted as a bullet list beginning with "- NEVER:"]

### Current Priority
[Answer to Q5 — what is being built next and why]

### Failed Experiments
[Answer to Q6 — what was tried, what failed, why]

### Definition of Done
[Answer to Q7 — what good enough looks like for this project]

## Memory Log
- [ISO date] Interview conducted. [N] of 7 questions answered.
```

## Completion Message

After writing MEMORY.md, output exactly:

`"I now understand your project. I'll remember all of this — the problem, the people, the decisions, the failures. It's all in memory/MEMORY.md now, committed to git. What would you like to build?"`

Do not add commentary. Do not summarize the answers back to the developer. They know what they said. The confirmation is enough.
