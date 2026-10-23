#!/system/bin/sh
# Disable the Moto Ready For stack so Anland can own the external display.
# Re-enable with desk_on.sh.  `pm disable-user` is reversible and does not
# uninstall anything.
for pkg in com.motorola.mobiledesktop com.motorola.mobiledesktop.core com.motorola.systemui.desk; do
  pm disable-user --user 0 "$pkg" >/dev/null 2>&1
  am force-stop "$pkg" >/dev/null 2>&1
done

for pkg in com.motorola.mobiledesktop com.motorola.mobiledesktop.core com.motorola.systemui.desk; do
  if pm list packages -e | grep -q "^package:$pkg$"; then
    echo "$pkg: enabled"
  else
    echo "$pkg: disabled"
  fi
done
