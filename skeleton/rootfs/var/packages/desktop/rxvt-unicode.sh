PKG_NAME="rxvt-unicode"
PKG_VER="9.18"
PKG_REV="1"
PKG_DESC="A terminal emulator"
PKG_CAT="Desktop"
PKG_DEPS="xserver_xorg"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://dist.schmorp.de/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-assert \
	            --disable-warnings \
	            --disable-256-color \
	            --disable-unicode3 \
	            --enable-combining \
	            --enable-xft \
	            --enable-font-styles \
	            --disable-pixbuf \
	            --disable-startup-notification \
	            --enable-transparency \
	            --enable-fading \
	            --disable-rxvt-scroll \
	            --enable-next-scroll \
	            --disable-xterm-scroll \
	            --disable-perl \
	            --disable-xim \
	            --enable-backspace-key \
	            --enable-delete-key \
	            --enable-resources \
	            --disable-8bitctrls \
	            --disable-fallback \
	            --enable-swapscreen \
	            --enable-iso14755 \
	            --disable-frills \
	            --enable-keepscrolling \
	            --enable-selectionscrolling \
	            --enable-mousewheel \
	            --enable-smart-resize \
	            --enable-text-blink \
	            --disable-pointer-blank \
	            --disable-utmp \
	            --disable-wtmp \
	            --disable-lastlog \
	            --disable-debug
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

	# install the FAQ
	install -D -m 644 README.FAQ $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README.FAQ
	[ 0 -ne $? ] && return 1

	return 0
}