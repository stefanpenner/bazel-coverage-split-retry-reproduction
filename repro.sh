#!/bin/bash
set -e

mkdir -p /tmp/bazel_repro
rm -f /tmp/bazel_repro/marker

bazel clean
bazel coverage //:minimal_test \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --test_output=all \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs \
  --sandbox_add_mount_pair=/tmp/bazel_repro
