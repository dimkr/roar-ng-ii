#!/bin/sh

PKG_NAME="subito-desktop"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="The Subito GNU/Linux desktop"
PKG_CAT="Desktop"
PKG_DEPS="+xorg_base,+rxvt-unicode,+cwm"
PKG_ARCH="noarch"

# the package source files
PKG_SRC=""

download() {
	[ -f subito-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 \
	          git://github.com/iguleder/subito.git \
	          subito-$PKG_VER
	[ 0 -ne $? ] && return 1

	# create a sources tarball
	make_tarball_and_delete subito-$PKG_VER subito-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	return 0
}

build() {
	# extract the sources tarball
	extract_tarball subito-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the skeleton
	cp -ar subito-$PKG_VER/subito-desktop $INSTALL_DIR
	[ 0 -ne $? ] && return 1

	return 0
}
