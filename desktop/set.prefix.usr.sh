
_list=(kdelibs kdebase kdeaccessibility kdeutils kdemultimedia kdeadmin kdeartwork kdegames kdetoys kdeedu kdepim kdesdk kdeaddons kdevelop kdewebdev kdegraphics)

for i in ${_list[@]}; do
	echo ${i}
	sed -i 's|^_prefix=/usr/local|_prefix=/usr|' ${i}/PKGBUILD
done
