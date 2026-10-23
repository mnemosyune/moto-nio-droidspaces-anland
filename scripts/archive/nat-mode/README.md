# 历史：NAT 模式 IPv6 配置

当前容器使用 **host 网络模式**，容器与 Android 宿主共享 `wlan0`，没有 `eth0`，
也没有 NAT66/MASQUERADE。以下脚本只适用于旧的 NAT 模式（`net_mode=nat`）：

- `configure_container_ipv6.sh`：写入 `10-eth-dhcp.network` 静态 ULA `fd64:7370::2/64`
- `install_ipv6_service.sh`：安装 `droidspaces-ipv6.service`（旧方案）
- `ipv6_container_test.sh`：容器内 IPv6 地址/路由/DNS/curl 测试
- `ipv6_host_probe.sh`：宿主侧 IPv6 地址、路由、ip6tables 探测
- `container_networkd.sh`：查看 networkd 配置
- `inspect_ipv6_unit.sh`：查看旧 unit 文件
- `droidspaces-ipv6.service`：旧 unit 的原文

host 模式下不要运行这些脚本；它们会尝试在容器内找 `eth0`，并可能写入无效配置。
如需切回 NAT 模式，先在 Droidspaces 里把 `net_mode` 改为 `nat`，再按旧 ULA 方案
调整前缀/网关，并重新验证 `ip6tables -t nat -S`。
