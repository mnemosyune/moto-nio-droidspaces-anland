#!/system/bin/sh
# Print Droidspaces version, requirement checks, daemon state and recent log.
DS=/data/local/Droidspaces/bin/droidspaces

echo "=== version ==="
"$DS" version 2>&1 | head -5

echo "=== check ==="
"$DS" check 2>&1

echo "=== daemon pid ==="
cat /data/local/Droidspaces/droidspacesd.pid 2>&1

echo "=== droidspaces processes ==="
ps -A | grep -i droidspaces

echo "=== log tail ==="
tail -30 /data/local/Droidspaces/Logs/droidspacesd.log 2>&1
