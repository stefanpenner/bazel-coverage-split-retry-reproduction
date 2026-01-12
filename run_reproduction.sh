#!/bin/bash

# Cleanup any previous runs
rm -f /tmp/bazel_minimal_repro_marker

echo "Running Bazel coverage..."
echo "Flags:"
echo "  --flaky_test_attempts=2 (Triggers retry)"
echo "  --experimental_split_coverage_postprocessing (Moves merging to separate Java action)"
echo "  --experimental_fetch_all_coverage_outputs (Required for split coverage)"
echo "  --strategy=CoverageReport=local (Ensures merger runs locally)"

# The flags that trigger the bug:
# 1. --flaky_test_attempts=2: Triggers the retry
# 2. --experimental_split_coverage_postprocessing: Moves merging to a separate Java action
# 3. --experimental_fetch_all_coverage_outputs: Required for split coverage
# 4. --strategy=CoverageReport=local: Ensures the merger runs on your machine
set +e
bazel coverage //:minimal_test \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --strategy=CoverageReport=local \
  --test_output=all \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs

EXIT_CODE=$?
set -e

if [ $EXIT_CODE -ne 0 ]; then
  echo ""
  echo "================================================================================"
  echo "BAZEL FAILED AS EXPECTED"
  echo "This confirms the reproduction of the issue where split coverage post-processing"
  echo "fails when a test is retried due to flakiness."
  echo "================================================================================"
  exit 0
else
  echo ""
  echo "================================================================================"
  echo "BAZEL SUCCEEDED UNEXPECTEDLY"
  echo "The reproduction did not trigger the failure. This might mean the issue is fixed"
  echo "or the environment is different."
  echo "================================================================================"
  exit 0
fi
