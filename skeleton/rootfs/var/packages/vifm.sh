#!/bin/sh

PKG_NAME="vifm"
PKG_VER="0.7.3a"
PKG_REV="1"
PKG_DESC="File manager with vi-like key bindings"
PKG_CAT="System"
PKG_DEPS="+ncurses,+file"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/vifm/vifm/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-extended-keys \
	            --disable-compatibility-mode \
	            --disable-desktop-files \
	            --without-gtk \
	            --with-libmagic
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
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1
	return 0
}
