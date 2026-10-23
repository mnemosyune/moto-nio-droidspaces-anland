#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
echo "=== stop ==="
$DS stop --name=kde 2>&1
sleep 2
echo "=== start ==="
$DS start --name=kde 2>&1
sleep 12
echo "=== show ==="
$DS show 2>&1
echo "=== desktop process ==="
$DS --name=kde run -- /bin/sh -c 'ps -ef | grep -E "startplasma|kwin_wayland |plasmashell" | grep -v grep' 2>&1
echo "=== anland daemon log ==="
tail -n 8 /data/local/Droidspaces/Logs/kde/anland 2>&1
