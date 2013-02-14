#!/bin/sh

PKG_NAME="libsigc++"
PKG_VER="2.3.1"
PKG_REV="1"
PKG_DESC="Callback system for C++"
PKG_CAT="BuildingBlock"
PKG_DEPS=""
PKG_LICENSE="lgpl-2.1.txt"

# the package source files
PKG_SRC="http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.3/$PKG_NAME-$PKG_VER.tar.xz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-static \
	            --enable-shared \
	            --disable-documentation
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
