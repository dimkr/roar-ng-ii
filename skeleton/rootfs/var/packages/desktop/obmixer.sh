PKG_NAME="obmixer"
PKG_VER="0.11"
PKG_REV="1"
PKG_DESC="A volume control tray icon"
PKG_CAT="Desktop"
PKG_DEPS="alsa-lib,gtk"
PKG_LICENSE="gpl-3.0.txt"

# the package source files
PKG_SRC="http://jpegserv.com/linux/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	LIBS="-lm" ./autogen.sh $AUTOTOOLS_BASE_OPTS
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