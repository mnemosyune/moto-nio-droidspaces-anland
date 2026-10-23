# moto-nio-droidspaces-anland

在 **Motorola Edge S / Moto G100（代号 `nio`，sm8250，Android 12）** 上，
用 **Droidspaces** 运行 **Debian 13 + KDE Plasma Wayland**，再通过
**Anland** 把桌面输出到手机内屏或 USB-C / HDMI 外接显示器。

![KDE on external display](screenshots/external-display.png)

> 这是一个已经跑通的个人设备配置记录，不是通用 ROM 或一键安装包。
> 需要解锁 bootloader、Magisk root、自定义内核和 Droidspaces 容器。
> 刷机有风险，请先备份 `boot_a` 和重要数据。

## 当前状态

- [x] 自定义 4.19 内核，已开启 Droidspaces 所需的 namespace、cgroup、macvlan、IPv6 NAT 等选项
- [x] 编译好的内核 `Image`、AnyKernel3 zip 和 resolved config 已放在 `dist/kernel/`
- [x] Debian 13 (trixie) + systemd 容器 `kde`
- [x] KDE Plasma Wayland（KWin）在 Anland 中显示，手机触摸可用
- [x] 外接 1920x1080@60 显示器直出，绕过 Moto Ready For
- [x] KWin 使用 freedreno / Adreno 650 OpenGL，非软件渲染
- [x] 容器改为 **host 网络模式**，直接共享手机 `wlan0`，IPv4/IPv6 正常
- [x] Anland 外部指针捕获与键盘拦截已预配置
- [ ] 蓝牙键鼠尚未配对实测
- [ ] 未做“插屏自动拉起”，目前手动运行脚本

## 它怎么工作

```text
Android 12 (nio)
├─ Magisk root
├─ Droidspaces 7.0.0
│   └─ 容器 kde
│       ├─ Debian 13 + systemd
│       └─ KDE Plasma Wayland (KWin)
│            └─ kwin_backend_anland  ← 渲染到共享 dmabuf
└─ Anland consumer (com.anland.consumer)
     └─ 把 dmabuf 显示到手机内屏 / USB-C 外接屏
```

外接屏直出的关键不是“启动 Anland”本身，而是先让 Moto Ready For 让出屏幕：

- `com.motorola.mobiledesktop`
- `com.motorola.mobiledesktop.core`
- `com.motorola.systemui.desk`

`scripts/host/anland_external.sh` 会检测 HDMI display id、启动容器、等待
Anland broker socket，然后禁用上述三个包并在外接屏启动 Anland。

## 下载

### 内核（本仓库，2026-10-21 构建）

- [Image-4.19.157-nio-droidspaces-20261021](dist/kernel/Image-4.19.157-nio-droidspaces-20261021)
  — 46,413,840 B，SHA256 `f861f31bc58df083ed64f2d6f3cf34f3b288b9e8c80d7907372b6facf7142611`
- [AnyKernel3_droidspaces_nio_20261021.zip](dist/kernel/AnyKernel3_droidspaces_nio_20261021.zip)
  — 21,604,769 B，SHA256 `90dd93527bbbcb53037511087b8cad0549458b66f1d7b7ff001cde4374b2d899`
- [config-4.19.157-nio-droidspaces-20261021](dist/kernel/config-4.19.157-nio-droidspaces-20261021)
  — 171,499 B，SHA256 `12dcccfb9354540146e9e4522a661f4b0f412fb41ccd7083a2609c864cadc05b`
- [SHA256SUMS](dist/kernel/SHA256SUMS)

完整哈希、刷入方式和回滚说明见 **[dist/kernel/README.md](dist/kernel/README.md)**。
`Image` 已在设备上启动验证；AnyKernel3 zip 是用同一个 `Image` 和原先已验证的
模板重新打包的，刷入时会复用当前 Magisk ramdisk。

### KDE 容器镜像（上游 GitHub Release）

本项目实际使用的镜像：

**[Debian-13-kde-Wayland-Droidspaces-rootfs-aarch64-v20261018-063357-zh.tar.xz](https://github.com/Goldzxcbug/Droidspaces-rootfs-Desktop-builder/releases/download/droidspaces-rootfs-all-wayland/Debian-13-kde-Wayland-Droidspaces-rootfs-aarch64-v20261018-063357-zh.tar.xz)**

- 大小：`821,946,744` B（约 784 MiB）
- SHA256：`6b92745d6f55c0b8d635046d876a33e4da59f2c70423dc2c5db845be3dd81f19`
- 上游发布页：<https://github.com/Goldzxcbug/Droidspaces-rootfs-Desktop-builder/releases/tag/droidspaces-rootfs-all-wayland>
- 对应本地文件名：`debian13-kde-anland-zh.tar.xz`（大小和 SHA256 与上游资产一致）

这是 Debian 13 + KDE Plasma Wayland + 中文 + Anland 后端的 aarch64 rootfs。
822 MB 的镜像不放进本仓库；下载后按 Droidspaces 的导入流程使用，并先核对
SHA256。镜像由 [Goldzxcbug/Droidspaces-rootfs-Desktop-builder](https://github.com/Goldzxcbug/Droidspaces-rootfs-Desktop-builder)
构建，不是本仓库的原创产物。如果上游资产被移除，可在该 builder 选择
Debian 13 + KDE + Wayland/Anland + zh 重新构建。

## 前置条件

| 组件 | 说明 |
|---|---|
| 设备 | Motorola Edge S / G100，`nio`，sm8250 |
| 系统 | Android 12（本项目在 RETEU 上验证） |
| root | Magisk 30.6（其他版本理论可用） |
| 内核 | 4.19，开启 Droidspaces 所需配置；见 `dist/kernel/` 与 `build/kernel/` |
| 容器镜像 | Debian 13 KDE Wayland zh，约 822 MB；见上方下载链接 |
| Droidspaces | 7.0.0 |
| Anland | 5.23，包名 `com.anland.consumer`（**不是** `com.anland.termux`） |
| Termux | 用于在手机上执行日常脚本 |

容器配置示例在 `config/container.config.host.example`。`run_at_boot=0`，
桌面由用户手动启动。

## 快速开始（Termux）

在 Termux 中：

```bash
pkg install git
git clone https://github.com/mnemosyune/moto-nio-droidspaces-anland.git
cd moto-nio-droidspaces-anland

# 可选：把 Android 侧脚本复制到 /data/local/tmp/moto-nio
bash termux/install.sh

# 查看当前状态
su -c "sh /data/local/tmp/moto-nio/status_now.sh"

# 外接屏直出（先接好显示器）
su -c "sh /data/local/tmp/moto-nio/anland_external.sh"

# 回到手机内屏
su -c "sh /data/local/tmp/moto-nio/anland_launch.sh 0"

# 恢复 Ready For，然后重新插拔显示器
su -c "sh /data/local/tmp/moto-nio/desk_on.sh"
```

不安装到 `/data/local/tmp` 也可以直接从仓库运行：

```bash
su -c "sh $PWD/scripts/host/status_now.sh"
su -c "sh $PWD/scripts/host/anland_external.sh"
```

`termux/install.sh` 只复制脚本，不会修改系统；`anland_external.sh` 会
`pm disable-user` 三个 Ready For 包，`desk_on.sh` 可以恢复。

## 常用操作

```bash
# 容器状态 / 启停
su -c "/data/local/Droidspaces/bin/droidspaces show"
su -c "/data/local/Droidspaces/bin/droidspaces start --name=kde"
su -c "/data/local/Droidspaces/bin/droidspaces stop --name=kde"

# 容器内桌面服务
su -c "/data/local/Droidspaces/bin/droidspaces --name=kde run -- systemctl status desktop-session --no-pager"

# 检查 Droidspaces 内核要求
su -c "sh /data/local/tmp/moto-nio/check_droidspaces.sh"

# 检查 Ready For / 外接屏 / 键鼠
su -c "sh /data/local/tmp/moto-nio/check_readyfor.sh"
su -c "sh /data/local/tmp/moto-nio/check_bt_input.sh"

# 测量外接屏 CPU 占用
su -c "sh /data/local/tmp/moto-nio/measure_host_cpu.sh"
```

详细的部署、内核构建、网络、输入和故障排查见
**[NOTES.zh-CN.md](NOTES.zh-CN.md)**。

## 两个容易误解的点

### 1. 外接屏“有桌面没任务栏”不是 Ready For 残留

它是 Moto 启动器的副屏 Activity：

```text
com.motorola.launcher3/com.android.launcher3.secondarydisplay.SecondaryDisplayLauncher
```

类别是 `SECONDARY_HOME`，属于 `com.motorola.launcher3`，不是 Ready For。
三个 Ready For 包禁用后，外接屏在 Anland 启动前仍可能先显示它。

只想消掉插屏时这一下 Launcher，可以只禁用这个 Activity（不影响手机主屏）：

```bash
su -c "pm disable-user --user 0 com.motorola.launcher3/com.android.launcher3.secondarydisplay.SecondaryDisplayLauncher"
# 恢复：
su -c "pm enable com.motorola.launcher3/com.android.launcher3.secondarydisplay.SecondaryDisplayLauncher"
```

### 2. KWin 持续占 25% 单核是 Anland 后端的正常行为

在 1920x1080@60、Anland 独占外接屏时实测：

| 进程 | 单核占用 |
|---|---:|
| `kwin_wayland` | 25% |
| `surfaceflinger` | 20% |
| `com.android.systemui` | 13% |
| `systemui_readyfor1` | 6% |
| `com.anland.consumer` | 6% |
| 整机总 CPU | 16%（8 核） |

Anland 的 KWin 后端在
[`anland_output.cpp`](https://github.com/superturtlee/anland/blob/legacy/producers/kde/anland_backend/src/backends/anland/anland_output.cpp)
里，每收到一个 `PRESENTED` 事件就调用 `m_renderLoop->scheduleRepaint()`，
按 consumer 的节奏连续合成；这不是泄漏。1080p60 下约 25% 单核，换算到
8 核整机约 3%。

如果想让 KWin 降负载，最实际的是在 Anland 设置 → Display Resolution 里
选 `720p` 或 `Screen × 0.75`，然后重新连接；不要期待 blur/特效开关能解决。
`systemui_readyfor1` 是 `com.android.systemui` 的副屏进程，杀掉会自动重生，
不能像普通包一样冻结。

## 仓库结构

```text
.
├── README.md
├── NOTES.zh-CN.md          # 完整部署记录 / 故障排查
├── CREDITS.md              # 第三方组件与版权
├── LICENSE                 # MIT（仅本仓库原创部分）
├── config/
│   ├── container.config.host.example
│   └── anland_settings.xml
├── scripts/
│   ├── host/               # Android 宿主侧脚本（Termux + su）
│   ├── container/          # 容器内 KWin 诊断
│   ├── archive/nat-mode/   # 旧 NAT 网络配置，仅历史参考
│   └── README.md
├── build/kernel/           # 内核配置与构建脚本（Debian VM）
├── dist/kernel/            # 编译好的 Image / AnyKernel3 / config / 哈希
├── termux/install.sh       # 把脚本复制到 /data/local/tmp
└── screenshots/
```

## 安全与限制

- **不要**把 `boot.img`、rootfs、APK 或任何设备备份提交到仓库；内核 `Image`
  只放在 `dist/kernel/`，并明确标注为设备专用产物。
- 本仓库不包含密码、设备序列号或 822 MB 容器镜像；rootfs 只提供上游链接。
  容器密码请自行设置。
- host 模式下容器 SSH 22 会暴露在 LAN 上；如果启用，建议改用密钥登录，
  或限制来源地址。
- 旧 NAT 模式的 IPv6 静态 ULA 配置已归档在 `scripts/archive/nat-mode/`，
  当前 host 模式不要照抄。
- Anland 5.x 与 6.x 的 consumer 不兼容；本项目使用的是 5.23。

## 第三方与许可

本项目使用了 Droidspaces、Anland、Debian、KDE、Mesa、Linux kernel、
AnyKernel3、Magisk、Snapdragon-LLVM、LineageOS GCC、Termux，以及
Goldzxcbug 的 Droidspaces rootfs builder 等上游项目。
完整列表、链接和许可证见 **[CREDITS.md](CREDITS.md)**。

本仓库原创的脚本、文档和配置示例采用 MIT License；第三方内容仍归原作者，
遵循各自许可证。`dist/kernel/` 的内核/AnyKernel3 二进制按 GPL-2.0 或上游
许可证分发。Motorola、Ready For 等商标归其权利人所有，本项目与
Motorola 无隶属关系。
