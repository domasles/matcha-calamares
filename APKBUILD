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
depends="!calamares ckbcomp musl-locales os-prober yaml-cpp"

makedepends="
    extra-cmake-modules ninja yaml-cpp-dev qt6-qttools-dev
    qt6-qtbase-dev qt6-qtdeclarative-dev qt6-qtsvg-dev
    qt6-qt5compat-dev kcoreaddons-dev ki18n-dev kservice-dev
    kwidgetsaddons-dev kpmcore-dev parted-dev libatasmart-dev
    polkit-qt-dev libpwquality-dev python3-dev py3-pybind11-dev"

checkdepends="py3-toml tzdata xvfb-run"

source="https://codeberg.org/Calamares/calamares/releases/download/v$pkgver/calamares-$pkgver.tar.gz modules-load.conf"
builddir="$srcdir"/calamares-"$pkgver"
subpackages="$pkgname-dev $pkgname-doc $pkgname-lang"

_modules="welcome locale keyboard partition users
    summary unpackfs fstab bootloader grubcfg mkinitfs
    packagechooser shellprocess finished"

for i in $_modules; do
    subpackages="$pkgname-mod-$i:_module $subpackages"
    depends="$depends $pkgname-mod-$i"
done

prepare() {
    default_prepare
    cd "$builddir"/src/modules

    # Automatically skip any directory not in our _modules list
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

check() {
    cd build
    CTEST_OUTPUT_ON_FAILURE=TRUE xvfb-run ctest -E "libcalamaresnetworktest|machineidtest|userstest" -j1
}

_module() {
    depends="$pkgname"

    local module=${subpkgname##$pkgname-mod-}
    local path="usr/lib/calamares/modules"

    mkdir -p "$subpkgdir"/"$path"
    mv "$pkgdir"/"$path"/"$module" "$subpkgdir"/"$path"/"$module"

    case "$module" in
        unpackfs) 
            depends="$depends rsync"
            install -Dm644 "$srcdir"/modules-load.conf "$subpkgdir"/usr/lib/modules-load.d/calamares.conf ;;
        mkinitfs) depends="$depends mkinitfs" ;;
        locale) depends="$depends tzdata" ;;
    esac
}

package() {
    DESTDIR="$pkgdir" cmake --install build

    mkdir -p "$pkgdir"/usr/share/licenses/"$pkgname"
    cp -r "$builddir"/LICENSES/* "$pkgdir"/usr/share/licenses/"$pkgname"/
}
