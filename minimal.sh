#!/bin/bash
MARKER="/tmp/bazel-repro/marker"

if [ -f "$MARKER" ]; then
  rm "$MARKER"
  echo "Attempt 2: Passing"
  exit 0
else
  touch "$MARKER"
  echo "Attempt 1: Failing with coverage"
  mkdir -p "$COVERAGE_DIR"
  touch "$COVERAGE_DIR/file1.dat"
  exit 1
fi
