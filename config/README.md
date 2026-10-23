# 配置示例

## `container.config.host.example`

复制到 `/data/local/Droidspaces/Containers/kde/container.config`。
这是当前验证过的 **host 网络模式** 配置骨架：

- `net_mode=host`：容器共享手机 `wlan0`
- `disable_ipv6=0`
- `enable_gpu_mode=1`：KWin 使用 freedreno/kgsl
- `enable_hw_access=0`：不暴露 `/dev/input`；键鼠由 Anland 转发
- `run_at_boot=0`：不自动启动

Droidspaces 会在首次创建容器时生成 `uuid`；不要照抄其他设备的 `uuid`。

## `anland_settings.xml`

Anland 5.23 的输入偏好：

- `pointer_capture=true`
- `accessibility_key_intercept=true`
- `extra_keys_mode=with_keyboard`

设备路径：

```text
/data/data/com.anland.consumer/shared_prefs/anland_settings.xml
```

不要直接覆盖正在运行的 Anland 配置；用
`scripts/host/anland_bt_input_setup.sh` 会先备份再写入，并启用无障碍服务。
