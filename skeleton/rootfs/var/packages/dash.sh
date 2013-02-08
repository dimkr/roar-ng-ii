#!/bin/sh

PKG_NAME="dash"
PKG_VER="0.5.7"
PKG_REV="1"
PKG_DESC="A small and fast POSIX-compliant shell"
PKG_CAT="BuildingBlock"
PKG_DEPS=""
PKG_LICENSE="custom"

# the package source files
PKG_SRC="http://gondor.apana.org.au/~herbert/dash/files/$PKG_NAME-$PKG_VER.tar.gz"

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
	            --disable-static \
	            --enable-fnmatch \
	            --enable-glob \
	            --without-libedit
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

	# create a backwards-compatibility symlink
	if [ "bin" != "$BIN_DIR" ]
	then
		mkdir $INSTALL_DIR/bin
		[ 0 -ne $? ] && return 1
		ln -s ../$BIN_DIR/dash $INSTALL_DIR/bin/dash
		[ 0 -ne $? ] && return 1
	fi

	# install the license
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1

	return 0
}
