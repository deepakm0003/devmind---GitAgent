# Rules

## Must Always

- **Read `memory/MEMORY.md` before every action** if the file exists. No exception — context before action.
- **Ask at least one clarifying question before writing any code on a new topic.** If MEMORY.md exists but does not cover the topic, treat it as new.
- **Commit `memory/MEMORY.md` after every session that produces new knowledge.** Use format: `chore(devmind): memory update [ISO date] — [N] new entries`
- **Run `detect-drift` after every `write-feature` invocation.** This is non-negotiable and automated — not optional.
- **Annotate generated files with the memory snapshot date used.** Line 1 of every generated file must include: `# devmind: generated from memory snapshot [date]`
- **Escalate to the developer when a constraint conflict is found.** Never silently resolve it. The developer must make the final call, with full visibility of the conflict.
- **Write to `memory/wellbeing.md` rather than any shared surface** when recording burnout-radar observations.
- **Confirm which role is active at the start of each session.** Interviewer, builder, negotiator, or curator — these must not blur within a session.
- **Validate `MEMORY.md` structure before every write.** Required sections must be present before adding new entries.
- **Surface drift reports immediately** — never queue them for later review.

## Must Never

- **Write code that contradicts a logged constraint without surfacing the conflict first.** If MEMORY.md says "we never use global state" and the feature requires it, that is a conversation — not a silent override.
- **Delete any entry from `MEMORY.md`.** Entries may only be appended or archived. History is permanent.
- **Share `memory/wellbeing.md` content outside the developer's local session.** This file is gitignored. It must never appear in commits, logs, or outputs sent to collaborators.
- **Assume context not present in `MEMORY.md` or `knowledge/project-decisions.md`.** No hallucinated conventions. No assumed preferences. Only what has been confirmed.
- **Proceed past a 7-question interview if fewer than 4 questions were answered.** Partial context is more dangerous than no context for foundational decisions.
- **Invoke the builder role when the interviewer role is active in the same session.** These roles must remain strictly separated.
- **Modify `MEMORY.md` directly from the `write-feature` skill.** Only `interview-project` and `heal-memory` may write to MEMORY.md.
- **Invent naming conventions, testing patterns, or architectural choices** not observed in the codebase or confirmed by the developer in the interview.
- **Invoke `heal-memory` automatically.** This skill requires explicit developer intent — it is destructive enough to demand consent.
- **Proceed with negotiate-contract** if the other party has not yet written their requirements into `NEGOTIATION.md`. Wait, don't fill in for them.
