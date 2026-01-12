#!/bin/bash
MARKER="/tmp/bazel-repro/marker"

# Run the test logic
if [ -f "$MARKER" ]; then
  rm "$MARKER"
  echo "Attempt 2: Passing"
  EXIT_CODE=0
else
  touch "$MARKER"
  echo "Attempt 1: Failing with coverage"
  echo "COVERAGE_DIR: $COVERAGE_DIR"
  mkdir -p "$COVERAGE_DIR"
  touch "$COVERAGE_DIR/file1.dat"
  ls -la "$COVERAGE_DIR"
  EXIT_CODE=1
fi

# OPTION 1 WORKAROUND:
# If the test failed, purge the coverage directory.
# This prevents the split post-processor from attempting to find these
# ephemeral files in this sandbox during subsequent retries.
# if [ $EXIT_CODE -ne 0 ]; then
#   echo "Workaround: Cleaning up COVERAGE_DIR on failure..."
#   rm -rf "$COVERAGE_DIR"/*
# fi

exit $EXIT_CODE
