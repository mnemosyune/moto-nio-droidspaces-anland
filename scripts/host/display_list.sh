#!/system/bin/sh
echo "=== Display States (Android display ids) ==="
dumpsys display | sed -n '/Display States:/,/^$/p'
echo "=== Display Devices (name / resolution / type) ==="
dumpsys display | grep 'DisplayDeviceInfo{' | sed 's/, modeId.*type / ... type /'
echo "=== DRM connectors ==="
for f in /sys/class/drm/card*/status; do echo -n "$f: "; cat "$f" 2>/dev/null; done
