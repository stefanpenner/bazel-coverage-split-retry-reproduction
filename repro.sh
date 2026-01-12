#!/bin/bash

# Clear flakiness marker
rm -f /tmp/bazel_minimal_repro_marker

# Run coverage with retry and split post-processing
# This command is expected to fail with a FileNotFoundException in the coverage merger
bazel coverage //:minimal_test \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --strategy=CoverageReport=local \
  --test_output=errors \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs
