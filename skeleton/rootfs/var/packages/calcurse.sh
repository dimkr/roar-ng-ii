#!/bin/sh

PKG_NAME="calcurse"
PKG_VER="3.0.0"
PKG_REV="1"
PKG_DESC="Calendar and scheduling application"
PKG_CAT="Utility"
PKG_DEPS="+ncurses"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.gz ] && return 0
	# download the sources tarball
	download_file http://calcurse.org/files/$PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1
	return 0
}

build() {
	# extract the sources tarball
	tar -xzvf $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-memory-debug
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

	# install the license and the list of authors
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}
