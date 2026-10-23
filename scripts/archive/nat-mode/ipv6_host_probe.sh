#!/system/bin/sh
echo "=== host ipv6 addrs ==="
ip -6 addr show | grep -E '^[0-9]+:|inet6'
echo "=== host ipv6 routes ==="
ip -6 route
echo "=== host links ==="
ip -br link | grep -E 'ds-|veth|wlan0'
echo "=== ip6tables nat ==="
ip6tables -t nat -S
echo "=== ip6tables filter ==="
ip6tables -S | head -n 30
