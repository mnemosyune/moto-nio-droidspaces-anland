#!/system/bin/sh
DS=/data/local/Droidspaces/bin/droidspaces
run_gold() {
  $DS --name=kde run -- su -s /bin/bash Gold -c "$1"
}
run_gold 'kwriteconfig6 --file powerdevilrc --group AC --group DimDisplay --key idleTime 0 --notify'
run_gold 'kwriteconfig6 --file powerdevilrc --group AC --group DPMSControl --key idleTime 0 --notify'
run_gold 'kwriteconfig6 --file powerdevilrc --group AC --group SuspendSession --key idleTime 0 --notify'
echo "=== powerdevilrc ==="
$DS --name=kde run -- su -s /bin/bash Gold -c 'cat ~/.config/powerdevilrc'
