#!/system/bin/sh
getevent -pl 2>/dev/null | grep -E 'add device|name:|REL_|ABS_MT|KEY_' | head -n 120
