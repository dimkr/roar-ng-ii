PKG_NAME="xine-ui"
PKG_VER="0.99.7"
PKG_REV="1"
PKG_DESC="A multimedia player"
PKG_CAT="Multimedia"
PKG_DEPS="curl,xserver_xorg,xine-lib"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://sourceforge.net/projects/xine/files/$PKG_NAME/$PKG_VER/$PKG_NAME-$PKG_VER.tar.xz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-shm \
	            --disable-shm-default \
	            --enable-xinerama \
	            --enable-mbs \
	            --enable-xft \
	            --disable-lirc \
	            --disable-vdr-keys \
	            --disable-nvtvsimple \
	            --disable-debug \
	            --with-x \
	            --without-readline \
	            --with-curl \
	            --without-aalib \
	            --without-caca \
	            --without-fb \
	            --without-tar
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

	return 0
}