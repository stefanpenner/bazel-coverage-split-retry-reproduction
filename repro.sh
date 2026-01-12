#!/bin/bash
set -e

# Use provided bazel path, or default to bazelisk
if [ -n "$1" ]; then
  BAZEL_BIN="$1"
else
  BAZEL_BIN="bazelisk"
fi

echo "Using Bazel at: $(which $BAZEL_BIN || echo $BAZEL_BIN)"
$BAZEL_BIN version | grep "Build label" || true

mkdir -p /tmp/bazel-repro
rm -f /tmp/bazel-repro/marker

$BAZEL_BIN clean
$BAZEL_BIN coverage //:minimal_test \
  --cache_test_results=no \
  --flaky_test_attempts=2 \
  --test_output=all \
  --strategy=CoverageReport=local \
  --experimental_split_coverage_postprocessing \
  --experimental_fetch_all_coverage_outputs \
  --sandbox_add_mount_pair=/tmp/bazel-repro
