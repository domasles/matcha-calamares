#!/bin/sh
set -e

ALPINE_VERSION="3.23"
PACKAGE_NAME="matcha-calamares"

WORKSPACE=$(pwd)

BUILD_ROOT="$HOME/build-space"
PKG_DIR="$BUILD_ROOT/$PACKAGE_NAME"

if [ "$(id -u)" -eq 0 ]; then
    apk update
    apk add --no-cache alpine-sdk sudo git nodejs

    if ! id builduser >/dev/null 2>&1; then
        adduser -D builduser
        adduser builduser abuild

        echo "builduser ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/builduser
    fi

    chown -R builduser:abuild "$WORKSPACE"
    mkdir -p /out
    chown -R builduser:abuild /out

    exec su - builduser -c "cd '$WORKSPACE' && WORKSPACE='$WORKSPACE' sh '$0'"
fi

if [ ! -f "$HOME"/.abuild/*.rsa ]; then
    abuild-keygen -a -n

    sudo cp "$HOME"/.abuild/*.rsa.pub /etc/apk/keys/
    cp "$HOME"/.abuild/*.rsa.pub /out/
fi

mkdir -p "$PKG_DIR"

cp "$WORKSPACE"/APKBUILD "$PKG_DIR"/

# Create tarballs for the build context
tar -czf "$PKG_DIR"/calamares-config.tar.gz -C "$WORKSPACE"/calamares-config .
tar -czf "$PKG_DIR"/calamares-settings.tar.gz -C "$WORKSPACE"/calamares-settings .
tar -czf "$PKG_DIR"/excludes.tar.gz -C "$WORKSPACE"/excludes .
tar -czf "$PKG_DIR"/branding.tar.gz -C "$WORKSPACE"/branding matcha

cd "$PKG_DIR"

abuild -F checksum
sudo abuild -F deps
abuild -r -P /out
