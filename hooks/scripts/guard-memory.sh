#!/usr/bin/env bash

# guard-memory.sh
# Prevent direct modifications to MEMORY.md. The script now determines the repository root dynamically
# so it works no matter from which directory it is invoked.

set -euo pipefail

# Determine the repository root. If we are not inside a git repo, abort.
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$REPO_ROOT" ]]; then
  echo "Error: Not inside a git repository." >&2
  exit 1
fi

# Absolute path to MEMORY.md
MEMORY_FILE="$REPO_ROOT/MEMORY.md"

# Verify the file exists
if [[ ! -f "$MEMORY_FILE" ]]; then
  echo "Error: $MEMORY_FILE not found." >&2
  exit 1
fi

# Check for staged changes to MEMORY.md. If there are none, exit cleanly.
# `git diff --cached --quiet -- <file>` returns 0 when there are no staged changes.
if git diff --cached --quiet -- "$MEMORY_FILE"; then
  # No staged modifications – guard passes.
  exit 0
else
  echo "Error: Direct modifications to MEMORY.md are not allowed. Please use the designated process." >&2
  exit 1
fi
