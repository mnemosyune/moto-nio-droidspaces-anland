#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
$DS --name=kde run -- ls -l /etc/systemd/system/droidspaces-ipv6.service
$DS --name=kde run -- readlink -f /etc/systemd/system/droidspaces-ipv6.service
$DS --name=kde run -- head -n 3 /etc/systemd/system/droidspaces-ipv6.service
