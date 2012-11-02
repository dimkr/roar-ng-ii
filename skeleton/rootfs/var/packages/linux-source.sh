#!/bin/sh

PKG_NAME="linux-source"
PKG_VER="3.2"
PKG_REV="33"
PKG_DESC="Sources of the Linux kernel, with Linux-libre modifications and Aufs"
PKG_CAT="BuildingBlock"
PKG_DEPS="gawk"
PKG_ARCH="noarch"

# the package source files:
#   - the sources tarball of the major version - it will be downloaded once for
#     each major version
#   - the minor version patch, which is small - every minor version has an
#     incremental patch of all previous releases
#   - the Linux-libre deblobbing scripts
#   - the deblobbing log of the Linux-libre sources tarball, to make sure the
#     scripts succeeded; they may fail if a modification (e.g Aufs) conflicts
#     with their constants
PKG_SRC="http://www.kernel.org/pub/linux/kernel/v3.0/linux-$PKG_VER.tar.xz
         http://www.kernel.org/pub/linux/kernel/v3.0/patch-$PKG_VER.$PKG_REV.xz
         http://linux-libre.fsfla.org/pub/linux-libre/releases/$PKG_VER.$PKG_REV-gnu/deblob-$PKG_VER
         http://linux-libre.fsfla.org/pub/linux-libre/releases/$PKG_VER.$PKG_REV-gnu/deblob-check
         http://linux-libre.fsfla.org/pub/linux-libre/releases/$PKG_VER.$PKG_REV-gnu/linux-libre-$PKG_VER.$PKG_REV-gnu.log"

# the Aufs tarball name
AUFS_TARBALL_NAME="aufs3-$PKG_VER-git$(date +%d%m%Y)"

download() {
	[ -f $AUFS_TARBALL_NAME.tar.xz ] && return 0

	# download the Aufs sources
	git clone git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git \
	          $AUFS_TARBALL_NAME
	[ 0 -ne $? ] && return 1

	# switch to the matching branch
	cd $AUFS_TARBALL_NAME
	git checkout origin/aufs$PKG_VER
	[ 0 -ne $? ] && return 1
	cd ..

	# create a sources tarball
	make_tarball_and_delete $AUFS_TARBALL_NAME $AUFS_TARBALL_NAME.tar.xz

	return 0
}

build() {
	# extract the sources
	extract_tarball linux-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	# decompress the minor version patch
	decompress_file patch-$PKG_VER.$PKG_REV.xz patch-$PKG_VER.$PKG_REV
	[ 0 -ne $? ] && return 1

	# extract the Aufs sources
	extract_tarball $AUFS_TARBALL_NAME.tar.xz
	[ 0 -ne $? ] && return 1

	cd linux-$PKG_VER

	# clean the kernel sources
	make clean
	[ 0 -ne $? ] && return 1
	make mrproper
	[ 0 -ne $? ] && return 1

	# apply the minor version patch
	patch -p1 < ../patch-$PKG_VER.$PKG_REV
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
	chmod 755 ../deblob-$PKG_VER ../deblob-check
	[ 0 -ne $? ] && return 1

	# deblob the kernel; save the deblobbing script's output
	(../deblob-$PKG_VER) 2>&1 | tee ../deblob.log
	[ 0 -ne $? ] && return 1

	# make sure the deblobbing succeeded by comparing the logs
	cmp ../deblob.log ../linux-libre-$PKG_VER.$PKG_REV-gnu.log
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

	cd ..

	return 0
}

package() {
	# create the sources directory
	mkdir -p $INSTALL_DIR/$SOURCE_DIR
	[ 0 -ne $? ] && return 1

	# copy the modified sources to the sources directory
	cp -r linux-$PKG_VER $INSTALL_DIR/$SOURCE_DIR/linux
	[ 0 -ne $? ] && return 1

	# create symlinks to the license, the list of authors and the list of
	# maintainers
	mkdir -p $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1
	ln -s /$SOURCE_DIR/linux/COPYING \
	      $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	ln -s /$SOURCE_DIR/linux/CREDITS \
	      $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1
	ln -s /$SOURCE_DIR/linux/MAINTAINERS \
	      $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/MAINTAINERS
	[ 0 -ne $? ] && return 1

	return 0
}
