#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
run_gold() {
  $DS --name=kde run -- su -s /bin/bash Gold -c "$1"
}
run_gold 'kwriteconfig6 --file kscreenlockerrc --group Daemon --key Autolock false'
run_gold 'kwriteconfig6 --file kscreenlockerrc --group Daemon --key LockOnResume false'
run_gold 'kwriteconfig6 --file kscreenlockerrc --group Daemon --key Timeout 0'
echo "=== kscreenlockerrc ==="
$DS --name=kde run -- su -s /bin/bash Gold -c 'cat ~/.config/kscreenlockerrc'
