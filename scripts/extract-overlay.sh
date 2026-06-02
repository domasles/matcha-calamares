#!/bin/sh

tar -xzf /media/cdrom/matcha.apkovl.tar.gz -C "${ROOT:-/}" \
    --exclude=./home \
    --exclude=./etc/passwd \
    --exclude=./etc/group \
    --exclude=./etc/shadow \
    --exclude=./etc/hostname \
    --exclude=./etc/sudoers.d \
    --exclude=./etc/polkit-1/ \
    --exclude=./etc/runlevels/sysinit/modloop
