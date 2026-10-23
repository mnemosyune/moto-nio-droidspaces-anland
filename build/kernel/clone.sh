#!/bin/bash
# Clone the kernel source and toolchains used by build.sh.
set -e
cd "${NIO_BUILD_ROOT:-$HOME}"
mkdir -p nio-build
cd nio-build

echo "[$(date)] cloning clang"
git clone --depth=1 https://github.com/xiangfeidexiaohuo/Snapdragon-LLVM.git clang

echo "[$(date)] cloning gcc aarch64"
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 aarch64-linux-android-4.9

echo "[$(date)] cloning gcc arm"
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 arm-linux-androideabi-4.9

echo "[$(date)] cloning kernel source"
git clone --depth=1 https://github.com/Aessd/kernel_motorola_sm8250.git -b erofs kernel-source

echo "[$(date)] ALL_CLONES_DONE"
