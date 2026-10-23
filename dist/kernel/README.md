# 内核产物

本目录是本项目在 2026-10-21 为 Motorola nio 编译的内核，以及可直接用
AnyKernel3 兼容刷机工具刷入的 zip。`Image` 本身已在设备上启动验证；
AnyKernel3 zip 是用同一个 `Image` 和原先已验证的模板重新打包的。

> 仅适用于 Motorola Edge S / Moto G100（`nio`，sm8250，Android 12）。
> 不要刷到其他机型。刷机前请备份当前 `boot_a`，并确保已经用 Magisk
> 修补过原厂 boot、能正常开机。

## 文件

| 文件 | 大小 | SHA256 |
|---|---:|---|
| `Image-4.19.157-nio-droidspaces-20261021` | 46,413,840 B | `f861f31bc58df083ed64f2d6f3cf34f3b288b9e8c80d7907372b6facf7142611` |
| `AnyKernel3_droidspaces_nio_20261021.zip` | 21,604,769 B | `90dd93527bbbcb53037511087b8cad0549458b66f1d7b7ff001cde4374b2d899` |
| `config-4.19.157-nio-droidspaces-20261021` | 171,499 B | `12dcccfb9354540146e9e4522a661f4b0f412fb41ccd7083a2609c864cadc05b` |
| `LICENSE-GPL-2.0` | 18,729 B | `f6b78c087c3ebdf0f3c13415070dd480a3f35d8fc76f3d02180a407c1c812f79` |

`SHA256SUMS` 可供下载后校验：

```bash
sha256sum -c SHA256SUMS
```

## 推荐刷入方式

### AnyKernel3 zip

1. 确认手机当前是 Magisk root，且 `boot_a` 是可开机的 Magisk boot。
2. 用支持 AnyKernel3 的 kernel flasher 刷入
   `AnyKernel3_droidspaces_nio_20261021.zip`。
3. 重启后检查：

```bash
su -c "uname -a"
su -c "sh /data/local/tmp/moto-nio/check_droidspaces.sh"
```

AnyKernel3 只替换 boot 里的内核，保留当前 Magisk ramdisk，因此不会破坏 root。
这个 zip 的设备检查为 `nio`，`do.devicecheck=1`。

### 原始 Image

如果只想自己重打包：

```bash
# 设备端，已有 Magisk
su -c "sh /data/local/tmp/moto-nio/prepare_new_boot.sh"
```

先把本目录的 `Image-...` 放到设备 `/data/local/tmp/Image.new`，再运行上面的
脚本；它会用当前 `boot_a` 解包、替换 `kernel`、重新打包并输出哈希。

## 校验与回滚

- 内核配置可用 `config-4.19.157-nio-droidspaces-20261021` 对照；
  `build/kernel/droidspaces.config` 是构建时合并的片段。
- 刷入前把当前 boot 备份到电脑，例如：
  `adb shell su -c "dd if=/dev/block/by-name/boot_a of=/data/local/tmp/boot_backup.img"`
- 如果新内核无法开机，用 `fastboot flash boot_a boot_backup.img` 回滚。
- 本目录不包含带 Magisk ramdisk 的 `boot.img`；AnyKernel3 会复用你手机
  当前的 ramdisk。

## 许可与来源

- 内核基于 [Aessd/kernel_motorola_sm8250](https://github.com/Aessd/kernel_motorola_sm8250)
  的 `erofs` 分支，Linux 内核为 GPL-2.0；本目录附有 `LICENSE-GPL-2.0`。
- 本次只合入 `build/kernel/droidspaces.config` 并运行 `olddefconfig`，没有修改
  内核源码；对应源码可从上述 `erofs` 分支获取，实际 `.config` 见本目录。
- AnyKernel3 模板来自 [osm0sis/AnyKernel3](https://github.com/osm0sis/AnyKernel3)，
  其许可证见上游。
- 工具链与配置来源见仓库根目录 `CREDITS.md` 和 `build/kernel/`。
