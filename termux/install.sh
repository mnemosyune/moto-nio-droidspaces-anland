#!/data/data/com.termux/files/usr/bin/bash
# Copy the Android-side scripts to /data/local/tmp so they can be run from a
# normal Termux shell with `su -c` without worrying about SELinux or paths.
#
# Usage (inside Termux):
#   bash termux/install.sh
#   su -c "sh /data/local/tmp/moto-nio/anland_external.sh"
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST=/data/local/tmp/moto-nio

if ! command -v su >/dev/null 2>&1; then
  echo "ERROR: su not found. Install Magisk and grant Termux root access." >&2
  exit 1
fi

su -c "mkdir -p '$DEST/container'"
su -c "cp '$REPO'/scripts/host/*.sh '$DEST/'"
su -c "cp '$REPO'/scripts/container/*.sh '$DEST/container/'"
su -c "chmod 755 '$DEST'/*.sh '$DEST/container'/*.sh"

echo "Installed host scripts to: $DEST"
echo "Installed container scripts to: $DEST/container"
echo
echo "Examples:"
echo "  su -c 'sh $DEST/status_now.sh'"
echo "  su -c 'sh $DEST/anland_external.sh'"
echo "  su -c 'sh $DEST/desk_on.sh'"
