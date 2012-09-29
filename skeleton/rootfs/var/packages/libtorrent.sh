#!/bin/sh

PKG_NAME="libtorrent"
PKG_VER="0.13.2"
PKG_REV="1"
PKG_DESC="BitTorrent library"
PKG_CAT="Internet"
PKG_DEPS="+openssl,+libsigc++"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.gz ] && return 0
	# download the sources tarball
	download_file http://libtorrent.rakshasa.no/downloads/$PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1
	return 0
}

build() {
	# extract the sources tarball
	tar -xzvf $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-shared \
	            --disable-static \
	            --disable-debug \
	            --disable-extra-debug \
	            --enable-ipv6
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
