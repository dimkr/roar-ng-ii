PKG_NAME="yad"
PKG_VER="0.20.3"
PKG_REV="1"
PKG_DESC="A utility for graphical dialogs through shell scripts"
PKG_CAT="Desktop"
PKG_DEPS="gtk"
PKG_LICENSE="gpl-3.0.txt"

# the package source files
PKG_SRC="http://$PKG_NAME.googlecode.com/files/$PKG_NAME-$PKG_VER.tar.xz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package; use the rgb.txt created by the xorg_base package
	# template
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-deprecated \
	            --disable-icon-browser \
	            --with-rgb=/usr/share/X11/rgb.txt
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