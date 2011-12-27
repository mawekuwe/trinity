#!/bin/bash -e
shopt -s -o pipefail
_pgm=${0##*/} # whoami
_path=${0%/*} # fetch directory name = module name
_pwd=$(pwd)
_chroot="/home/chroot"
_date=$(date +%F)"-"$(date +%R)
_repos="/home/chroot/root/repo"
_pkgname="*.pkg.tar*"
_list=('adept' 'abakus' 'amarok' )
for i in ${_list[@]}; do
	pushd ${i}
		[[ -f PKGBUILD ]] || { echo "No PKGBUILD in -->${i}";popd;continue; }
		source PKGBUILD
		[[ -f "${pkgname}-${pkgver}.tar.xz" ]]  &&   echo "Already Built" || {
			echo "Packaging---> ${pkgname}-${pkgver}"
			mksource
		}
	popd
done
