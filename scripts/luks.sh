#!/bin/sh
set -e

GRUB_CONFIG="/etc/default/grub"
LUKS_UUID=$(blkid -t TYPE=crypto_LUKS -o value -s UUID | head -n 1)

if [ -n "$LUKS_UUID" ]; then
    sed -i "s|TARGET_UUID|$LUKS_UUID|g" "$GRUB_CONFIG"
else
    sed -i "s| cryptroot=UUID=TARGET_UUID cryptdm=root||g" "$GRUB_CONFIG"
fi
