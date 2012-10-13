#!/bin/sh

PKG_NAME="tudu"
PKG_VER="0.8.1"
PKG_REV="1"
PKG_DESC="Hierarchical TODOs management application"
PKG_CAT="Personal"
PKG_DEPS="+ncurses"

# the package source files
PKG_SRC="http://code.meskio.net/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	sed -i s/' -O2'// configure
	[ 0 -ne $? ] && return 1
	./configure $AUTOTOOLS_BASE_OPTS
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

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}
