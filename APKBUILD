# Contributor: Domas Leščinskas <domas.lescinskas@gmail.com>
# Maintainer: Domas Leščinskas <domas.lescinskas@gmail.com>
pkgname=matcha-calamares

calamaresver=3.4.2

pkgver=1.1.1.$calamaresver
pkgrel=0

arch="x86_64"

url="https://github.com/domasles/matcha-calamares"
pkgdesc="Matcha Linux installer framework, built on top of Calamares"
license="BSD-3-Clause AND CC-BY-4.0 AND CC0-1.0 AND GPL-3.0-or-later AND LGPL-2.1-only AND LGPL-3.0-or-later AND MIT"

provides="calamares=$calamaresver"
depends="!calamares ckbcomp musl-locales os-prober yaml-cpp
    rsync mkinitfs tzdata networkmanager lsblk parted util-linux
    blkid sudo e2fsprogs sfdisk cryptsetup device-mapper lvm2
    efibootmgr qt6-qtwayland"

makedepends="extra-cmake-modules ninja yaml-cpp-dev qt6-qttools-dev
    qt6-qtbase-dev qt6-qtdeclarative-dev qt6-qtsvg-dev rsync
    qt6-qt5compat-dev qt6-qtwayland kcoreaddons-dev ki18n-dev
    kservice-dev kwidgetsaddons-dev kpmcore-dev parted-dev
    libatasmart-dev polkit-qt-dev libpwquality-dev python3-dev
    py3-pybind11-dev"

source="https://codeberg.org/Calamares/calamares/releases/download/v$calamaresver/calamares-$calamaresver.tar.gz
    branding.tar.gz
    calamares-settings.tar.gz
    calamares-config.tar.gz
    excludes.tar.gz
    scripts.tar.gz"

builddir="$srcdir/calamares-$calamaresver"
subpackages="$pkgname-dev $pkgname-doc $pkgname-lang"

_modules="welcome locale partition users summary packages
    fstab bootloader mkinitfs umount finished mount localecfg
    shellprocess"

for i in $_modules; do
    subpackages="$pkgname-mod-$i:_module $subpackages"
    depends="$depends $pkgname-mod-$i"
done

prepare() {
    default_prepare
    cd "$builddir/src/modules"

    for i in *; do
        if [ -d "$i" ] && ! echo "$_modules" | grep -qw "$i"; then
            _skip_modules="$_skip_modules $i"
        fi
    done
}

build() {
    cmake -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DINSTALL_CONFIG=ON \
        -DWITH_PYTHON=ON \
        -DWITH_PYBIND11=ON \
        -DQT_VERSION_MAJOR=6 \
        -DWITH_QT6_WAYLAND=ON \
        -DSKIP_MODULES="$(echo $_skip_modules | tr ' ' ';')"
    cmake --build build
}

_module() {
    depends="$pkgname"

    local module=${subpkgname##$pkgname-mod-}
    local path="usr/lib/calamares/modules"

    mkdir -p "$subpkgdir/$path"
    mv "$pkgdir/$path/$module" "$subpkgdir/$path/$module"

    case "$module" in
        welcome)
            install -Dm644 "$srcdir/calamares-config/welcome.conf" "$subpkgdir/etc/calamares/modules/welcome.conf" ;;
        users)
            install -Dm644 "$srcdir/calamares-config/users.conf" "$subpkgdir/etc/calamares/modules/users.conf" ;;
        shellprocess)
            mkdir -p "$subpkgdir/etc/calamares/modules/"
            rsync -rtv --chmod=D755,F644 "$srcdir/calamares-config/"shellprocess*.conf "$subpkgdir/etc/calamares/modules/" ;;
        bootloader)
            install -Dm644 "$srcdir/calamares-config/bootloader.conf" "$subpkgdir/etc/calamares/modules/bootloader.conf" ;;
        partition)
            install -Dm644 "$srcdir/calamares-config/partition.conf" "$subpkgdir/etc/calamares/modules/partition.conf" ;;
        locale)
            depends="$depends tzdata" ;;
        finished)
            install -Dm644 "$srcdir/calamares-config/finished.conf" "$subpkgdir/etc/calamares/modules/finished.conf" ;;
    esac
}

package() {
    DESTDIR="$pkgdir" cmake --install build

    install -Dm644 "$srcdir/calamares-settings/settings.conf" "$pkgdir/usr/share/calamares/settings.conf"
    install -Dm755 "$srcdir/scripts/luks.sh" "$pkgdir/etc/calamares/scripts/luks.sh"

    rsync -rtv --chmod=D755,F644 "$srcdir/excludes/" "$pkgdir/etc/calamares/excludes/"

    mkdir -p "$pkgdir/usr/share/calamares/branding"
    mkdir -p "$pkgdir/usr/share/licenses/$pkgname"

    cp -r "$srcdir/branding/matcha" "$pkgdir/usr/share/calamares/branding"
    cp -r "$builddir/LICENSES" "$pkgdir/usr/share/licenses/$pkgname"
}
