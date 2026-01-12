#!/bin/bash
set -e

mkdir -p /tmp/bazel-repro
rm -f /tmp/bazel-repro/marker

bazel clean
bazel coverage //:minimal_test \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --test_output=all \
  --strategy=CoverageReport=local \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs \
  --sandbox_add_mount_pair=/tmp/bazel-repro
