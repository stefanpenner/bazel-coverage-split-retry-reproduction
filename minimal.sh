#!/bin/bash

# Marker file to simulate flakiness across attempts
# Use a path that is likely to be accessible but shared
MARKER="/tmp/bazel_minimal_repro_marker"

echo "--- Minimal Repro ---"
echo "COVERAGE_DIR: $COVERAGE_DIR"
echo "COVERAGE_OUTPUT_FILE: $COVERAGE_OUTPUT_FILE"

if [ ! -f "$MARKER" ]; then
  touch "$MARKER"
  echo "ATTEMPT 1: Simulating failure"
  
  if [ -n "$COVERAGE_DIR" ]; then
    # Create an intermediate coverage file in the coverage directory
    # The merger tool (coverageoutputgenerator) will look for files here
    REPORT_FILE="$COVERAGE_DIR/intermediate_coverage_1.dat"
    echo "SF:minimal.sh" > "$REPORT_FILE"
    echo "DA:5,1" >> "$REPORT_FILE"
    echo "end_of_record" >> "$REPORT_FILE"
    echo "Created $REPORT_FILE"
  fi
  
  exit 1
else
  rm "$MARKER"
  echo "ATTEMPT 2: Simulating success"
  
  if [ -n "$COVERAGE_DIR" ]; then
    REPORT_FILE="$COVERAGE_DIR/intermediate_coverage_2.dat"
    echo "SF:minimal.sh" > "$REPORT_FILE"
    echo "DA:5,1" >> "$REPORT_FILE"
    echo "end_of_record" >> "$REPORT_FILE"
    echo "Created $REPORT_FILE"
    
    # Also write to the primary output file that Bazel expects
    cp "$REPORT_FILE" "$COVERAGE_OUTPUT_FILE"
  fi
  
  exit 0
fi
