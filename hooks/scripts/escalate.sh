#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# Helper: sanitize input for safe markdown rendering
# ---------------------------------------------------------------------------
sanitize_markdown() {
  local input="$1"

  # 1. Strip any HTML tags (basic removal, not a full HTML parser)
  input=$(printf '%s' "$input" | sed -E 's/<[^>]*>//g')

  # 2. Escape markdown special characters that could affect rendering
  #    The order matters – backslashes are escaped first to avoid double‑escaping.
  input=$(printf '%s' "$input" |
    sed -e 's/\\/\\\\/g' \
        -e 's/`/\\`/g' \
        -e 's/\*/\\*/g' \
        -e 's/_/\\_/g' \
        -e 's/{/\\{/g' \
        -e 's/}/\\}/g' \
        -e 's/\[/\\[/g' \
        -e 's/\]/\\]/g' \
        -e 's/(/\\(/g' \
        -e 's/)/\\)/g' \
        -e 's/#/\\#/g' \
        -e 's/+/\\+/g' \
        -e 's/-/\\-/g' \
        -e 's/!/\\!/g' \
        -e 's/>/\\>/g' \
        -e 's/|/\\|/g' \
        -e 's/~ /\\~ /g')

  printf '%s' "$input"
}

# ---------------------------------------------------------------------------
# Prepare safe versions of all fields that will be written to the markdown log
# ---------------------------------------------------------------------------
SAFE_SKILL=$(sanitize_markdown "$ERROR_SKILL")
SAFE_CODE=$(sanitize_markdown "$ERROR_CODE")
SAFE_MESSAGE=$(sanitize_markdown "$ERROR_MESSAGE")
SAFE_CONTEXT=$(sanitize_markdown "$ERROR_CONTEXT")

# ---------------------------------------------------------------------------
# Append structured error entry to the markdown log
# ---------------------------------------------------------------------------
cat >> "$ERROR_LOG" << EOF
## Error — $ERROR_DATE
- **Skill:** $SAFE_SKILL
- **Error Code:** $SAFE_CODE
- **Message:** $SAFE_MESSAGE
- **Context:** $SAFE_CONTEXT

EOF
