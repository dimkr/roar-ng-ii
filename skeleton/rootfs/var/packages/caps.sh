#!/bin/sh

PKG_NAME="caps"
PKG_VER="0.4.5"
PKG_REV="1"
PKG_DESC="An audio plugin suite"
PKG_CAT="Multimedia"
PKG_DEPS=""

# the package source files
PKG_SRC="http://www.quitte.de/dsp/${PKG_NAME}_$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	tar -xzvf ${PKG_NAME}_$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	sed -e s~'^OPTS =.*'~"OPTS = $CFLAGS"~ \
	    -e s~'^LDFLAGS =.*'~"LDFLAGS = $LDFLAGS -nostartfiles -shared"~ \
	    -e s~'^PREFIX =.*'~"PREFIX = /$INSTALL_DIR"~ \
	    -e s~'^DEST =.*'~"DEST = \$(PREFIX)/$LIB_DIR/ladspa"~ \
	    -e s~'^RDFDEST =.*'~"RDFDEST = \$(PREFIX)/$SHARE_DIR/ladspa/rdf"~ \
	    -i Makefile
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

	# install the documentation
	install -D -m 644 caps.html $INSTALL_DIR/$DOC_DIR/$PKG_NAME/caps.html
	[ 0 -ne $? ] && return 1

	return 0
}
