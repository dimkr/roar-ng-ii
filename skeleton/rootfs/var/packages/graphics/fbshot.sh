PKG_NAME="fbshot"
PKG_VER="0.3"
PKG_REV="1"
PKG_DESC="Screenshot taking utility for the framebuffer"
PKG_CAT="Graphics"
PKG_DEPS="libpng"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://www.sfires.net/stuff/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# set the compiler flags
	sed -i s~'gcc'~"$CC $CFLAGS"~ Makefile
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	install -D -m 755 fbshot $INSTALL_DIR/$BIN_DIR/fbshot
	[ 0 -ne $? ] && return 1
	install -D -m 644 fbshot.1.man $INSTALL_DIR/$MAN_DIR/man1/fbshot.1
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1
	install -D -m 644 CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1

	return 0
}