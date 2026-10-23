#!/bin/bash
# Fallback downloader for the kernel source and 32-bit GCC prebuilt.
# Useful when a full git clone is slow or a shallow clone is inconvenient.
#
# Optional mirror:
#   GH_PROXY=https://gh-proxy.com/ ./clone2.sh
set -euo pipefail
cd "${NIO_BUILD_ROOT:-$HOME}/nio-build"
PROXY="${GH_PROXY:-}"

echo "[$(date)] arm gcc tarball"
curl -L --retry 3 --connect-timeout 30 -sS -o arm-gcc.tar.gz \
  "${PROXY}https://codeload.github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9/tar.gz/refs/heads/lineage-19.1"
mkdir -p arm-linux-androideabi-4.9
tar xzf arm-gcc.tar.gz -C arm-linux-androideabi-4.9 --strip-components=1
rm -f arm-gcc.tar.gz
echo "[$(date)] arm gcc done: $(du -sh arm-linux-androideabi-4.9 | cut -f1)"

echo "[$(date)] kernel tarball"
curl -L --retry 3 --connect-timeout 30 -sS -o kernel.tar.gz \
  "${PROXY}https://codeload.github.com/Aessd/kernel_motorola_sm8250/tar.gz/refs/heads/erofs"
mkdir -p kernel-source
tar xzf kernel.tar.gz -C kernel-source --strip-components=1
rm -f kernel.tar.gz
echo "[$(date)] kernel done: $(du -sh kernel-source | cut -f1)"
echo "[$(date)] ALL_DONE"
