#!/bin/sh

PKG_NAME="stalonetray"
PKG_VER="0.8.1"
PKG_REV="1"
PKG_DESC="Standlone system tray"
PKG_CAT="Desktop"
PKG_DEPS="+util-linux,+xorg_base"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/stalonetray/stalonetray/$PKG_NAME-$PKG_VER/$PKG_NAME-$PKG_VER.tar.bz2"

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
	            --disable-native-kde \
	            --disable-debug \
	            --disable-dump-win-info
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

	# install the example configuration file
	install -D -m 644 stalonetrayrc.sample $INSTALL_DIR/$CONF_DIR/stalonetrayrc
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}
