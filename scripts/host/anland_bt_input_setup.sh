#!/system/bin/sh
# Preconfigure Anland consumer for external Bluetooth/USB mouse + keyboard.
set -e
PKG=com.anland.consumer
PREFS=/data/data/$PKG/shared_prefs/anland_settings.xml
CUR=$(settings get secure enabled_accessibility_services)
SVC="$PKG/.KeyInterceptor"

am force-stop "$PKG"
sleep 1

cp "$PREFS" /data/local/tmp/anland_settings.xml.bak

# Rewrite in place (cat > keeps owner, mode and SELinux context of the original).
cat > /data/local/tmp/anland_settings.xml <<'EOF'
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <string name="extra_keys_mode">with_keyboard</string>
    <string name="screen_orientation">default</string>
    <boolean name="pointer_capture" value="true" />
    <boolean name="accessibility_key_intercept" value="true" />
</map>
EOF
cat /data/local/tmp/anland_settings.xml > "$PREFS"

case "$CUR" in
  *"$SVC"*) echo "accessibility service already listed" ;;
  "")
    settings put secure enabled_accessibility_services "$SVC"
    echo "accessibility service added (list was empty)" ;;
  *)
    settings put secure enabled_accessibility_services "$CUR:$SVC"
    echo "accessibility service appended" ;;
esac
settings put secure accessibility_enabled 1

echo "=== prefs ==="
cat "$PREFS"
echo "=== accessibility ==="
settings get secure enabled_accessibility_services
settings get secure accessibility_enabled
