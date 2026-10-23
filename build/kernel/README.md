# 内核构建（Motorola nio / sm8250 / Linux 4.19）

> 这是本人设备上的可复现记录，不是通用内核。刷错 boot 分区可能导致无法开机；
> 请先备份当前 `boot_a`，并准备好 `fastboot` 救砖手段。

## 已验证版本

- 设备：Motorola Edge S / Moto G100，代号 `nio`，SoC `sm8250`
- 系统：Android 12（RETEU）
- 内核：`4.19.157-perf`，`KBUILD_BUILD_USER=hiahia`，`KBUILD_BUILD_HOST=debian-vm`
- 构建日期：2026-10-21
- 内核源码：[Aessd/kernel_motorola_sm8250](https://github.com/Aessd/kernel_motorola_sm8250)，分支 `erofs`
- 配置：`nio_defconfig` + 本目录的 `droidspaces.config`
- 工具链：
  - [Snapdragon-LLVM](https://github.com/xiangfeidexiaohuo/Snapdragon-LLVM) clang 10.0.9
  - [LineageOS aarch64 GCC 4.9](https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9)
  - [LineageOS arm GCC 4.9](https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9)
- 刷机包：AnyKernel3（[osm0sis/AnyKernel3](https://github.com/osm0sis/AnyKernel3)）

## 预编译产物

本次构建的产物已经放在 [`dist/kernel/`](../../dist/kernel/)：

- `Image-4.19.157-nio-droidspaces-20261021`
- `AnyKernel3_droidspaces_nio_20261021.zip`
- `config-4.19.157-nio-droidspaces-20261021`
- `SHA256SUMS`

`Image` 已在设备上启动验证；AnyKernel3 zip 用同一个 `Image` 和原先已验证的
模板重新打包，hash 见 `dist/kernel/README.md`。

## 构建

在 Debian 13 x86_64 虚拟机中执行（7.7 GB 内存 / 4 vCPU 足够）：

```bash
mkdir -p ~/nio-build
cd ~/nio-build

# 1. 工具链与内核源码
bash /path/to/repo/build/kernel/clone.sh
# 如果 git clone 很慢，可用 clone2.sh 下载 tarball：
# GH_PROXY=https://gh-proxy.com/ bash /path/to/repo/build/kernel/clone2.sh

# 2. 放入配置片段
cp /path/to/repo/build/kernel/droidspaces.config ~/nio-build/droidspaces.config

# 3. 编译
bash /path/to/repo/build/kernel/build.sh
```

成功后会得到：

```text
~/nio-build/out/arch/arm64/boot/Image
~/nio-build/Image.new
```

`droidspaces.config` 是由上游配置指南整理的片段；4.19 上不存在的符号会被
`olddefconfig` 丢弃，不会报错。`resolved-config-diff.txt` 记录了本次构建相对
旧配置实际多出来的符号。

## 刷入

如果使用 `dist/kernel/AnyKernel3_droidspaces_nio_20261021.zip`，直接用支持
AnyKernel3 的 kernel flasher 刷入即可；它会保留当前 Magisk ramdisk。下面是从
源码重新打包的流程。

先确认当前 slot：

```bash
su -c "getprop ro.boot.slot_suffix"
```

推荐流程：

1. 从当前已 Magisk 修补的 `boot_a` 解包（`prepare_new_boot.sh`）；
2. 用新 `Image` 替换内核并重新打包；
3. `fastboot boot new_boot.img` 临时验证；
4. 开机、WiFi、触控、Magisk、Droidspaces 检查都正常后，再
   `fastboot flash boot_a new_boot.img` 永久写入。

`prepare_new_boot.sh` 是设备端脚本，默认要求：

- Magisk 安装在 `/data/adb/magisk`
- 新内核已放到 `/data/local/tmp/Image.new`
- 设备已 root

> 本仓库不包含带 Magisk ramdisk 的 `boot.img`；内核 Image 和 AnyKernel3 zip
> 在 `dist/kernel/`。不要把他人设备的 boot 镜像直接刷到自己的机器上。

## 参考

- Droidspaces 内核配置指南：<https://github.com/MGHazz/Droidspaces/blob/main/Documentation/Kernel-Configuration.md>
- AnyKernel3：<https://github.com/osm0sis/AnyKernel3>
- Magisk：<https://github.com/topjohnwu/Magisk>
