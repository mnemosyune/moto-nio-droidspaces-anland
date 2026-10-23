#!/system/bin/sh
# Check that Android sees Bluetooth/USB input devices and Anland is configured to forward them.
echo "=== Anland prefs ==="
cat /data/data/com.anland.consumer/shared_prefs/anland_settings.xml 2>/dev/null
echo "=== accessibility ==="
settings get secure enabled_accessibility_services
settings get secure accessibility_enabled
echo "=== Android input devices ==="
dumpsys input | grep -E '^  Device [0-9]+:|^    Name:|^    Classes:|^    Sources:' | head -80
echo "=== external display ==="
dumpsys display | grep 'DisplayInfo{"HDMI' | head -1
