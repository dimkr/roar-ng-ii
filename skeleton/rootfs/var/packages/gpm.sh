#!/bin/sh

PKG_NAME="gpm"
PKG_VER="1.20.7"
PKG_REV="1"
PKG_DESC="A mouse server"
PKG_CAT="BuildingBlock"
PKG_DEPS="ncurses"

# the package source files
PKG_SRC="http://www.nico.schottelius.org/software/gpm/archives/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# generate the configure script
	./autogen.sh
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS --with-curses
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	return 0
}
