#!/bin/sh

PKG_NAME="grun"
PKG_VER="0.9.3"
PKG_REV="1"
PKG_DESC="Application execution dialog"
PKG_CAT="Utility"
PKG_DEPS="+gtk+"

# the package source files
PKG_SRC="http://grun.googlecode.com/files/$PKG_NAME-$PKG_VER.tar.gz"

download() {
]	return 0
}

build() {
	# extract the sources tarball
	tar -xzvf $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-associations
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
