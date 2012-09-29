#!/bin/sh

PKG_NAME="irssi"
PKG_VER="0.8.15"
PKG_REV="1"
PKG_DESC="IRC client"
PKG_CAT="Internet"
PKG_DEPS="+ncurses,+openssl,+glib2"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.bz2 ] && return 0
	# download the sources tarball
	download_file http://irssi.org/files/$PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1
	return 0
}

build() {
	# extract the sources tarball
	tar -xjvf $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-ipv6 \
	            --enable-ssl \
	            --without-socks \
	            --with-textui \
	            --without-bot \
	            --without-proxy \
	            --without-terminfo \
	            --with-perl=no
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
	head -n 2 COPYING > $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	chmod 644 $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1

	return 0
}
