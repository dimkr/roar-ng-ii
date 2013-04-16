PKG_NAME="abook"
PKG_VER="0.5.6"
PKG_REV="1"
PKG_DESC="An address book designed for use with Mutt"
PKG_CAT="Utilities"
PKG_DEPS="ncurses"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://prdownloads.sourceforge.net/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# generate a new configure script
	autoreconf
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-debug \
	            --with-curses \
	            --without-readline
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
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1

	return 0
}