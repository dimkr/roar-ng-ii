PKG_NAME="epdfview"
PKG_VER="0.1.8"
PKG_REV="1"
PKG_DESC="A PDF viewer"
PKG_CAT="Utilities"
PKG_DEPS="poppler,gtk"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://ftp.de.debian.org/debian/pool/main/e/$PKG_NAME/${PKG_NAME}_$PKG_VER.orig.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball ${PKG_NAME}_$PKG_VER.orig.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-debug \
	            --without-cups
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

	# create a link to the icon
	mkdir -p $INSTALL_DIR/$PIXMAPS_DIR
	[ 0 -ne $? ] && return 1
	ln -s /$SHARE_DIR/epdfview/pixmaps/icon_epdfview-48.png \
	      $INSTALL_DIR/$PIXMAPS_DIR
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