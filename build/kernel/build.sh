#!/bin/bash
# Build a Droidspaces-capable kernel for Motorola nio (sm8250, 4.19).
#
# Expected layout:
#   $NIO_BUILD_ROOT/
#     clang/                         Snapdragon-LLVM (clang 10.0.9)
#     aarch64-linux-android-4.9/     LineageOS GCC prebuilt
#     arm-linux-androideabi-4.9/     LineageOS GCC prebuilt
#     kernel-source/                 Aessd/kernel_motorola_sm8250, branch erofs
#     droidspaces.config             copied from this directory
#
# Usage: NIO_BUILD_ROOT=$HOME/nio-build ./build.sh
set -euo pipefail

ROOT="${NIO_BUILD_ROOT:-$HOME/nio-build}"
cd "$ROOT"

export KBUILD_BUILD_USER="${KBUILD_BUILD_USER:-builder}"
export KBUILD_BUILD_HOST="${KBUILD_BUILD_HOST:-debian-vm}"
export PATH="$ROOT/clang/bin:$PATH"

GCC64="$ROOT/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
GCC32="$ROOT/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-"

args=(
  ARCH=arm64
  O=../out
  CC=clang
  CLANG_TRIPLE=aarch64-linux-gnu-
  CROSS_COMPILE="$GCC64"
  CROSS_COMPILE_ARM32="$GCC32"
)

cd "$ROOT/kernel-source"
cp "$ROOT/droidspaces.config" arch/arm64/configs/droidspaces.config
rm -rf ../out

echo "=== clang version ==="
clang -v || true

echo "=== configure ==="
make "${args[@]}" nio_defconfig droidspaces.config

echo "=== verify resolved config ==="
cfg=../out/.config
fail=0
for sym in USER_NS CGROUPS CGROUP_SCHED FAIR_GROUP_SCHED CFS_BANDWIDTH MACVLAN \
           NETFILTER_ADVANCED NF_CONNTRACK NF_NAT NF_NAT_IPV6 IP6_NF_NAT \
           IP6_NF_TARGET_MASQUERADE NF_TABLES NF_TABLES_IPV6 NFT_MASQ \
           NFT_CHAIN_NAT_IPV6 NFT_MASQ_IPV6 IPV6; do
  line=$(grep -E "^(CONFIG_${sym}=|# CONFIG_${sym} is not set)" "$cfg" || true)
  if echo "$line" | grep -q "=y"; then
    echo "[OK]   $line"
  else
    echo "[MISS] CONFIG_${sym} -> ${line:-not present}"
    fail=1
  fi
done
if [ "$fail" -ne 0 ]; then
  echo "ERROR: required config symbols missing; aborting before build."
  exit 1
fi

echo "=== build ==="
make -j"$(nproc)" "${args[@]}"

echo "=== output ==="
ls -l ../out/arch/arm64/boot/ | sed -n '1,40p'
if [ -f ../out/arch/arm64/boot/Image ]; then
  cp ../out/arch/arm64/boot/Image "$ROOT/Image.new"
  sha256sum "$ROOT/Image.new"
fi
echo "=== BUILD_DONE ==="
