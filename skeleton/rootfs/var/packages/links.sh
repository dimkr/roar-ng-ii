#!/bin/sh

PKG_NAME="links"
PKG_VER="2.7"
PKG_REV="1"
PKG_DESC="Text web browser"
PKG_CAT="Internet"
PKG_DEPS="+zlib,+bzip2,+xz,+openssl,+gpm"

# the package source files
PKG_SRC="http://links.twibright.com/download/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	tar -xjvf $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# generate a new configure script
	autoconf
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-debuglevel=0 \
	            --disable-graphics \
	            --enable-utf8 \
	            --with-gpm \
	            --with-ssl \
	            --with-zlib \
	            --with-bzip2 \
	            --with-lzma \
	            --without-svgalib \
	            --without-x \
	            --without-fb \
	            --without-directfb \
	            --without-pmshell \
	            --without-windows \
	            --without-atheos \
	            --without-x \
	            --disable-png-pkgconfig \
	            --without-libjpeg \
	            --without-libtiff
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
