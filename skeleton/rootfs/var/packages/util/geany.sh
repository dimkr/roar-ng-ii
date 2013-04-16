PKG_NAME="geany"
PKG_VER="1.23"
PKG_REV="1"
PKG_DESC="A text editor suitable for programming"
PKG_CAT="Utilities"
PKG_DEPS="gtk"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://download.geany.org/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-static \
	            --enable-shared \
	            --disable-plugins \
	            --disable-vte \
	            --enable-socket \
	            --disable-the-force
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

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1

	return 0
}