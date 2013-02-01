#!/bin/sh

PKG_NAME="lftp"
PKG_VER="4.4.1"
PKG_REV="1"
PKG_DESC="FTP client"
PKG_CAT="Internet"
PKG_DEPS="less,ncurses,readline,gnutls"

# the package source files
PKG_SRC="http://ftp.yar.ru/pub/source/lftp/$PKG_NAME-$PKG_VER.tar.xz"

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
	            --without-debug \
	            --with-pager="$(which less)" \
	            --without-socks \
	            --without-socks5 \
	            --without-socksdante \
	            --with-modules \
	            --with-gnutls \
	            --without-openssl \
	            --without-dnssec-local-validation
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
