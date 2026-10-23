#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
$DS --name=kde run -- /bin/bash -c 'printf "%s\n" "[Match]" "Name=eth*" "" "[Network]" "DHCP=yes" "IPv6AcceptRA=yes" "Address=fd64:7370::2/64" "Gateway=fd64:7370::1" "" "[DHCPv4]" "UseDNS=yes" "UseDomains=yes" "RouteMetric=100" > /etc/systemd/network/10-eth-dhcp.network'
$DS --name=kde run -- systemctl disable --now droidspaces-ipv6.service 2>&1
$DS --name=kde run -- rm -f /etc/systemd/system/droidspaces-ipv6.service /etc/systemd/system/multi-user.target.wants/droidspaces-ipv6.service
$DS --name=kde run -- systemctl daemon-reload
$DS --name=kde run -- systemctl restart systemd-networkd
sleep 4
echo "=== networkd file ==="
$DS --name=kde run -- cat /etc/systemd/network/10-eth-dhcp.network
echo "=== verify ==="
$DS --name=kde run -- /bin/bash -c 'ip -6 addr show eth0; echo ---; ip -6 route; echo ---; curl -6 -sS -o /dev/null -w "%{http_code}\n" --max-time 15 https://www.cloudflare.com'
