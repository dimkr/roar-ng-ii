#!/bin/sh

PKG_NAME="rtorrent"
PKG_VER="0.9.2"
PKG_REV="1"
PKG_DESC="BitTorrent client"
PKG_CAT="Internet"
PKG_DEPS="+zlib,+ncurses,+openssl,+cyrus-sasl2,+openldap,+libtorrent"

# the package source files
PKG_SRC="http://libtorrent.rakshasa.no/downloads/$PKG_NAME-$PKG_VER.tar.gz"

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
	            --disable-debug \
	            --disable-extra-debug \
	            --enable-ipv6 \
	            --without-xmlrpc-c
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

	# install the man page
	install -D -m 644 doc/rtorrent.1 $INSTALL_DIR/$MAN_DIR/man1/rtorrent.1
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}
