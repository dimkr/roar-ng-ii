#!/bin/sh

PKG_NAME="linux-headers"
PKG_VER="3.2.30"
PKG_REV="1"
PKG_DESC="Linux kernel API headers"
PKG_CAT="Develop"
PKG_DEPS="+linux"
PKG_ARCH="noarch"

download() {
	[ -f linux-$PKG_VER.tar.xz ] && return 0
	# download the sources tarball
	download_file http://www.kernel.org/pub/linux/kernel/v3.0/linux-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1
	return 0
}

build() {
	# extract the sources
	tar -xJvf linux-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd linux-$PKG_VER

	# clean the kernel sources
	make clean
	[ 0 -ne $? ] && return 1
	make mrproper
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the kernel API headers
	make INSTALL_HDR_PATH=$INSTALL_DIR/$BASE_INSTALL_PREFIX headers_install
	[ 0 -ne $? ] && return 1

	# remove unneeded files from the kernel headers installation
	find $INSTALL_DIR/$BASE_INSTALL_PREFIX -name .install -or \
	                                       -name ..install.cmd | xargs rm -f
	[ 0 -ne $? ] && return 1

	return 0
}
