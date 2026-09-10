#!/bin/sh
set -e

ISO_SRC=$(findmnt -n -o SOURCE -t iso9660 | head -n1)
ISO_TGT=$(findmnt -n -o TARGET -t iso9660 | head -n1)

if [ -z "$ISO_SRC" ] || [ -z "$ISO_TGT" ]; then
    echo "ERROR: No install disk mounted!" >&2
    exit 1
fi

ACTUAL_LABEL=$(blkid -s LABEL -o value "$ISO_SRC")

. /etc/os-release

ARCH=$(uname -m)
EXPECTED_LABEL="alpine-matcha ${VERSION_ID} ${ARCH}"

if [ "$ACTUAL_LABEL" = "$EXPECTED_LABEL" ]; then
    mount --bind "$ISO_TGT" "$1/media/cdrom"
else
    echo "ERROR: ISO label mismatch! Expected: \"$EXPECTED_LABEL\", Got: \"$ACTUAL_LABEL\"" >&2
    echo "Please mount only one ISO file while installing" >&2
    exit 1
fi
