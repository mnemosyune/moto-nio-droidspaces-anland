#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
echo "=== container ==="
$DS show 2>/dev/null | grep kde
echo "=== plasma ==="
$DS --name=kde run -- /bin/bash -c 'pgrep -a plasmashell; pgrep -a kwin_wayland' 2>&1
echo "=== anland ==="
pgrep -a com.anland.consumer
echo "=== desk ==="
if pm list packages -e | grep -q 'com.motorola.systemui.desk'; then echo enabled; else echo disabled; fi
echo "=== top ==="
dumpsys activity activities | grep -m2 -E 'mResumedActivity|topResumedActivity'
