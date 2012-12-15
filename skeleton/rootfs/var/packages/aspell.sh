#!/bin/sh

PKG_NAME="aspell"
PKG_VER="0.60.6.1"
PKG_REV="1"
PKG_DESC="Spell checker"
PKG_CAT="Document"
PKG_DEPS="ncurses"

# the package source files
PKG_SRC="ftp://ftp.gnu.org/gnu/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-static \
	            --enable-shared \
	            --enable-pkgdatadir=/$SHARE_DIR/$PKG_NAME \
	            --enable-pkglibdir=/$LIB_DIR/$PKG_NAME \
	            --enable-pspell-compatibility
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

	return 0
}
