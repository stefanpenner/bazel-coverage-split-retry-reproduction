#!/bin/bash
MARKER="/tmp/bazel_repro/marker"

if [ ! -f "$MARKER" ]; then
  touch "$MARKER"
  mkdir -p "$COVERAGE_DIR"
  touch "$COVERAGE_DIR/file1.dat"
  exit 1
else
  rm "$MARKER"
  exit 0
fi
