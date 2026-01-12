#!/bin/bash
set -e

# Clear flakiness marker
mkdir -p /tmp/bazel_repro
rm -f /tmp/bazel_repro/marker

echo "Running reproduction..."

# We use a clean build and disable the disk cache to ensure 
# the reproduction is not affected by previous runs.

bazel clean
bazel coverage //:minimal_test \
  --disk_cache= \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --strategy=CoverageReport=local \
  --test_output=all \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs \
  --sandbox_add_mount_pair=/tmp/bazel_repro
