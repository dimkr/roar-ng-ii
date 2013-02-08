#!/bin/sh

PKG_NAME="optipng"
PKG_VER="0.7.4"
PKG_REV="2"
PKG_DESC="A PNG optimizer"
PKG_CAT="Graphic"
PKG_DEPS=""
PKG_LICENSE="custom"

# the package source files
PKG_SRC="http://prdownloads.sourceforge.net/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure --prefix=/$BASE_INSTALL_PREFIX \
	            --bindir=/$BIN_DIR \
	            --mandir=/$MAN_DIR \
	            --disable-debug \
	            --without-system-libpng \
	            --without-system-zlib
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

	# install the zlib README
	install -D -m 644 src/zlib/README \
	              $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/README.zlib
	[ 0 -ne $? ] && return 1

	# install the libpng license
	install -D -m 644 src/libpng/LICENSE \
	              $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE.libpng
	[ 0 -ne $? ] && return 1

	return 0
}