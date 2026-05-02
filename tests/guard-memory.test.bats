#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Helper to create a temporary git repository with MEMORY.md and the guard script
setup() {
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
  git init -q
  echo "# Project Memory" > MEMORY.md
  mkdir -p hooks/scripts
  cp "$BATS_TEST_DIRNAME/../hooks/scripts/guard-memory.sh" hooks/scripts/guard-memory.sh
  chmod +x hooks/scripts/guard-memory.sh
}

teardown() {
  rm -rf "$TMPDIR"
}

@test "guard succeeds when executed from repository root" {
  run ./hooks/scripts/guard-memory.sh
  assert_success
}

@test "guard succeeds when executed from a subdirectory" {
  mkdir -p sub/dir
  cd sub/dir
  # Execute the script using a relative path that goes up to the repo root
  run ../../hooks/scripts/guard-memory.sh
  assert_success
}

@test "guard fails when MEMORY.md is missing" {
  rm MEMORY.md
  run ./hooks/scripts/guard-memory.sh
  assert_failure
  assert_output --partial "ERROR: MEMORY.md not found"
}
