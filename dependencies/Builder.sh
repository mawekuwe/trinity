#!/bin/bash -e
shopt -s -o pipefail
_pgm=${0##*/} # whoami
_path=${0%/*} # fetch directory name = module name
_pwd=$(pwd)
_chroot="/home/chroot"
_date=$(date +%F)"-"$(date +%R)
_repos="/home/chroot/root/repo"
_pkgname="*.pkg.tar*"
#_buildlist=('qt3' 'tqtinterface' 'dbus-tqt' 'dbus-1-tqt' 'arts')
for i in 'qt3' 'tqtinterface' 'dbus-tqt' 'dbus-1-tqt' 'arts' ; do
	echo ${i}
	pushd ${i}
		#echo "In directory --> $(pwd)"
		[[ -f PKGBUILD ]] || continue;
		source PKGBUILD
		[[ -f "${_repos}/${pkgname}-${pkgver}-${pkgrel}-i686.pkg.tar.xz" ]]  &&   echo "Already Built" || {
			rm build.log namcap.log filelist.log || true
			echo "Building---> ${pkgname}-${pkgver}-${pkgrel} ${i}"
			( sudo /usr/sbin/mkarchroot -u  ${_chroot}/root |& tee	  build.log )
			( sudo /usr/sbin/makechrootpkg -c -r ${_chroot} |& tee -a build.log )
			#	Namcap package
			_pkg=$(echo *.pkg.*)
			[ -f ${_pkg} ] || ( echo "Missing package: ${_pkgname}";exit 4 )
			( /usr/bin/namcap ${_pkg}	|& tee namcap.log )
			( /bin/tar -tf ${_pkg}		|& tee filelist.log )
			#	Me and my repo
			mv -vf ${_pkg} ${_repos}
			/usr/bin/repo-add ${_repos}/local.db.tar.gz ${_repos}/${_pkg}
		}
	popd
done
