#!/usr/bin/env bats

# Tests for guard-memory.sh – ensures the script works from any directory and correctly detects staged changes.

setup() {
  # Create an isolated temporary git repository for each test.
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
  git init -q
  echo "Initial content" > MEMORY.md
  git add MEMORY.md
  git commit -m "init" -q

  # Copy the script under test into the repo root and make it executable.
  cp "${BATS_TEST_DIRNAME}/../hooks/scripts/guard-memory.sh" ./guard-memory.sh
  chmod +x guard-memory.sh
}

teardown() {
  rm -rf "$TMPDIR"
}

@test "script exits 0 when no changes to MEMORY.md" {
  run ./guard-memory.sh
  [ "$status" -eq 0 ]
}

@test "script exits 1 when MEMORY.md is staged with changes" {
  echo "New line" >> MEMORY.md
  git add MEMORY.md
  run ./guard-memory.sh
  [ "$status" -eq 1 ]
  [[ "$output" == *"Direct modifications to MEMORY.md are not allowed"* ]]
}

@test "script works when invoked from a subdirectory" {
  mkdir subdir
  cd subdir
  # From a nested directory, invoke the script using a relative path.
  run ../../guard-memory.sh
  [ "$status" -eq 0 ]
}
