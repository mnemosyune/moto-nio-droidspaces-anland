#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/1000
export WAYLAND_DISPLAY=wayland-0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
pid=$(pidof kwin_wayland)
measure() {
  hz=$(getconf CLK_TCK)
  a=$(awk '{print $14+$15}' /proc/$pid/stat)
  sleep 6
  b=$(awk '{print $14+$15}' /proc/$pid/stat)
  echo "$1: $(( (b-a)*100/(hz*6) ))% of one core"
}
echo "active effects: $(qdbus6 org.kde.KWin /Effects org.kde.kwin.Effects.activeEffects 2>&1)"
measure "current (external desktop)"
qdbus6 org.kde.KWin /KWin showDesktop true 2>&1
sleep 2
measure "show desktop (no windows)"
qdbus6 org.kde.KWin /KWin showDesktop false 2>&1
echo "done"
