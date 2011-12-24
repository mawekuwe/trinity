#!/bin/bash -e
shopt -s -o pipefail
_pgm=${0##*/} # whoami
_path=${0%/*} # fetch directory name = module name
_pwd=$(pwd)
_chroot="/home/chroot"
_date=$(date +%F)"-"$(date +%R)
_repos="/home/chroot/root/repo"
_pkgname="*.pkg.tar*"
#tdelibs tdebindings tdewebdev
_list=(tdelibs tdebase tdeaccessibility tdeutils tdemultimedia tdeadmin tdeartwork tdegames tdetoys tdeedu tdevelop tdeaddons tdepim tdesdk tdenetwork tdegraphics )
for i in ${_list[@]}; do
	echo ${i}
	pushd ${i}
		[[ -f PKGBUILD ]] || continue;
		source PKGBUILD
		[[ -f "${pkgname}-${pkgver}.tar.xz" ]]  &&   echo "Already Built" || {
			echo "Packaging---> ${pkgname}-${pkgver}"
			mksource
		}
	popd
done
