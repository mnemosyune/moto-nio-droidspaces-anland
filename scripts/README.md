# 脚本索引

所有 Android 侧脚本都是 `#!/system/bin/sh`，可以在 Termux 里用 `su -c` 直接执行，
也可以由 `termux/install.sh` 复制到 `/data/local/tmp/moto-nio/`。

## host/ — Android 宿主侧

| 脚本 | 用途 |
|---|---|
| `anland_external.sh` | 一键外接屏直出：找 HDMI display id → 启动容器 → 等 broker socket → 禁用 Ready For → 在外接屏启动 Anland |
| `anland_launch.sh` | 在指定 display 启动 Anland（默认 0，手机内屏） |
| `desk_off.sh` | 禁用 `mobiledesktop` / `.core` / `systemui.desk` |
| `desk_on.sh` | 恢复上述三个 Ready For 包（Hail 冻结的需另在 Hail 解冻） |
| `anland_bt_input_setup.sh` | 写入 Anland 指针捕获/按键拦截偏好，并启用无障碍 KeyInterceptor |
| `check_bt_input.sh` | 检查 Anland 输入偏好、无障碍服务、Android 输入设备和外接屏 |
| `check_readyfor.sh` | 检查 Ready For 包状态、SecondaryDisplayLauncher、相关进程 |
| `status_now.sh` | 汇总容器、Plasma、KWin、Anland、desk 状态 |
| `measure_host_cpu.sh` | 10 秒采样 KWin / SurfaceFlinger / SystemUI / Anland 的单核 CPU |
| `display_list.sh` | 列出 Android display id、分辨率和 DRM connector 状态 |
| `probe_display.sh` | 显示能力、Ready For 包、内存、USB/DRM 探测 |
| `input_list.sh` | 列出 `getevent` 输入设备与能力 |
| `disable_kde_lock.sh` | 关闭容器内 KDE 自动锁屏 |
| `disable_kde_power_save.sh` | 关闭容器内 AC 息屏/挂起 |
| `restart_test.sh` | stop/start 容器并检查桌面进程 |
| `check_droidspaces.sh` | Droidspaces 版本、requirements、daemon 和日志 |
| `kde_status.sh` | 容器内 Plasma/KWin 进程与 journal |
| `gpu_check.sh` | KWin 输出与 GPU/EGL 日志 |
| `container_env.sh` | 容器环境变量、socket、KWin 命令行 |
| `test_kill_readyfor_systemui.sh` | 诊断：杀掉 `systemui_readyfor1` 观察是否重生；结论是会自动重生，不建议日常使用 |

## container/ — 容器内诊断

这些脚本在容器内运行，使用 `XDG_RUNTIME_DIR=/run/user/1000` 和会话 D-Bus。
可以从 Termux 通过 SSH 运行：

```bash
scp scripts/container/diag_kwin.sh Gold@<手机IP>:/tmp/
ssh Gold@<手机IP> 'bash /tmp/diag_kwin.sh'
```

或者把脚本内容通过 stdin 交给 Droidspaces：

```bash
su -c "/data/local/Droidspaces/bin/droidspaces --name=kde --stdin run bash -s < $PWD/scripts/container/diag_kwin.sh"
```

| 脚本 | 用途 |
|---|---|
| `diag_kwin.sh` | KWin CPU、线程、OpenGL、输出、effects、日志 |
| `diag_kwin2.sh` | kscreen 输出、KWin screens/compositing、线程、环境 |
| `test_kwin_effects2.sh` | 对比卸载 blur/contrast 前后的 CPU |
| `test_kwin_idle.sh` | showDesktop 前后 CPU，判断是否持续重绘 |

## build/kernel/ — Debian VM 内构建

| 脚本 | 用途 |
|---|---|
| `clone.sh` | 克隆 Snapdragon-LLVM、LineageOS GCC、内核源码 |
| `clone2.sh` | 用 tarball 下载，支持 `GH_PROXY` |
| `build.sh` | 合并 `droidspaces.config` 并编译 `Image` |
| `verify_custom_kernel.sh` | 设备端核对 `/proc/config.gz`、模块、WiFi、显示 |
| `prepare_new_boot.sh` | 设备端用 Magisk `magiskboot` 替换内核并重打包 |

## archive/nat-mode/ — 历史 NAT 配置

这些脚本只适用于 Droidspaces 的 **NAT** 网络模式，当前容器已改为 host 模式，
不要在 host 模式下照抄。保留它们是为了复现旧配置或切回 NAT 时参考。
