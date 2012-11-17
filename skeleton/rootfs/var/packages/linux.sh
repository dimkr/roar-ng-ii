#!/bin/sh

PKG_NAME="linux"
PKG_VER="3.2"
PKG_REV="34"
PKG_DESC="A monolithic kernel, with Linux-libre modifications and Aufs"
PKG_CAT="BuildingBlock"
PKG_DEPS="perl,linux-source"

# the package source files
PKG_SRC=""

# the kernel image file name
KERNEL_IMAGE_FILE_NAME="vmlinuz"

download() {
	return 0
}

build() {
	cd /$SOURCE_DIR/$PKG_NAME

	# copy the architecture's configuration file; it is part of the root file
	# system skeleton
	cp -f config-$PKG_ARCH .config
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

	# install the license, the list of authors and the list of maintainers; they
	# are also part of the kernel sources package, but it might be missing
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	install -D -m 644 CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1
	install -D -m 644 MAINTAINERS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/MAINTAINERS
	[ 0 -ne $? ] && return 1

	return 0
}
