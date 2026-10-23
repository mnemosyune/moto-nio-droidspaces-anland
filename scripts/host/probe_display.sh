#!/system/bin/sh
echo "=== meminfo ==="
grep -E 'MemTotal|MemFree|MemAvailable|Cached|SwapTotal|SwapFree' /proc/meminfo
echo "=== readyfor packages ==="
pm list packages | grep -Ei 'readyfor|motorola.desktop|displayport|desktop'
echo "=== display feature ==="
pm list features | grep -Ei 'display|hdmi|secondary'
echo "=== drm connectors ==="
for f in /sys/class/drm/card*/status; do echo -n "$f: "; cat $f; done 2>/dev/null
echo "=== dp alt mode / usb ==="
dumpsys usb | head -20
echo "=== cpu ==="
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null
getprop ro.soc.model
