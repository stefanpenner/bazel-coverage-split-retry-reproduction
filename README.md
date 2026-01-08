# Minimal Bazel Coverage Flaky Retry Reproduction

This is a standalone, minimal reproduction for a Bazel bug where coverage collection fails when a test is flaky and `--experimental_split_coverage_postprocessing` is enabled.

This happens on linux, not on mac.

## Running the Reproduction

```bash
./run_reproduction.sh
```

## Expected Result

The command will fail with a `java.io.FileNotFoundException` in the output, looking something like this:

```
SEVERE: File .../sandbox/darwin-sandbox/5/execroot/_main/bazel-out/darwin_arm64-fastbuild/testlogs/minimal_test/_coverage/intermediate_coverage_1.dat could not be parsed due to: ... (No such file or directory)
```
