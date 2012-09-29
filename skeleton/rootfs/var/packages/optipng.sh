#!/bin/sh

PKG_NAME="optipng"
PKG_VER="0.7.3"
PKG_REV="1"
PKG_DESC="A PNG optimizer"
PKG_CAT="Graphic"
PKG_DEPS=""

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.gz ] && return 0
	# download the sources tarball
	download_file http://prdownloads.sourceforge.net/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1
	return 0
}

build() {
	# extract the sources tarball
	tar -xzvf $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure --prefix=/$BASE_INSTALL_PREFIX
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

	# install the license
	install -D -m 644 LICENSE.txt $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE.txt
	[ 0 -ne $? ] && return 1

	return 0
}
