#!/usr/bin/env bash
# hooks/guard-memory.sh
# pre_tool_use: blocks unauthorized writes to MEMORY.md
# Environment variables expected:
#   ALLOWED_WRITERS — comma-separated list of skills allowed to write MEMORY.md
#   CURRENT_SKILL   — set by gitclaw runtime to the active skill name
#   TOOL_ACTION     — set by gitclaw runtime: "write", "read", etc.
#   TOOL_TARGET     — set by gitclaw runtime: the file path being written
#   CURRENT_ROLE    — set by gitclaw runtime: "interviewer", "builder", "negotiator", "curator"

set -e

MEMORY_PATH="${MEMORY_PATH:-memory/MEMORY.md}"
ALLOWED_WRITERS="${ALLOWED_WRITERS:-interview-project,heal-memory}"
CURRENT_SKILL="${CURRENT_SKILL:-unknown}"
TOOL_ACTION="${TOOL_ACTION:-read}"
TOOL_TARGET="${TOOL_TARGET:-}"
CURRENT_ROLE="${CURRENT_ROLE:-unknown}"

# Only intercept write actions targeting MEMORY.md
if [ "$TOOL_ACTION" != "write" ] && [ "$TOOL_ACTION" != "create" ] && [ "$TOOL_ACTION" != "append" ]; then
  exit 0  # Not a write — allow
fi

# Normalize the target path
NORMALIZED_TARGET=$(echo "$TOOL_TARGET" | sed 's|^\./||')
NORMALIZED_MEMORY=$(echo "$MEMORY_PATH" | sed 's|^\./||')

if [ "$NORMALIZED_TARGET" != "$NORMALIZED_MEMORY" ]; then
  exit 0  # Not writing to MEMORY.md — allow
fi

# Check if current skill is in allowed writers list
IFS=',' read -ra ALLOWED_ARRAY <<< "$ALLOWED_WRITERS"
for ALLOWED in "${ALLOWED_ARRAY[@]}"; do
  if [ "$CURRENT_SKILL" = "$ALLOWED" ]; then
    exit 0  # Authorized — allow
  fi
done

# Block unauthorized write
echo "🚫 [devmind guard-memory] BLOCKED: skill '$CURRENT_SKILL' attempted to write MEMORY.md directly."
echo "   Only these skills may write MEMORY.md: $ALLOWED_WRITERS"
echo "   To update memory: use interview-project (for new knowledge) or heal-memory (for cleanup)."

# Additional role-based check
if [ "$CURRENT_ROLE" = "builder" ]; then
  echo "   Role conflict: the builder role cannot modify MEMORY.md. See DUTIES.md."
fi

exit 1  # Block the write
