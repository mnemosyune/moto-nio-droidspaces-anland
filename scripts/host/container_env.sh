#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
echo "=== env (droidspaces run) ==="
$DS --name=kde run -- env 2>&1 | sort
echo "=== sockets ==="
$DS --name=kde run -- /bin/sh -c 'ls -l /run /run/user/1000 /tmp 2>/dev/null | grep -i -E "anland|wayland|X11"' 2>&1
echo "=== kwin cmdline ==="
$DS --name=kde run -- /bin/sh -c 'for p in $(pgrep kwin_wayland); do echo "PID $p"; cat /proc/$p/cmdline | tr "\0" " "; echo; done' 2>&1
