#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
echo "=== plasma processes ==="
$DS --name=kde run -- /bin/sh -c 'ps -ef | grep -E "plasma|ksmserver|klauncher|kded|Xwayland|kwin" | grep -v grep' 2>&1
echo "=== journal desktop-session ==="
$DS --name=kde run -- journalctl -u desktop-session.service --no-pager -n 80 2>&1
echo "=== user journal tail ==="
$DS --name=kde run -- /bin/sh -c 'ls -la /run/user/1000/; journalctl --user -n 40 --no-pager 2>&1 | tail -40' 2>&1
