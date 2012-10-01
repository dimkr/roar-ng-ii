#!/bin/sh

PKG_NAME="alsaequal"
PKG_VER="0.6"
PKG_REV="1"
PKG_DESC="An equalizer plugin for ALSA"
PKG_CAT="Multimedia"
PKG_DEPS="+alsa-lib,+caps"

# the package source files
PKG_SRC="http://www.thedigitalmachine.net/tools/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	tar -xjvf $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME

	# configure the package
	sed -e s~'^CC\t :=.*'~"CC := $CC"~ \
	    -e s~'^CFLAGS :=.*'~"CFLAGS = $CFLAGS -fPIC"~ \
	    -e s~'^LD :=.*'~"LD := $CC"~ \
	    -e s~'^LDFLAGS :=.*'~"LDFLAGS = $LDFLAGS -shared -lasound"~ \
	    -e s~'/usr/lib/alsa-lib'~"/$LIB_DIR/alsa-lib"~g \
	    -i Makefile
	[ 0 -ne $? ] && return 1

	# set the path to the CAPS library
	sed s~'/usr/lib/ladspa/caps.so'~"/$LIB_DIR/ladspa/caps.so"~ \
	    -i ctl_equal.c
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	mkdir -p $INSTALL_DIR/$LIB_DIR/alsa-lib
	[ $? -ne 0  ] && return 1
	make DESTDIR=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	return 0
}
