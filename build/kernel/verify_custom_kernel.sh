#!/system/bin/sh
echo "=== uname ==="
uname -a
echo "=== config.gz checks ==="
zcat /proc/config.gz 2>/dev/null | grep -E '^CONFIG_(USER_NS|PID_NS|IPC_NS|UTS_NS|NET_NS|CGROUPS|CGROUP_PIDS|CGROUP_DEVICE|MEMCG|OVERLAY_FS|DEVTMPFS|VETH|BRIDGE|ANDROID_PARANOID_NETWORK)=' || echo "no /proc/config.gz"
echo "=== modules loaded count ==="
wc -l /proc/modules
echo "=== module sig failures ==="
dmesg | grep -iE 'module verification|module signature|no symbol version|disagrees about version|Unknown symbol' | tail -20
echo "=== wifi state ==="
cmd wifi status 2>&1 | head -8
ip addr show wlan0 2>&1 | head -5
echo "=== touch/input ==="
dumpsys input | grep -E 'Device [0-9]+:' | head -10
echo "=== display ==="
dumpsys display | grep -E 'mDisplayId|DisplayDeviceInfo\{' | head -10
echo "=== magisk ==="
su -c /system/bin/id
echo "=== dmesg tail errors ==="
dmesg | grep -iE 'error|fail' | tail -15
