# 第三方组件与版权说明

本项目不是从零实现的 Linux 桌面栈。下面列出实际使用/参考的第三方项目；
版权归各原作者，遵循各自上游许可证。除 `dist/kernel/` 中明确标注的内核
Image/AnyKernel3 产物外，**本仓库不包含这些项目的源码或二进制**。

## 运行时与桌面

| 项目 | 在本项目中的用途 | 上游 | 许可证 |
|---|---|---|---|
| **Droidspaces** 7.0.0 | Android 上的 Linux 容器运行时；提供 `droidspaces` CLI、容器配置、GPU/Anland 集成 | <https://github.com/MGHazz/Droidspaces> · <https://www.droidspaces.org/> | GPL-3.0 |
| **Anland** 5.23 | Wayland 桌面输出到 Android Surface；消费端 `com.anland.consumer`，KWin producer 后端 | <https://github.com/superturtlee/anland> | GPL-3.0 |
| **Debian GNU/Linux 13 (trixie)** | 容器 rootfs 发行版 | <https://www.debian.org/> | 多种自由软件许可证 |
| **Droidspaces RootFS Desktop builder (Goldzxcbug)** | 本项目实际使用的 `Debian-13-kde-Wayland-...-zh.tar.xz` rootfs | <https://github.com/Goldzxcbug/Droidspaces-rootfs-Desktop-builder> · [发布页](https://github.com/Goldzxcbug/Droidspaces-rootfs-Desktop-builder/releases/tag/droidspaces-rootfs-all-wayland) | 构建器 MIT；rootfs 内各软件包按各自许可证 |
| **KDE Plasma / KWin** | Wayland 桌面与合成器；使用 `kwin_backend_anland` | <https://kde.org/> · <https://invent.kde.org/plasma/kwin> | GPL/LGPL（以上游为准） |
| **Mesa / freedreno** | Adreno 650 的 OpenGL/EGL 用户态驱动 | <https://www.mesa3d.org/> · <https://gitlab.freedesktop.org/mesa/mesa> | MIT（主要） |
| **Fcitx5** | 容器内中文输入法 | <https://fcitx-im.org/> | LGPL-2.1+ |

> Anland 5.x 的 Android 消费端包名是 `com.anland.consumer`，不是
> `com.anland.termux`。后者是 Anland 的 Termux 版本，Droidspaces 不使用它。

本项目实际使用的 rootfs 资产：

- 文件名：`Debian-13-kde-Wayland-Droidspaces-rootfs-aarch64-v20261018-063357-zh.tar.xz`
- 大小：`821,946,744` B
- SHA256：`6b92745d6f55c0b8d635046d876a33e4da59f2c70423dc2c5db845be3dd81f19`
- 发布页：
  <https://github.com/Goldzxcbug/Droidspaces-rootfs-Desktop-builder/releases/tag/droidspaces-rootfs-all-wayland>

## Android / 内核 / 刷机

| 项目 | 用途 | 上游 | 许可证 |
|---|---|---|---|
| **Linux kernel 4.19 / Motorola nio 内核源** | 自定义内核基础 | <https://github.com/Aessd/kernel_motorola_sm8250>（分支 `erofs`） | GPL-2.0 |
| **Droidspaces 内核配置指南** | `build/kernel/droidspaces.config` 的配置项来源 | <https://github.com/MGHazz/Droidspaces/blob/main/Documentation/Kernel-Configuration.md> | GPL-3.0 |
| **Snapdragon-LLVM** | clang 10.0.9 工具链 | <https://github.com/xiangfeidexiaohuo/Snapdragon-LLVM> | 见上游（LLVM/Clang 许可证） |
| **LineageOS GCC 4.9 prebuilts** | aarch64 / arm 交叉编译器 | <https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9> · <https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9> | GPL（以上游为准） |
| **AnyKernel3** | 内核 zip 打包/刷入脚本 | <https://github.com/osm0sis/AnyKernel3> | 见上游 |
| **Magisk** | root 与 `magiskboot` | <https://github.com/topjohnwu/Magisk> | GPL-3.0 |
| **Termux** | Android 终端，用于日常运行脚本 | <https://termux.dev/> · <https://github.com/termux/termux-app> | GPL-3.0（以上游为准） |

## 文档与协议

- Anland 的协议、KWin 后端和设置说明来自
  <https://github.com/superturtlee/anland>（`doc/`、`producers/kde/`）。
  本仓库的 KWin CPU 结论引用了 `anland_output.cpp` 中
  `onConsumerReady()` / `onFramePresented()` 每帧 `scheduleRepaint()` 的实现逻辑。
- Droidspaces 的 CLI、网络模式和内核要求来自
  <https://github.com/MGHazz/Droidspaces> 及其文档。

## 本仓库中的二进制产物

`dist/kernel/` 包含：

- `Image-4.19.157-nio-droidspaces-20261021`：基于 Linux 4.19 的内核镜像，
  按 **GPL-2.0** 分发；
- `AnyKernel3_droidspaces_nio_20261021.zip`：上述内核 + AnyKernel3 模板，
  按 GPL-2.0/上游许可证分发；
- `config-...`、`SHA256SUMS`：配置与校验文件；
- `LICENSE-GPL-2.0`：Linux 内核的 GPL-2.0 许可证全文。

这些二进制不属于本仓库的 MIT 许可范围；MIT 仅覆盖作者编写的脚本、文档和
配置示例。`Image` 已在设备上启动验证；AnyKernel3 zip 由同一 Image 重打包，
zip 外壳未再次实机刷入。

## 商标

Motorola、Moto Edge S、Moto G100、Ready For 是 Motorola Trademark Holdings, LLC
或其关联公司的商标。本项目与 Motorola 没有任何隶属或背书关系。

## 本仓库的许可

本仓库中由作者编写的脚本、文档和配置示例采用 **MIT License**（见 `LICENSE`）。
第三方项目、上游配置片段、商标、rootfs 和截图中的第三方界面仍归各自权利人
所有；`dist/kernel/` 的二进制按 GPL-2.0/上游许可证分发。如果某个文件包含
第三方内容，以该第三方许可证为准。
