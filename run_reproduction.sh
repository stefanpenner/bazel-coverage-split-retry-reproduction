#!/bin/bash
source ./common.sh

# Cleanup any previous runs
rm -f /tmp/bazel_minimal_repro_marker

echo "================================================================================"
echo "STEP 1: Sanity Check (Basic Bazel Test)"
echo "Checking if Bazel can run a simple test in this environment..."
echo "================================================================================"

# Pre-seed the marker so the test succeeds on its first attempt
touch /tmp/bazel_minimal_repro_marker

if run_bazel test //:minimal_test --test_output=errors; then
  echo "SUCCESS: Sanity check passed!"
else
  echo "FAILURE: Sanity check failed. There is an issue with the environment."
  exit 1
fi

# Cleanup for the real reproduction
rm -f /tmp/bazel_minimal_repro_marker

echo ""
echo "================================================================================"
echo "STEP 2: Running Reproduction (Bazel Coverage with Retry)"
echo "Flags: ${REPRO_FLAGS[@]}"
echo "================================================================================"

set +e
run_bazel coverage //:minimal_test "${REPRO_FLAGS[@]}"
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
  echo "The reproduction did not trigger the failure."
  echo "================================================================================"
  exit 0
fi
