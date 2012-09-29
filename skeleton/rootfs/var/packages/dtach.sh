#!/bin/sh

PKG_NAME="dtach"
PKG_VER="0.8"
PKG_REV="1"
PKG_DESC="A tool that emulates the detaching feature of GNU Screen"
PKG_CAT="Utility"
PKG_DEPS=""

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.gz ] && return 0
	# download the sources tarball
	download_file http://downloads.sourceforge.net/project/dtach/dtach/$PKG_VER/$PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1
	return 0
}

build() {
	# extract the sources tarball
	tar -xzvf $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	install -D -m 755 dtach $INSTALL_DIR/$BIN_DIR/dtach
	[ 0 -ne $? ] && return 1
	install -D -m 644 dtach.1 $INSTALL_DIR/$MAN_DIR/man1/dtach.1
	[ 0 -ne $? ] && return 1

	# install the copyright notice
	mkdir -p $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1
	cat README | tail -n 5 > $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYRIGHT
	[ 0 -ne $? ] && return 1
	chmod 644 $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYRIGHT
	[ 0 -ne $? ] && return 1

	return 0
}
