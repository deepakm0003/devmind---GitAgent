#!/usr/bin/env bash
# hooks/commit-memory.sh
# post_response: auto-commits MEMORY.md if modified during this session
set -e

MEMORY_PATH="${MEMORY_PATH:-memory/MEMORY.md}"
COMMIT_PREFIX="${COMMIT_PREFIX:-chore(devmind): memory update}"
COMMIT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Check if we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "[devmind commit-memory] Not a git repository — skipping auto-commit."
  exit 0
fi

# Check if MEMORY.md exists
if [ ! -f "$MEMORY_PATH" ]; then
  exit 0  # Nothing to commit
fi

# Check if MEMORY.md has been modified (staged or unstaged)
STAGED_CHANGES=$(git diff --cached --name-only "$MEMORY_PATH" 2>/dev/null || echo "")
UNSTAGED_CHANGES=$(git diff --name-only "$MEMORY_PATH" 2>/dev/null || echo "")

if [ -z "$STAGED_CHANGES" ] && [ -z "$UNSTAGED_CHANGES" ]; then
  exit 0  # No changes to MEMORY.md — nothing to commit
fi

# Count entries in current MEMORY.md
ENTRY_COUNT=$(grep -cE "^- " "$MEMORY_PATH" 2>/dev/null || echo "0")
SECTION_COUNT=$(grep -cE "^##" "$MEMORY_PATH" 2>/dev/null || echo "0")

# Stage MEMORY.md
git add "$MEMORY_PATH"

# Also stage any new knowledge files if they exist
if [ -d "knowledge/" ]; then
  git add knowledge/ 2>/dev/null || true
fi

# Also stage archive if new archives were created
if [ -d "memory/archive/" ]; then
  git add memory/archive/ 2>/dev/null || true
fi

# Construct commit message
COMMIT_MSG="$COMMIT_PREFIX $COMMIT_DATE — $ENTRY_COUNT entries, $SECTION_COUNT sections

Co-authored-by: devmind <devmind@gitagent>"

# Commit
git commit -m "$COMMIT_MSG" --no-verify 2>/dev/null && \
  echo "[devmind commit-memory] Memory committed: $ENTRY_COUNT entries." || \
  echo "[devmind commit-memory] Nothing new to commit."
