#!/system/bin/sh
echo "=== DISABLED ==="
pm list packages -d | grep -E 'mobiledesktop|systemui.desk|readyfor|launcher3'
echo "=== ENABLED ==="
pm list packages -e | grep -E 'mobiledesktop|systemui.desk|readyfor|launcher3'
echo "=== SecondaryDisplayLauncher ==="
dumpsys package com.motorola.launcher3 | grep -A4 SecondaryDisplayLauncher | head -12
echo "=== processes ==="
ps -A -o PID,USER,%CPU,NAME | grep -E 'systemui|launcher3|anland|kwin'
