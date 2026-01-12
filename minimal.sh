#!/bin/bash
MARKER="/tmp/bazel_minimal_repro_marker"

if [ ! -f "$MARKER" ]; then
  touch "$MARKER"
  echo "Attempt 1: Failing"
  if [ -n "$COVERAGE_DIR" ]; then
    echo "SF:minimal.sh" > "$COVERAGE_DIR/intermediate_coverage_1.dat"
    echo "DA:5,1" >> "$COVERAGE_DIR/intermediate_coverage_1.dat"
    echo "end_of_record" >> "$COVERAGE_DIR/intermediate_coverage_1.dat"
  fi
  exit 1
else
  rm "$MARKER"
  echo "Attempt 2: Passing"
  if [ -n "$COVERAGE_DIR" ]; then
    echo "SF:minimal.sh" > "$COVERAGE_DIR/intermediate_coverage_2.dat"
    echo "DA:5,1" >> "$COVERAGE_DIR/intermediate_coverage_2.dat"
    echo "end_of_record" >> "$COVERAGE_DIR/intermediate_coverage_2.dat"
    cp "$COVERAGE_DIR/intermediate_coverage_2.dat" "$COVERAGE_OUTPUT_FILE"
  fi
  exit 0
fi
