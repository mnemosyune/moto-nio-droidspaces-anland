#!/system/bin/sh
set -e
TMP=/data/local/tmp/newboot
MB=/data/adb/magisk/magiskboot
rm -rf "$TMP"
mkdir -p "$TMP"
cd "$TMP"
echo "=== slot ==="
getprop ro.boot.slot_suffix
echo "=== dump current boot_a ==="
dd if=/dev/block/by-name/boot_a of=boot_current.img
ls -l boot_current.img
echo "=== unpack ==="
$MB unpack boot_current.img
ls -l
echo "=== replace kernel ==="
cp /data/local/tmp/Image.new kernel
ls -l kernel /data/local/tmp/Image.new
echo "=== repack ==="
$MB repack boot_current.img new_boot.img
ls -l new_boot.img
echo "=== hashes ==="
md5sum new_boot.img
sha256sum new_boot.img
