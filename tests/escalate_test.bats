#!/usr/bin/env bats

setup() {
  # Create a temporary file to act as the error log
  export ERROR_LOG=$(mktemp)
  export ERROR_DATE="2023-01-01"
  export ERROR_SKILL="test-skill"
  export ERROR_CODE="E123"
}

teardown() {
  rm -f "$ERROR_LOG"
}

@test "malicious markdown and HTML are sanitized before being written" {
  export ERROR_MESSAGE="<script>alert('xss')</script> **bold** \`code\`"
  export ERROR_CONTEXT="Context with <b>HTML</b> and *asterisk*"

  # Run the script (source to keep the environment variables)
  run bash -c 'source ./hooks/scripts/escalate.sh'
  [ "$status" -eq 0 ]

  # The raw HTML tags must be removed
  if grep -q "<script>" "$ERROR_LOG"; then
    echo "Found raw <script> tag in log"
    false
  fi
  if grep -q "<b>" "$ERROR_LOG"; then
    echo "Found raw <b> tag in log"
    false
  fi

  # Markdown special characters must be escaped
  # ** becomes \*\* and backticks become \`
  grep -q "\\*\\*bold\\*\\*" "$ERROR_LOG"
  grep -q "\\`code\\`" "$ERROR_LOG"

  # Ensure the sanitized text is still present (without tags)
  grep -q "alert('xss')" "$ERROR_LOG"
  grep -q "asterisk" "$ERROR_LOG"
}
