#!/bin/sh

PKG_NAME="linux"
PKG_VER="3.2.30"
PKG_REV="1"
PKG_DESC="A monolithic kernel, with Linux-libre modifications and Aufs"
PKG_CAT="BuildingBlock"
PKG_DEPS="+gawk,+perl"

# the kernel image file name
KERNEL_IMAGE_FILE_NAME="vmlinuz"

# the major version
PKG_MAJOR_VER="$(echo $PKG_VER | cut -f 1-2 -d .)"

# the Aufs tarball name
AUFS_TARBALL_NAME="aufs3-$PKG_MAJOR_VER-git$(date +%d%m%Y)"

download() {
	# download the sources tarball of the major version - it will be downloaded
	# once, for each major version
	if [ ! -f $PKG_NAME-$PKG_MAJOR_VER.tar.xz ]
	then
		download_file http://www.kernel.org/pub/linux/kernel/v3.0/$PKG_NAME-$PKG_MAJOR_VER.tar.xz
		[ 0 -ne $? ] && return 1
	fi

	# download the minor version patch, which is small - every minor version has
	# an incremental patch of all previous releases
	if [ ! -f patch-$PKG_VER.xz ]
	then
		download_file http://www.kernel.org/pub/linux/kernel/v3.0/patch-$PKG_VER.xz
		[ 0 -ne $? ] && return 1
	fi

	# download the Aufs sources
	if [ ! -f $AUFS_TARBALL_NAME.tar.xz ]
	then
		# download the sources
		git clone \
		      git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git \
		      $AUFS_TARBALL_NAME
		[ 0 -ne $? ] && return 1

		# switch to the matching branch
		cd $AUFS_TARBALL_NAME
		git checkout origin/aufs$PKG_MAJOR_VER
		[ 0 -ne $? ] && return 1
		cd ..

		# create a sources tarball
		tar -c $AUFS_TARBALL_NAME | xz -9 -e > $AUFS_TARBALL_NAME.tar.xz
		[ 0 -ne $? ] && return 1

		# clean up
		rm -rf $AUFS_TARBALL_NAME
		[ 0 -ne $? ] && return 1
	fi

	# download the Linux-libre deblobbing scripts
	if [ ! -f deblob-$PKG_MAJOR_VER ]
	then
		download_file http://linux-libre.fsfla.org/pub/linux-libre/releases/$PKG_VER-gnu/deblob-$PKG_MAJOR_VER
		[ 0 -ne $? ] && return 1
	fi

	if [ ! -f deblob-check ]
	then
		download_file http://linux-libre.fsfla.org/pub/linux-libre/releases/$PKG_VER-gnu/deblob-check
		[ 0 -ne $? ] && return 1
	fi

	# download the deblobbing log of the Linux-libre sources tarball, to make
	# sure the scripts succeeded; they may fail if a modifcation (e.g Aufs)
	# conflicts with their constants
	if [ ! -f linux-libre-$PKG_VER-gnu.log ]
	then
		download_file http://linux-libre.fsfla.org/pub/linux-libre/releases/$PKG_VER-gnu/linux-libre-$PKG_VER-gnu.log
		[ 0 -ne $? ] && return 1
	fi

	return 0
}

build() {
	# extract the sources
	tar -xJvf $PKG_NAME-$PKG_MAJOR_VER.tar.xz
	[ 0 -ne $? ] && return 1

	# decompress the minor version patch
	xz -d patch-$PKG_VER.xz
	[ 0 -ne $? ] && return 1

	# extract the Aufs sources
	tar -xJvf $AUFS_TARBALL_NAME.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_MAJOR_VER

	# clean the kernel sources
	make clean
	[ 0 -ne $? ] && return 1
	make mrproper
	[ 0 -ne $? ] && return 1

	# apply the minor version patch
	patch -p1 < ../patch-$PKG_VER
	[ 0 -ne $? ] && return 1

	# apply the Aufs patches
	for patch in kbuild base proc_map
	do
		patch -p1 < ../$AUFS_TARBALL_NAME/aufs3-$patch.patch
		[ 0 -ne $? ] && return 1
	done

	# add the Aufs files
	for directory in fs Documentation
	do
		cp -r ../$AUFS_TARBALL_NAME/$directory .
		[ 0 -ne $? ] && return 1
	done

	# add the Aufs header
	cp ../$AUFS_TARBALL_NAME/include/linux/aufs_type.h \
	   include/linux
	[ 0 -ne $? ] && return 1

	# force deblob-check to use gawk, to prevent it from using Python
	sed -i s~'set_main_cmd=set_.*_main$'~'set_main_cmd=set_awk_main'~g \
	    ../deblob-check
	[ 0 -ne $? ] && return 1

	# make the deblobbing scripts executable
	chmod 755 ../deblob-$PKG_MAJOR_VER ../deblob-check
	[ 0 -ne $? ] && return 1

	# deblob the kernel; save the deblobbing script's output
	(../deblob-$PKG_MAJOR_VER) 2>&1 | tee ../deblob.log
	[ 0 -ne $? ] && return 1

	# make sure the deblobbing succeeded by comparing the logs
	cmp ../deblob.log ../linux-libre-$PKG_VER-gnu.log
	[ 0 -ne $? ] && return 1

	# reset the minor version number, so the package is backwards-compatible
	# with previous bug-fix versions
	sed -i s/'^SUBLEVEL = .*'/'SUBLEVEL ='/ Makefile
	[ 0 -ne $? ] && return 1

	# reset EXTRAVERSION; Linux-libre scripts set it to "-gnu"
	sed -i s/'^EXTRAVERSION =.*'/'EXTRAVERSION ='/ Makefile
	[ 0 -ne $? ] && return 1

	# reduce "swappiness", to make the kernel perform less swapping
	sed -i s/'int vm_swappiness = 60;'/'int vm_swappiness = 20;'/ mm/vmscan.c
	[ 0 -ne $? ] && return 1

	# reduce the kernel verbosity to make the boot sequence quiet
	sed -i s~'DEFAULT_CONSOLE_LOGLEVEL 7'~'DEFAULT_CONSOLE_LOGLEVEL 3'~ kernel/printk.c
	[ 0 -ne $? ] && return 1

	# add the configuration
	cp -f /$SOURCE_DIR/$PKG_NAME/config-$PKG_ARCH .config
	[ 0 -ne $? ] && return 1

	# build the kernel image and the modules
	make -j $BUILD_THREADS bzImage modules
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the kernel image
	install -D -m 644 arch/$PKG_ARCH/$BOOT_DIR/bzImage \
	                  $INSTALL_DIR/$BOOT_DIR/$KERNEL_IMAGE_FILE_NAME
	[ 0 -ne $? ] && return 1

	# install System.map, required to generate module dependency files
	install -D -m 644 System.map $INSTALL_DIR/$BOOT_DIR/System.map
	[ 0 -ne $? ] && return 1

	# install the kernel modules and firmware
	make INSTALL_MOD_PATH=$INSTALL_DIR modules_install
	[ 0 -ne $? ] && return 1

	# remove all generated module dependency files - depmod is able to
	# generate them at boot-time
	for i in $INSTALL_DIR/lib/modules/$PKG_MAJOR_VER/modules.*
	do
		case "$i" in
			*/modules.builtin|*/modules.order)
				continue
				;;
		esac

		rm -f "$i"
		[ 0 -ne $? ] && return 1
	done

	# fix the symlinks to the kernel sources - instead of pointing to the
	# sources directory, make them point to /$SOURCE_DIR/$PKG_NAME
	for i in build source
	do
		path="$INSTALL_DIR/lib/modules/$PKG_MAJOR_VER/$i"
		rm -f "$path"
		[ 0 -ne $? ] && return 1
		ln -s ../../../$SOURCE_DIR/$PKG_NAME "$path"
		[ 0 -ne $? ] && return 1
	done

	# install the license, the list of authors and the list of maintainers
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	install -D -m 644 CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1
	install -D -m 644 MAINTAINERS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/MAINTAINERS
	[ 0 -ne $? ] && return 1

	return 0
}
