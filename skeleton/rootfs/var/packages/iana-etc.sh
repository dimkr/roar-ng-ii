#!/bin/sh

PKG_NAME="iana-etc"
PKG_VER="2.30"
PKG_REV="1"
PKG_DESC="Lists of network protocols and services provided by IANA"
PKG_CAT="BuildingBlock"
PKG_DEPS=""
PKG_LICENSE="custom"
PKG_ARCH="noarch"

# the package source files
PKG_SRC="http://www.sethwklein.net/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# download the latest files
	#make -j $BUILD_THREADS get
	#[ 0 -ne $? ] && return 1

	# configure the package
	sed -i s~'ETC_DIR=.*'~"ETC_DIR=/$CONF_DIR"~ Makefile
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

	# create backwards-compatibility symlinks
	if [ "etc" != "$CONF_DIR" ]
	then
		mkdir -p $INSTALL_DIR/etc
		[ 0 -ne $? ] && return 1
		ln -s ../$CONF_DIR/services $INSTALL_DIR/etc/services
		[ 0 -ne $? ] && return 1
		ln -s ../$CONF_DIR/protocols $INSTALL_DIR/etc/protocols
		[ 0 -ne $? ] && return 1
	fi

	# install the license and the list of authors
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	install -D -m 644 CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1

	return 0
}
