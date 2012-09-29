#!/bin/sh

PKG_NAME="snownews"
PKG_VER="1.5.12"
PKG_REV="1"
PKG_DESC="RSS news reader"
PKG_CAT="Internet"
PKG_DEPS="+zlib,+ncurses,+libxml2"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.gz ] && return 0
	# download the sources tarball
	download_file https://kiza.kcore.de/media/software/snownews/$PKG_NAME-$PKG_VER.tar.gz
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
	sed -i s~'-O2'~"$CFLAGS"~ platform_settings
	[ 0 -ne $? ] && return 1

	# build the package
	EXTRA_LDFLAGS="-lm $(pkg-config --libs --cflags zlib)" \
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	# install the author name and the credits list
	install -D -m 644 AUTHOR $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHOR
	[ 0 -ne $? ] && return 1
	install -D -m 644 CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1

	return 0
}
