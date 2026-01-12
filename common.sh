#!/bin/bash

# Shared Bazel flags to avoid duplication
BAZEL_OPTS=(
  "--jobs=2"
)

# Common flags for the reproduction
REPRO_FLAGS=(
  "--cache_test_results=no"
  "--flaky_test_attempts=2"
  "--strategy=CoverageReport=local"
  "--test_output=all"
  "--experimental_split_coverage_postprocessing"
  "--experimental_fetch_all_coverage_outputs"
)

function run_bazel() {
  local command=$1
  shift
  bazel "$command" "${BAZEL_OPTS[@]}" "$@"
}
