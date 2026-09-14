# Building LLVM for use with toolchains_llvm on macOS

This repo contains a basic script and code patch in order to build and package a copy of LLVM suitable for use with the Bazel [toolchains_llvm](https://github.com/bazel-contrib/toolchains_llvm) ruleset.

A matching text article for this repository can be found on my website: [Building macOS llvm for toolchains_llvm](https://steven.casagrande.io/posts/2024/building-macos-llvm-package/)

If you need a Linux toolchain, visit [David Zbarsky's static-clang](https://github.com/dzbarsky/static-clang), where you can build against MUSL.

## Details

This will build clang, libc++, and all other tools required by toolchains_llvm.

The LLVM project does not currently have a native bazel build for `libc++`, therefore we will need to use the `cmake` build process.

You will need to install all the required tools that the LLVM project requires.

```console
brew install bzip2 cmake coreutils git lz4 make ninja xz zlib zstd
```

The build process can be invoked via the [build-macos-llvm.sh](./build-macos-llvm.sh) file as follows:

```console
./build-macos-llvm.sh 17.0.6 ~/clang-17.0.6-x86_64-apple-darwin.tar.zst
```

Where the first arg is the version, and the second arg is the output path.

