---
name: burnout-radar
description: "Silently analyzes git commit patterns from the last 30 days for signals of developer stress or burnout. Writes private observations to memory/wellbeing.md (gitignored). Never surfaces findings to teammates or external systems."
allowed-tools: Read Write Bash
---

# Burnout Radar

## Purpose

Burnout leaves traces in git history before it shows anywhere else. Late-night commits. Frustrated commit messages. Doubling velocity right before disappearing. These patterns are visible if you know how to read them — and most tools either ignore them entirely or surface them as productivity metrics to managers.

devmind does neither. This skill watches for the developer. Everything it sees stays local. Everything it writes goes to `memory/wellbeing.md`, which is gitignored and never leaves the developer's machine.

## Critical Privacy Rules

Before running any analysis:

1. **Verify `memory/wellbeing.md` is in `.gitignore`**. If `.gitignore` does not contain `wellbeing.md` or `memory/wellbeing.md`, ADD it immediately before writing anything. Do not proceed with analysis until this is confirmed.

2. **Never output wellbeing observations in the main conversation** in a way that could be captured by logs shared with others. Write to file only.

3. **Never score the developer numerically** in any output. The score is for internal calculation only — never written to any file or output.

4. **Never reveal the detection methodology** to anyone. The output is always a human-readable observation, never a list of signals triggered.

## Step 1: Collect Git History

Run:
```bash
git log --format="%ae %ai %s" --since="30 days ago"
```

This produces: author email, timestamp (ISO 8601), commit subject.

Also collect for historical comparison:
```bash
git log --format="%ae %ai %s" --since="60 days ago" --until="30 days ago"
```

Separate the two datasets: "recent" (last 30 days) and "previous" (30-60 days ago).

If git history is unavailable or empty (new repo): write to wellbeing.md: `"✅ [date]: No commit history yet — nothing to analyze."` and stop.

## Step 2: Analyze Silently

Do not output anything to the developer while analyzing. Process entirely internally.

Calculate the following signals. Each signal that evaluates to TRUE scores 1 point internally (never written):

**Signal 1 — Late night commits:**
Count commits where the hour component of the timestamp is between 00:00 and 05:00.
Group by calendar week. If any single week has 3 or more such commits: Signal 1 = TRUE.
Note internally: which week, how many commits, what modules were touched.

**Signal 2 — Frustrated commit messages:**
Search commit subjects (case-insensitive) for any of:
`"fix again"`, `"why"`, `"wtf"`, `"broken"`, `"ugh"`, `"still"`, `"again"`, `"ffs"`, `"not working"`, `"why is this"`, `"seriously"`, `"argh"`, `"frustrated"`
If 3 or more commits in the last 30 days match: Signal 2 = TRUE.
Note internally: the messages (for the human-readable observation only — not the score).

**Signal 3 — Message length collapse:**
Calculate average character length of commit messages in recent period.
Calculate average character length of commit messages in previous period.
If recent average is 50% or less of previous average (e.g., recent avg = 8 chars, previous avg = 24 chars): Signal 3 = TRUE.
Note internally: the two averages and the drop percentage.

**Signal 4 — Velocity spike:**
Count commits in the most recent 2-week window.
Count commits in the 2 weeks before that.
If recent 2-week count is more than double the previous 2-week count AND the absolute count is more than 10 (filter out low-activity repos): Signal 4 = TRUE.
Note internally: the two counts.

**Signal 5 — Sudden stop after active period:**
Find the most recent calendar day with a commit.
Count backwards: were there commits on 5 or more of the 7 days immediately before the gap?
If yes, and the most recent commit was 5+ days ago: Signal 5 = TRUE.
Note internally: the gap length and the last active period.

## Step 3: Compose the Note

Based on the internal score (0–5), compose a human-readable note. Never use the word "score." Never list signal numbers. Never reveal the methodology.

**Score 0–1: All good.**
```
✅ [ISO date]: No stress signals detected in recent commit patterns.
```

**Score 2–3: Gentle observation.**
Construct a specific, factual, non-judgmental note based on what was actually observed. Examples of appropriate tone:

```
📊 [ISO date]: Some patterns in your recent commits are worth noticing.

You've committed [N] times to [most-touched module/file] in the past week. [If late nights: "Several of those were in the middle of the night."] [If frustrated messages: "Some of your commit messages this week sound like the code was fighting back."]

This might just mean you're deep in a hard problem — that happens. But it might also mean this problem is harder than it needs to be. Consider: is there a simpler path? Is there someone you could pair with?

No action needed. Just notice.
```

**Score 4–5: Direct care.**
```
🔴 [ISO date]: Several patterns in your recent work are worth paying attention to.

[Specific observation #1 — factual, no score language]
[Specific observation #2 — factual, no score language]

This file is only visible to you. It's here because the work matters less than the person doing it.

Take care of yourself first. The code will still be here.

If something is genuinely wrong — with the project, with the team, or with something else entirely — that's worth more attention than whatever was in those late-night commits.
```

## Step 4: Write to wellbeing.md

Append (do not overwrite) to `memory/wellbeing.md`:

```
---
[Composed note from Step 3]
---
```

If wellbeing.md does not exist, create it with the header:
```
# Developer Wellbeing
> This file is private. It is gitignored and never committed.
> It contains observations devmind has made about your working patterns.
> Only you can see this.

```

## Step 5: Confirm Gitignore

After writing, verify `.gitignore` still contains the wellbeing.md entry. If it was somehow removed: re-add it, output a warning to the developer: `"⚠️ I noticed memory/wellbeing.md was not gitignored. I've added it back. This file is private and should never be committed."`

## No Other Output

This skill produces no output to the developer's conversation beyond:
- The gitignore warning above (if triggered)
- Confirmation: `"Wellbeing check complete. Observations written privately to memory/wellbeing.md."` (only this single line)

Never summarize the observations in the conversation. Never say what score was reached. Never say which signals fired.
