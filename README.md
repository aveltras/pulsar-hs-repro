Using the following library break when using ghc_plugin (the library uses FFI).

[pulsar-hs](https://github.com/hetchr/pulsar-hs)

To test

```sh
bazel run :example
```

gives the following error

```sh
bazel run :example
DEBUG: /home/romain/.cache/bazel/_bazel_romain/ef9ab8a8b80e23dc12e1983db0dd2853/external/rules_haskell/haskell/private/versions.bzl:60:10: WARNING: bazel version is too old. Supported versions range from 4.0.0 to 4.2.1, but found: 3.7.2- (@non-git)
INFO: Analyzed target //:example (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
ERROR: /home/romain/Code/pulsar-hs-repro/BUILD.bazel:19:15: HaskellBuildBinary //:example failed (Exit 1): ghc_wrapper failed: error executing command bazel-out/host/bin/external/rules_haskell/haskell/ghc_wrapper bazel-out/k8-fastbuild/bin/compile_flags_example__HaskellBuildBinary bazel-out/k8-fastbuild/bin/extra_args_example__HaskellBuildBinary

Use --sandbox_debug to see verbose messages from the sandbox ghc_wrapper failed: error executing command bazel-out/host/bin/external/rules_haskell/haskell/ghc_wrapper bazel-out/k8-fastbuild/bin/compile_flags_example__HaskellBuildBinary bazel-out/k8-fastbuild/bin/extra_args_example__HaskellBuildBinary

Use --sandbox_debug to see verbose messages from the sandbox
<command line>: /nix/store/mdh6w3b6v6hv79zpxm6zryn59drv63qr-pulsar-client-hs-1.0.0/lib/ghc-8.10.7/x86_64-linux-ghc-8.10.7/libHSpulsar-client-hs-0.1.0.0-K3rKHHtOBPtGKrJXfaFY8Z-ghc8.10.7.so: undefined symbol: pulsar_message_set_schema_version
Target //:example failed to build
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 0.711s, Critical Path: 0.61s
INFO: 2 processes: 2 internal.
FAILED: Build did NOT complete successfully
FAILED: Build did NOT complete successfully
```

Commenting out `plugins = ["polysemy_plugin"]` in `BUILD.bazel` fixed the problem but we can't do it on the main repo because we need it.
