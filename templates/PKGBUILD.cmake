# Maintainer: Baho Utot <baho-utot@columbus.rr.com>
pkgname=tdelibs
pkgver=3.5.13
pkgrel=00
arch=('i686' 'x86_64')
url="http://trinity.pearsoncomputing.net"
license=('GPL2')
groups=('trinity')
pkgdesc="Trinity - ${pkgname}"
source=(${pkgname}-${pkgver}.tar.xz)
depends=(libart-lgpl jasper openexr aspell libtiff
	alsa-lib arts libcups libxcomposite libxslt
	libxml2 hicolor-icon-theme java-environment )
makedepends=(cmake)
optdepends=('pmount: mount removable devices as normal user')
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
		-DBUILD_ALL=ON
	make
}
package() {
	msg "Packaging - $pkgname-$pkgver"
	cd ${srcdir}/BUILD
	make DESTDIR="$pkgdir/" install
	if [ ${_prefix} != "/usr" ]; then
		install -vdm 755 ${pkgdir}/usr/lib/pkgconfig
		ln -vsn ${_prefix}/lib/pkgconfig/system-tools-backends.pc ${pkgdir}/usr/lib/pkgconfig
	fi
	rm -rf ${pkgdir}/usr/share/icons/hicolor/index.theme || true
}
