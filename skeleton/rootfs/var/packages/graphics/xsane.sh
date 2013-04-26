PKG_NAME="xsane"
PKG_VER="0.998"
PKG_REV="1"
PKG_DESC="A scanning application"
PKG_CAT="Graphics"
PKG_DEPS="libjpeg,libpng,libtiff,gtk,sane-backends"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://www.xsane.org/download/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# generate a new configure script
	autoconf
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-gtk2 \
	            --disable-gimp \
	            --disable-gimp2 \
	            --enable-jpeg \
	            --enable-png \
	            --enable-tiff \
	            --disable-lcms \
	            --with-catgets
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
	install -D -m 644 xsane.AUTHOR \
	                  $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/xsane.AUTHOR
	[ 0 -ne $? ] && return 1

	return 0
}