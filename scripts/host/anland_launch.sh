#!/system/bin/sh
# Launch the Anland desktop window on a chosen Android display.
# Usage: anland_launch.sh [display_id]   (default 0 = phone screen)
DISP=${1:-0}
DS=/data/local/Droidspaces/bin/droidspaces

if ! "$DS" show 2>/dev/null | grep -q 'kde'; then
  echo "ERROR: container 'kde' is not running. Start it first." >&2
  exit 1
fi

SOCK=$(ls -t /data/local/Droidspaces/Net/anland-*.sock 2>/dev/null | head -n1)
if [ -z "$SOCK" ]; then
  echo "ERROR: no Anland broker socket found; is container 'kde' running with Anland enabled?" >&2
  exit 1
fi
echo "display: $DISP"
echo "socket:  $SOCK"
am force-stop com.anland.consumer
sleep 1
am start -n com.anland.consumer/.SecondaryActivity --es socket_path "$SOCK" --display "$DISP"
