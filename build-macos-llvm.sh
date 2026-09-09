#!/usr/bin/env sh

set -eux

LLVM_PROJ_DIR=/tmp/llvm-project-$1
LLVM_TAG="llvmorg-$1"
OUTPUT_PATH="$2"
MAJOR_VERSION=$(cut -d '.' -f 1 <<< $1)

rm -rf $LLVM_PROJ_DIR
git clone https://github.com/llvm/llvm-project.git --branch $LLVM_TAG --depth 1 $LLVM_PROJ_DIR
cp update-DistributionExample.cmake.patch $LLVM_PROJ_DIR

cd $LLVM_PROJ_DIR

git apply update-DistributionExample.cmake.patch

mkdir build && cd build
cmake -G Ninja -C ../clang/cmake/caches/DistributionExample.cmake ../llvm
ninja stage2-distribution

cd tools/clang/stage2-bins
find lib bin include -type d -name "CMakeFiles" -prune -exec rm -r {} +
find lib bin include -name cmake_install.cmake -delete
rm lib/libLLVM*.a lib/libclang*.a lib/liblld*.a
rm bin/{clang,clang++,clang-cl,clang-cpp}
rm bin/{ld.lld,ld64.lld,lld-link,wasm-ld}
rm bin/llvm-ranlib

pushd bin

ln -s clang-${MAJOR_VERSION} clang
ln -s clang-${MAJOR_VERSION} clang++
ln -s clang-${MAJOR_VERSION} clang-cl
ln -s clang-${MAJOR_VERSION} clang-cpp

ln -s lld ld.lld
ln -s lld ld64.lld
ln -s lld lld-link
ln -s lld wasm-ld

ln -s llvm-ar llvm-ranlib

popd

XZ_OPT="-9e -T0" tar -cJf ${OUTPUT_PATH} bin include lib

