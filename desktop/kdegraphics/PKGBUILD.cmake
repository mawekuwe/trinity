# Maintainer: Baho Utot <baho-utot@columbus.rr.com>
pkgname=kdegraphics
pkgver=3.5.13
pkgrel=00
arch=('i686' 'x86_64')
url="http://trinity.pearsoncomputing.net"
license=('GPL2')
groups=('trinity')
pkgdesc="Trinity - ${pkgname}"
source=(${pkgname}-${pkgver}.tar.gz)
depends=(kdelibs desktop-file-utils)
makedepends=(cmake)
optdepends=()
options=()
install=install

_prefix=/usr
mksource() {
	git clone http://scm.trinitydesktop.org/scm/git/${pkgname}
	pushd ${pkgname}
		git submodule init
		git submodule update
		git checkout v3.5.13
	popd
	tar -cvJf ${pkgname}-${pkgver}.tar.xz ${pkgname}/*
	rm -fr ${pkgname}
}
build() {
	msg "Building revision $pkgver"
	mkdir -vp ${srcdir}/BUILD
	cd ${srcdir}/BUILD
	msg "Starting cmake..."
	cmake ${srcdir}/${pkgname}/ \
		-DCMAKE_INSTALL_PREFIX=${_prefix} \
		-DSYSCONF_INSTALL_DIR=/etc \
		-DCMAKE_CXX_FLAGS="-fpermissive" \
		-DWITH_TIFF=ON \
		-DBUILD_KAMERA=OFF \
		-DBUILD_KSVG=OFF \
		-DBUILD_KUICKSHOW=OFF \
		-DBUILD_LIBKSCAN=OFF \
		-DBUILD_KOOKA=OFF \
		-DBUILD_KGHOSTVIEW=OFF \
		-DBUILD_KFILE_PLUGINS=OFF \
		-DBUILD_ALL=ON
	make
}
package() {
	msg "Packaging - $pkgname-$pkgver"
	cd ${srcdir}/BUILD
	make DESTDIR="$pkgdir/" install
	rm -rf ${pkgdir}/usr/share/icons/hicolor/index.theme || true
	rm -rf ${pkgdir}${_prefix}/share/doc || true
}
