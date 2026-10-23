#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
echo "=== container ipv6 ==="
$DS --name=kde run -- /bin/bash -c 'ip -6 addr show; echo ---ROUTE---; ip -6 route; echo ---DNS---; cat /etc/resolv.conf; echo ---AAAA---; getent ahosts ipv6.google.com | head -n 4; echo ---CURL6---; curl -6 -sS -o /dev/null -w "%{http_code}\n" --max-time 15 https://www.cloudflare.com; echo ---PING6---; ping -6 -c 2 -W 3 2400:3200::1'
echo "=== host ==="
sysctl -n net.ipv6.conf.all.forwarding
ip6tables -t nat -S 2>/dev/null | grep -i -E 'masq|dnat' | head -n 10
