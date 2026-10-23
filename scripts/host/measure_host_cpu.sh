#!/system/bin/sh
# Host-side CPU sampler for the external-display stack.
HZ=100
SECS=10

ticks() {
  awk '{print $14+$15}' "/proc/$1/stat" 2>/dev/null
}

cpu_sample() {
  awk '/^cpu /{busy=$2+$3+$4+$7+$8; total=busy+$5+$6; print busy, total; exit}' /proc/stat
}

ps -A -o PID,NAME | grep -E 'kwin_wayland$|com\.android\.systemui|surfaceflinger|anland\.consumer|com\.motorola\.launcher3' > /data/local/tmp/cpu_base.raw
: > /data/local/tmp/cpu_base
while read -r pid name; do
  [ -n "$pid" ] || continue
  t=$(ticks "$pid")
  [ -n "$t" ] || continue
  echo "$pid $name $t" >> /data/local/tmp/cpu_base
done < /data/local/tmp/cpu_base.raw

set -- $(cpu_sample)
busy1=$1
total1=$2

echo "=== processes before ==="
cat /data/local/tmp/cpu_base
echo "=== sampling ${SECS}s ==="
sleep "$SECS"

set -- $(cpu_sample)
busy2=$1
total2=$2

echo "=== per-process CPU over ${SECS}s (percent of one core) ==="
while read -r pid name t1; do
  t2=$(ticks "$pid")
  if [ -z "$t2" ]; then
    echo "$name ($pid): exited"
    continue
  fi
  pct=$(( (t2 - t1) * 100 / (HZ * SECS) ))
  echo "$name ($pid): ${pct}%"
done < /data/local/tmp/cpu_base

db=$((busy2 - busy1))
dt=$((total2 - total1))
if [ "$dt" -gt 0 ]; then
  echo "=== total CPU: $(( db * 100 / dt ))% of all cores ==="
fi
echo "=== load ==="
cat /proc/loadavg
