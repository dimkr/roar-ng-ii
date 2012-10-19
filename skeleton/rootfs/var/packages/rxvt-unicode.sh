#!/bin/sh

PKG_NAME="rxvt-unicode"
PKG_VER="9.15"
PKG_REV="2"
PKG_DESC="Terminal emulator"
PKG_CAT="Utility"
PKG_DEPS="+xorg_base"

# the package source files
PKG_SRC="http://dist.schmorp.de/rxvt-unicode/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-assert \
	            --disable-256-color \
	            --disable-unicode3 \
	            --disable-combining \
	            --enable-xft \
	            --disable-font-styles \
	            --disable-afterimage \
	            --disable-pixbuf \
	            --disable-transparency \
	            --disable-fading \
	            --disable-rxvt-scroll \
	            --disable-next-scroll \
	            --enable-xterm-scroll \
	            --with-term="rxvt" \
	            --disable-perl \
	            --disable-xim \
	            --enable-backspace-key \
	            --enable-delete-key \
	            --enable-resources \
	            --disable-8bitctrls \
	            --enable-fallback="Rxvt" \
	            --disable-swapscreen \
	            --disable-iso14755 \
	            --disable-frills \
	            --enable-keepscrolling \
	            --enable-selectionscrolling \
	            --enable-mousewheel \
	            --enable-slipwheeling \
	            --disable-smart-resize \
	            --disable-text-blink \
	            --disable-pointer-blank \
	            --disable-utmp \
	            --disable-wtmp \
	            --disable-lastlog \
	            --with-codesets="en" \
	            --with-res-class="urxvt" \
	            --with-x
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

	return 0
}
