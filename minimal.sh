#!/bin/bash
MARKER="/tmp/bazel_repro/marker"

echo "COVERAGE_DIR: $COVERAGE_DIR"
echo "COVERAGE_OUTPUT_FILE: $COVERAGE_OUTPUT_FILE"

if [ ! -f "$MARKER" ]; then
  touch "$MARKER"
  echo "Attempt 1: Failing"
  if [ -n "$COVERAGE_DIR" ]; then
    mkdir -p "$COVERAGE_DIR"
    REPORT_FILE="$COVERAGE_DIR/intermediate_coverage_1.dat"
    echo -e "SF:minimal.sh\nDA:5,1\nend_of_record" > "$REPORT_FILE"
    echo "Created coverage file: $REPORT_FILE"
  fi
  exit 1
else
  rm "$MARKER"
  echo "Attempt 2: Passing"
  if [ -n "$COVERAGE_DIR" ]; then
    mkdir -p "$COVERAGE_DIR"
    REPORT_FILE="$COVERAGE_DIR/intermediate_coverage_2.dat"
    echo -e "SF:minimal.sh\nDA:5,1\nend_of_record" > "$REPORT_FILE"
    echo "Created coverage file: $REPORT_FILE"
    cp "$REPORT_FILE" "$COVERAGE_OUTPUT_FILE"
  fi
  exit 0
fi
