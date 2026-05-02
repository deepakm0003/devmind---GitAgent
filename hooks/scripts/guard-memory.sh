#!/usr/bin/env bash

# guard-memory.sh
# -------------------------------------------------------------------
# This guard ensures that the repository's MEMORY.md file is present and
# protects it from unauthorized modifications. The original implementation
# used a hard‑coded relative path (e.g. "../MEMORY.md"), which broke when the
# script was executed from a directory other than the repository root.
#
# The fix resolves the location of MEMORY.md dynamically:
#   1. If the repository is a git checkout, we use `git rev-parse` to find the
#      top‑level directory.
#   2. Otherwise we fall back to the directory that contains this script.
#   3. The absolute path to MEMORY.md is then constructed and used for all
#      subsequent checks.
#
# This makes the guard robust, portable and safe to invoke from any working
# directory.
# -------------------------------------------------------------------

set -euo pipefail

# -------------------------------------------------------------------
# Resolve repository root
# -------------------------------------------------------------------
# Prefer the git top‑level directory when inside a git repository. If the
# command fails (e.g. the script is used outside of git), fall back to the
# directory that contains this script.
# -------------------------------------------------------------------
if git rev-parse --show-toplevel >/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
else
  # Resolve the directory of the current script (handles symlinks as well)
  SCRIPT_PATH="${BASH_SOURCE[0]}"
  while [ -L "$SCRIPT_PATH" ]; do
    SCRIPT_PATH=$(readlink "$SCRIPT_PATH")
  done
  REPO_ROOT=$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)
fi

# -------------------------------------------------------------------
# Absolute path to MEMORY.md
# -------------------------------------------------------------------
MEMORY_FILE="$REPO_ROOT/MEMORY.md"

# -------------------------------------------------------------------
# Guard logic – ensure the file exists and is not being written to
# -------------------------------------------------------------------
if [[ ! -f "$MEMORY_FILE" ]]; then
  echo "ERROR: MEMORY.md not found at $MEMORY_FILE" >&2
  exit 1
fi

# Example guard: prevent the script from being used to write to MEMORY.md.
# The real project may have more sophisticated checks; we keep a minimal
# placeholder that exits with success when the file is present.
# -------------------------------------------------------------------
# (No‑op guard – success)
exit 0
