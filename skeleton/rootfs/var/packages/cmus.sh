#!/bin/sh

PKG_NAME="cmus"
PKG_VER="2.4.3"
PKG_REV="1"
PKG_DESC="Console music player"
PKG_CAT="Multimedia"
PKG_DEPS="+ncurses,+alsa-lib,+libmad,+libvorbis,+flac,+libav"

# the package source files
PKG_SRC="http://sourceforge.net/projects/cmus/files/$PKG_NAME-v$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	tar -xjvf $PKG_NAME-v$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-v$PKG_VER

	# configure the package
	./configure prefix=/$BASE_INSTALL_PREFIX \
	            libdir=/$LIB_DIR \
	            DEBUG=0 \
	            CONFIG_ROAR=n \
	            CONFIG_PULSE=n \
	            CONFIG_ALSA=y \
	            CONFIG_AO=n \
	            CONFIG_ARTS=n \
	            CONFIG_OSS=n \
	            CONFIG_SUN=n
	            CONFIG_WAVEOUT=n
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
