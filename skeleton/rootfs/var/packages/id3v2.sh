#!/bin/sh

PKG_NAME="id3v2"
PKG_VER="0.1.12"
PKG_REV="1"
PKG_DESC="An id3v2 tag editor"
PKG_CAT="Multimedia"
PKG_DEPS="zlib,id3lib"
PKG_LICENSE="lgpl-2.1.txt"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/$PKG_NAME/$PKG_NAME/$PKG_VER/$PKG_NAME-$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	sed -e s~'^LDFLAGS+=	'~"& $LDFLAGS"~ \
	    -e s~'^PREFIX=	.*'~"PREFIX?=	/$BASE_INSTALL_PREFIX"~ \
	    -e s~'/bin/'~"/$BIN_DIR/"~ \
	    -e s~'/share/man/'~"/$MAN_DIR/"~ \
	    -i Makefile
	[ 0 -ne $? ] && return 1

	# build the package
	make clean
	[ 0 -ne $? ] && return 1
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	mkdir -p $INSTALL_DIR/$BIN_DIR $INSTALL_DIR/$MAN_DIR/man1
	[ 0 -ne $? ] && return 1
	make PREFIX=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	return 0
}
