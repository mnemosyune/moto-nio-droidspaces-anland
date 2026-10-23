#!/system/bin/sh
# Launch the Anland/KDE desktop on the external HDMI/DP display,
# bypassing the Moto Ready For stack.
DS=/data/local/Droidspaces/bin/droidspaces
SOCKDIR=/data/local/Droidspaces/Net

DISP=$(dumpsys display | grep 'DisplayInfo{"HDMI' | head -n1 | sed -n 's/.*displayId \([0-9][0-9]*\).*/\1/p')
if [ -z "$DISP" ]; then
  echo "ERROR: no HDMI display detected (connect the monitor first)" >&2
  exit 1
fi
echo "external display: $DISP"

if ! "$DS" show 2>/dev/null | grep -q 'kde'; then
  echo "starting container kde..."
  "$DS" start --name=kde >/dev/null 2>&1
  sleep 12
fi

i=0
SOCK=
while [ $i -lt 40 ]; do
  SOCK=$(ls -t "$SOCKDIR"/anland-*.sock 2>/dev/null | head -n1)
  [ -n "$SOCK" ] && break
  i=$((i+1))
  sleep 2
done
if [ -z "$SOCK" ]; then
  echo "ERROR: no Anland broker socket found" >&2
  exit 1
fi
echo "socket: $SOCK"

# Make sure the whole Moto Ready For stack is out of the way, not only the
# desk SystemUI package.  These are user-disabled, so `pm enable` can restore
# them later (desk_on.sh).
for pkg in com.motorola.mobiledesktop com.motorola.mobiledesktop.core com.motorola.systemui.desk; do
  pm disable-user --user 0 "$pkg" >/dev/null 2>&1
  am force-stop "$pkg" >/dev/null 2>&1
done
sleep 1
am force-stop com.anland.consumer
sleep 1
am start -n com.anland.consumer/.SecondaryActivity --es socket_path "$SOCK" --display "$DISP"
