#!/bin/bash
set -e

# Logic to determine which Bazel binary to use:
# 1. If $1 is a directory, treat it as Bazel source, build it, and use it.
# 2. If $1 is a file, use it as the Bazel binary.
# 3. Fallback to bazelisk.

if [ -d "$1" ]; then
  BAZEL_DIR="$1"
  echo "--- Building custom Bazel from source in $BAZEL_DIR ---"
  (cd "$BAZEL_DIR" && bazel build //src:bazel)
  BAZEL_BIN="$(cd "$BAZEL_DIR" && pwd)/bazel-bin/src/bazel"
elif [ -f "$1" ]; then
  BAZEL_BIN="$1"
else
  BAZEL_BIN="bazelisk"
fi

echo "Using Bazel at: $BAZEL_BIN"
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
