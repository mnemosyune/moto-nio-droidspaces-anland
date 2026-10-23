#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
UNIT=/etc/systemd/system/droidspaces-ipv6.service
$DS --name=kde run -- rm -f "$UNIT"
$DS --name=kde run -- /bin/bash -c 'printf "%s\n" "[Unit]" "Description=Droidspaces IPv6 NAT66 address" "After=network.target" "Wants=network.target" "" "[Service]" "Type=oneshot" "ExecStart=-/usr/sbin/ip -6 addr add fd64:7370::2/64 dev eth0" "ExecStart=-/usr/sbin/ip -6 route add default via fd64:7370::1 dev eth0" "RemainAfterExit=yes" "" "[Install]" "WantedBy=multi-user.target" > /etc/systemd/system/droidspaces-ipv6.service'
$DS --name=kde run -- systemctl daemon-reload
$DS --name=kde run -- systemctl enable --now droidspaces-ipv6.service
echo "=== status ==="
$DS --name=kde run -- systemctl status droidspaces-ipv6.service --no-pager
echo "=== file ==="
$DS --name=kde run -- cat /etc/systemd/system/droidspaces-ipv6.service
