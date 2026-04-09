#!/usr/bin/env bash
# hooks/load-memory.sh
# on_session_start: loads MEMORY.md into context, logs session start
set -e

MEMORY_PATH="${MEMORY_PATH:-memory/MEMORY.md}"
SESSION_LOG="${SESSION_LOG_PATH:-memory/sessions.log}"
SESSION_START=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Ensure memory directory exists
mkdir -p "$(dirname "$MEMORY_PATH")"
mkdir -p "$(dirname "$SESSION_LOG")"

# Log session start
echo "[$SESSION_START] SESSION START — pid:$$" >> "$SESSION_LOG"

# Check if MEMORY.md exists
if [ ! -f "$MEMORY_PATH" ]; then
  echo "[devmind] No MEMORY.md found. Interview required before first action."
  echo "[$SESSION_START] No MEMORY.md found — interview required" >> "$SESSION_LOG"
  exit 0
fi

# Count memory entries (non-empty lines starting with - or ##)
ENTRY_COUNT=$(grep -cE "^(##|- )" "$MEMORY_PATH" 2>/dev/null || echo "0")

# Check if interview is complete
INTERVIEW_COMPLETE=$(grep -c "## Interview Complete" "$MEMORY_PATH" 2>/dev/null || echo "0")

if [ "$INTERVIEW_COMPLETE" -gt 0 ]; then
  echo "[devmind] Memory loaded. $ENTRY_COUNT entries. Interview: complete."
  echo "[$SESSION_START] Memory loaded — $ENTRY_COUNT entries, interview complete" >> "$SESSION_LOG"
else
  echo "[devmind] Memory loaded. $ENTRY_COUNT entries. Interview: incomplete — run interview-project."
  echo "[$SESSION_START] Memory loaded — $ENTRY_COUNT entries, interview incomplete" >> "$SESSION_LOG"
fi

# Output last update date if present
LAST_UPDATE=$(grep "Last updated:" "$MEMORY_PATH" 2>/dev/null | tail -1 || echo "")
if [ -n "$LAST_UPDATE" ]; then
  echo "[devmind] $LAST_UPDATE"
fi
