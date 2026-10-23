#!/system/bin/sh
# Re-enable the Moto Ready For stack (fallback mode).
# If a package was frozen by a third-party freezer such as Hail, unfreeze it
# there as well; `pm enable` only reverses `pm disable-user`.
for pkg in com.motorola.mobiledesktop com.motorola.mobiledesktop.core com.motorola.systemui.desk; do
  pm enable "$pkg" >/dev/null 2>&1
done

for pkg in com.motorola.mobiledesktop com.motorola.mobiledesktop.core com.motorola.systemui.desk; do
  if pm list packages -e | grep -q "^package:$pkg$"; then
    echo "$pkg: enabled"
  else
    echo "$pkg: disabled"
  fi
done
echo "Replug the monitor (or restart the desk SystemUI) to let Ready For take over."
