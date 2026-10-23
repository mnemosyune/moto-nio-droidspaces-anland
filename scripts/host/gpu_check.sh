#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
echo "=== kscreen ==="
$DS --name=kde run -- su - Gold -c 'XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0 kscreen-doctor -o' 2>&1 | head -40
echo "=== kwin journal gpu ==="
$DS --name=kde run -- journalctl --user -b --no-pager 2>&1 | grep -i -E 'kwin|egl|opengl|kgsl|gpu|render' | tail -40
