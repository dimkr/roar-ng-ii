#!/bin/sh

PKG_NAME="dvtm"
PKG_VER="0.8"
PKG_REV="1"
PKG_DESC="A console tiling window manager"
PKG_CAT="Utility"
PKG_DEPS="+ncurses"

# the package source files
PKG_SRC="http://www.brain-dump.org/projects/dvtm/$PKG_NAME-$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# build the package
	make -j $BUILD_THREADS PREFIX=/$BASE_INSTALL_PREFIX
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR PREFIX=/$BASE_INSTALL_PREFIX install
	[ 0 -ne $? ] && return 1

	# install the license
	install -D -m 644 LICENSE $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE
	[ 0 -ne $? ] && return 1

	return 0
}
