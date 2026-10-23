#!/system/bin/sh
echo "=== before ==="
ps -A -o PID,PPID,USER,%CPU,NAME | grep -E 'systemui|launcher3' | grep -v grep
PID=$(ps -A -o PID,NAME | grep 'systemui_readyfor1' | grep -v grep | awk '{print $1}' | head -1)
echo "secondary systemui pid=$PID"
if [ -n "$PID" ]; then
  kill -9 "$PID" 2>&1
  echo "killed"
fi
sleep 3
echo "=== after 3s ==="
ps -A -o PID,PPID,USER,%CPU,NAME | grep -E 'systemui|launcher3' | grep -v grep
echo "=== display 4 ==="
dumpsys window displays | grep -E 'mDisplayId=4|mCurrentFocus|mFocusedApp'
