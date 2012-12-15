#!/bin/sh

PKG_NAME="irssi"
PKG_VER="0.8.15"
PKG_REV="2"
PKG_DESC="IRC client"
PKG_CAT="Internet"
PKG_DEPS="ncurses,perl,openssl,glib2"

# the package source files
PKG_SRC="http://irssi.org/files/$PKG_NAME-$PKG_VER.tar.bz2"

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
	            --enable-ipv6 \
	            --enable-ssl \
	            --without-socks \
	            --with-textui \
	            --without-bot \
	            --without-proxy \
	            --without-terminfo \
	            --with-perl=module
	[ 0 -ne $? ] && return 1

	# change the compiler flags the Perl support is built with
	for i in $(find src/perl -name Makefile.PL)
	do
		sed -i s~"'LIBS' => '',"~"&\n              'CFLAGS' => '$CFLAGS',\n              'LDDLFLAGS' => '-shared $LDFLAGS',"~ $i
		[ 0 -ne $? ] && return 1
	done

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
