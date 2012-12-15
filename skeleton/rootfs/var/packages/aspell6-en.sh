#!/bin/sh

PKG_NAME="aspell6-en"
PKG_VER="7.1-0"
PKG_REV="1"
PKG_DESC="English dictionary for Aspell"
PKG_CAT="Document"
PKG_DEPS="aspell"

# the package source files
PKG_SRC="ftp://ftp.gnu.org/gnu/aspell/dict/en/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure PREZIP=/$BIN_DIR/prezip-bin
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	# install the copyright statement
	install -D -m 644 Copyright $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/Copyright
	[ 0 -ne $? ] && return 1

	return 0
}
