#!/bin/bash
pid=$(pidof kwin_wayland)
echo "kwin_pid=$pid"
echo "--- cpu over 5s ---"
hz=$(getconf CLK_TCK)
a=$(awk '{print $14+$15}' /proc/$pid/stat)
sleep 5
b=$(awk '{print $14+$15}' /proc/$pid/stat)
echo "ticks=$((b-a)) hz=$hz -> $(( (b-a)*100/(hz*5) ))% of one core"
echo "--- top snapshot ---"
top -b -n2 -d1 -p "$pid" | tail -8
echo "--- threads ---"
ps -L -p "$pid" -o pid,tid,pcpu,stat,comm --sort=-pcpu | head -20
echo "--- status ---"
grep -E 'Threads|VmRSS' /proc/$pid/status
echo "--- load ---"
cat /proc/loadavg
echo "--- kwin support ---"
export XDG_RUNTIME_DIR=/run/user/1000
export WAYLAND_DISPLAY=wayland-0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
qdbus6 org.kde.KWin /KWin supportInformation 2>&1 | grep -iE 'compositing|opengl|gpu|driver|refresh|backend|screen|scale|vsync|tearing|direct|render' | head -80
echo "--- kwinrc plugins ---"
grep -A40 '^\[Plugins\]' "$HOME/.config/kwinrc" 2>/dev/null
echo "--- output config ---"
sed -n '1,80p' "$HOME/.config/kwinoutputconfig.json" 2>/dev/null
echo "--- journal ---"
journalctl --user -b --no-pager -n 120 2>/dev/null | grep -iE 'kwin|anland|gl|gpu|egl' | tail -50
