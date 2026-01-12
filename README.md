# Bazel Coverage Flaky Retry Repro

Minimal reproduction for a Bazel bug where coverage collection fails when a flaky test is retried with `--experimental_split_coverage_postprocessing` enabled.

## Run

```bash
./repro.sh
```

## Expected Failure

The coverage merger will fail with a `FileNotFoundException` while attempting to parse coverage files from previous attempts that are not present in the current sandbox.

```sh
================================================================================
==================== Test output for //:minimal_test:
Attempt 2: Passing
GCov does not exist at the given path: ''
Jan 12, 2026 6:15:00 PM com.google.devtools.coverageoutputgenerator.Main parseFilesSequentially
SEVERE: File /private/var/tmp/_bazel_stef/1ee73a197f863047f2b67307f9c113e9/sandbox/darwin-sandbox/97/execroot/_main/bazel-out/darwin_arm64-fastbuild/testlogs/minimal_test/_coverage/intermediate_coverage_1.dat could not be parsed due to: /private/var/tmp/_bazel_stef/1ee73a197f863047f2b67307f9c113e9/sandbox/darwin-sandbox/97/execroot/_main/bazel-out/darwin_arm64-fastbuild/testlogs/minimal_test/_coverage/intermediate_coverage_1.dat (No such file or directory)
java.io.FileNotFoundException: /private/var/tmp/_bazel_stef/1ee73a197f863047f2b67307f9c113e9/sandbox/darwin-sandbox/97/execroot/_main/bazel-out/darwin_arm64-fastbuild/testlogs/minimal_test/_coverage/intermediate_coverage_1.dat (No such file or directory)
        at java.base/java.io.FileInputStream.open0(Native Method)
        at java.base/java.io.FileInputStream.open(FileInputStream.java:219)
        at java.base/java.io.FileInputStream.<init>(FileInputStream.java:157)
        at com.google.devtools.coverageoutputgenerator.Main.parseFilesSequentially(Main.java:314)
        at com.google.devtools.coverageoutputgenerator.Main.lambda$parseFilesInParallel$0(Main.java:337)
        at java.base/java.util.stream.ReferencePipeline$3$1.accept(ReferencePipeline.java:195)
        at java.base/java.util.AbstractList$RandomAccessSpliterator.forEachRemaining(AbstractList.java:720)
        at java.base/java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:484)
        at java.base/java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:474)
        at java.base/java.util.stream.ReduceOps$ReduceTask.doLeaf(ReduceOps.java:952)
        at java.base/java.util.stream.ReduceOps$ReduceTask.doLeaf(ReduceOps.java:926)
        at java.base/java.util.stream.AbstractTask.compute(AbstractTask.java:327)
        at java.base/java.util.concurrent.CountedCompleter.exec(CountedCompleter.java:746)
        at java.base/java.util.concurrent.ForkJoinTask.doExec(ForkJoinTask.java:290)
        at java.base/java.util.concurrent.ForkJoinTask.doInvoke(ForkJoinTask.java:408)
        at java.base/java.util.concurrent.ForkJoinTask.invoke(ForkJoinTask.java:736)
        at java.base/java.util.stream.ReduceOps$ReduceOp.evaluateParallel(ReduceOps.java:919)
        at java.base/java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:233)
        at java.base/java.util.stream.ReferencePipeline.reduce(ReferencePipeline.java:558)
        at com.google.devtools.coverageoutputgenerator.Main.lambda$parseFilesInParallel$2(Main.java:338)
        at java.base/java.util.concurrent.ForkJoinTask$AdaptedCallable.exec(ForkJoinTask.java:1448)
        at java.base/java.util.concurrent.ForkJoinTask.doExec(ForkJoinTask.java:290)
        at java.base/java.util.concurrent.ForkJoinPool$WorkQueue.topLevelExec(ForkJoinPool.java:1020)
        at java.base/java.util.concurrent.ForkJoinPool.scan(ForkJoinPool.java:1656)
        at java.base/java.util.concurrent.ForkJoinPool.runWorker(ForkJoinPool.java:1594)
        at java.base/java.util.concurrent.ForkJoinWorkerThread.run(ForkJoinWorkerThread.java:183)

================================================================================
```
