PKG_NAME="rgbpaint"
PKG_VER="0.8.7"
PKG_REV="1"
PKG_DESC="An image editor"
PKG_CAT="Graphics"
PKG_DEPS="gtk"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/mtpaint/$PKG_NAME/$PKG_VER/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# force linking against libX11
	sed -e s~'pkg-config '~'&x11 '~ \
	    -e s~'LDFLAG = '~'&-lm '~ \
	    -i configure
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure cflags \
	            --bindir=$INSTALL_DIR/$BIN_DIR \
	            intl \
	            --locale=$INSTALL_DIR/$LOCALE_DIR \
	            man \
	            --mandir=$INSTALL_DIR/$MAN_DIR/man1 \
	            --prefix=$INSTALL_DIR/$BASE_INSTALL_PREFIX
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make install
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	return 0
}