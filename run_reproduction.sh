#!/bin/bash
set -e

# Cleanup any previous runs
rm -f /tmp/bazel_minimal_repro_marker

# The flags that trigger the bug:
# 1. --flaky_test_attempts=2: Triggers the retry
# 2. --experimental_split_coverage_postprocessing: Moves merging to a separate Java action
# 3. --experimental_fetch_all_coverage_outputs: Required for split coverage
# 4. --strategy=CoverageReport=local: Ensures the merger runs on your machine
bazel coverage //:minimal_test \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --strategy=CoverageReport=local \
  --test_output=all \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs \