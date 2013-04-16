PKG_NAME="gtkdialog"
PKG_VER="0.8.3"
PKG_REV="1"
PKG_DESC="A utility for fast creation of graphical applications"
PKG_CAT="Desktop"
PKG_DEPS="gtk"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://$PKG_NAME.googlecode.com/files/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS
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