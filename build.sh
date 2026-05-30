#!/bin/sh
set -e

ALPINE_VERSION="3.23"
PACKAGE_NAME="matcha-calamares"

WORKSPACE=$(pwd)
BUILD_ROOT="$HOME/build-space"
PKG_DIR="$BUILD_ROOT/$PACKAGE_NAME"

if [ "$(id -u)" -eq 0 ]; then
    apk update
    apk add --no-cache alpine-sdk doas git nodejs

    if ! id builduser >/dev/null 2>&1; then
        adduser -D builduser
        adduser builduser abuild

        echo "permit nopass builduser" > /etc/doas.conf
    fi

    chown -R builduser:abuild "$WORKSPACE"
    mkdir -p /out
    chown -R builduser:abuild /out

    exec su - builduser -c "cd '$WORKSPACE' && WORKSPACE='$WORKSPACE' sh '$0'"
fi

if [ ! -f "$HOME"/.abuild/*.rsa ]; then
    abuild-keygen -a -n
    doas cp "$HOME"/.abuild/*.rsa.pub /etc/apk/keys/
fi

mkdir -p "$PKG_DIR"

cp "$WORKSPACE"/APKBUILD "$PKG_DIR"/
cp "$WORKSPACE"/*.conf "$PKG_DIR"/ 2>/dev/null || true

cd "$PKG_DIR"

abuild -F checksum
doas abuild -F deps
abuild -r -P /out
