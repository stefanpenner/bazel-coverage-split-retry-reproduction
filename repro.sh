#!/bin/bash
set -e

# Clear flakiness marker
rm -f /tmp/bazel_minimal_repro_marker

echo "Running reproduction..."

# Run coverage with retry and split post-processing
# We expect this to fail.
bazel coverage //:minimal_test \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --strategy=CoverageReport=local \
  --test_output=errors \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs
