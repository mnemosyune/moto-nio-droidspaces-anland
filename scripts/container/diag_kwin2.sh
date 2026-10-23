#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/1000
export WAYLAND_DISPLAY=wayland-0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
echo "=== kscreen outputs ==="
kscreen-doctor -o 2>&1
echo "=== kwin screens ==="
qdbus6 org.kde.KWin /KWin supportInformation 2>&1 | sed -n '/^Screens/,/^Screen Edges/p' | head -40
echo "=== kwin compositing ==="
qdbus6 org.kde.KWin /KWin supportInformation 2>&1 | sed -n '/^Compositing/,/^Screen Edges/p' | head -60
echo "=== kwin threads ==="
pid=$(pidof kwin_wayland)
top -H -b -n2 -d1 -p "$pid" | tail -22
echo "=== kwin fd/egl ==="
ls -l /proc/$pid/fd 2>/dev/null | grep -E 'dri|kgsl|dmabuf' | head -10
echo "=== kwin env ==="
tr '\0' '\n' < /proc/$pid/environ | grep -E 'GALLIUM|MESA|ANLAND|WAYLAND|XDG|FD_FORCE|EGL|GL' | sort
