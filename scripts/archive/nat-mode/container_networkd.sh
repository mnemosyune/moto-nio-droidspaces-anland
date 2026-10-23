#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
echo "=== /etc/systemd/network ==="
$DS --name=kde run -- ls -la /etc/systemd/network/
echo "=== /run/systemd/network ==="
$DS --name=kde run -- ls -la /run/systemd/network/
echo "=== contents ==="
$DS --name=kde run -- /bin/bash -c 'for f in /etc/systemd/network/* /run/systemd/network/*; do [ -f "$f" ] && { echo "--- $f"; cat "$f"; }; done'
echo "=== networkctl ==="
$DS --name=kde run -- networkctl status eth0 --no-pager
