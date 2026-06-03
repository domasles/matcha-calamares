# Contributor: Domas Leščinskas <domas.lescinskas@gmail.com>
# Maintainer: Domas Leščinskas <domas.lescinskas@gmail.com>
pkgname=matcha-calamares
pkgver=3.4.2
pkgrel=0

arch="x86_64"

url="https://calamares.io/"
pkgdesc="Matcha Linux installer framework, built on top of Calamares"
license="BSD-3-Clause AND CC-BY-4.0 AND CC0-1.0 AND GPL-3.0-or-later AND LGPL-2.1-only AND LGPL-3.0-or-later AND MIT"

provides="calamares=$pkgver"
depends="!calamares ckbcomp musl-locales os-prober yaml-cpp
    rsync mkinitfs tzdata openrc networkmanager lsblk parted
    util-linux blkid sudo e2fsprogs sfdisk grub grub-bios"

makedepends="
    extra-cmake-modules ninja yaml-cpp-dev qt6-qttools-dev
    qt6-qtbase-dev qt6-qtdeclarative-dev qt6-qtsvg-dev
    qt6-qt5compat-dev kcoreaddons-dev ki18n-dev kservice-dev
    kwidgetsaddons-dev kpmcore-dev parted-dev libatasmart-dev
    polkit-qt-dev libpwquality-dev python3-dev py3-pybind11-dev"

source="https://codeberg.org/Calamares/calamares/releases/download/v$pkgver/calamares-$pkgver.tar.gz
    calamares-settings.tar.gz
    calamares-config.tar.gz
    config.tar.gz
    branding.tar.gz"

builddir="$srcdir"/calamares-"$pkgver"
subpackages="$pkgname-dev $pkgname-doc $pkgname-lang"

_modules="welcome locale keyboard partition users services-openrc
    summary unpackfs packages fstab bootloader mkinitfs umount
    finished mount localecfg networkcfg hwclock shellprocess"

for i in $_modules; do
    subpackages="$pkgname-mod-$i:_module $subpackages"
    depends="$depends $pkgname-mod-$i"
done

prepare() {
    default_prepare
    cd "$builddir"/src/modules

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
        -DSKIP_MODULES="$(echo $_skip_modules | tr ' ' ';')"
    cmake --build build
}

_module() {
    depends="$pkgname"

    local module=${subpkgname##$pkgname-mod-}
    local path="usr/lib/calamares/modules"

    mkdir -p "$subpkgdir"/"$path"
    mv "$pkgdir"/"$path"/"$module" "$subpkgdir"/"$path"/"$module"

    case "$module" in
        mkinitfs)
            depends="$depends mkinitfs"
            install -Dm644 "$srcdir"/mkinitfs.conf "$subpkgdir"/etc/calamares/modules/mkinitfs.conf ;;
        users)
            install -Dm644 "$srcdir"/users.conf "$subpkgdir"/etc/calamares/modules/users.conf ;;
        shellprocess)
            install -Dm644 "$srcdir"/shellprocess.conf "$subpkgdir"/etc/calamares/modules/shellprocess.conf
            install -Dm644 "$srcdir"/shellprocess@bootstrap.conf "$subpkgdir"/etc/calamares/modules/shellprocess@bootstrap.conf
            install -Dm644 "$srcdir"/shellprocess@install.conf "$subpkgdir"/etc/calamares/modules/shellprocess@install.conf ;;
        locale) depends="$depends tzdata" ;;
        services-openrc) depends="$depends openrc" ;;
        networkcfg) depends="$depends networkmanager" ;;
    esac
}

package() {
    DESTDIR="$pkgdir" cmake --install build

    mkdir -p "$pkgdir"/usr/share/licenses/"$pkgname"
    cp -r "$builddir"/LICENSES/* "$pkgdir"/usr/share/licenses/"$pkgname"/

    install -Dm644 "$srcdir"/settings.conf "$pkgdir"/usr/share/calamares/settings.conf
    install -Dm644 "$srcdir"/matcha-excludes.txt "$pkgdir"/etc/calamares/matcha-excludes.txt

    mkdir -p "$pkgdir"/usr/share/calamares/branding/matcha
    cp -r "$srcdir"/matcha/* "$pkgdir"/usr/share/calamares/branding/matcha/
}
