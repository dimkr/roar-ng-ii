PKG_NAME="firefox"
PKG_VER="21.0"
PKG_REV="1"
PKG_DESC="A web browser"
PKG_CAT="Network"
PKG_DEPS="expat,gtk"
PKG_LICENSE="gpl-2.0.txt,lgpl-2.1.txt,mpl-2.0.txt"

# the official build for x86 is i686-optimized
case $PKG_ARCH in
	x86|i?86)
		PKG_ARC="i686"
		;;
esac

# the package source files
PKG_SRC="ftp://ftp.mozilla.org/pub/mozilla.org/$PKG_NAME/releases/$PKG_VER/linux-$PKG_ARCH/en-US/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	mkdir -p $INSTALL_DIR/$LIB_DIR
	[ 0 -ne $? ] && return 1
	cp -r firefox $INSTALL_DIR/$LIB_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1

	# create links to all libraries
	cd firefox
	for so in *.so
	do
		ln -s ./$PKG_NAME/$so $INSTALL_DIR/$LIB_DIR/$so
		[ 0 -ne $? ] && return 1
	done

	# create a link to the executable
	mkdir -p $INSTALL_DIR/$BIN_DIR
	[ 0 -ne $? ] && return 1
	ln -s /$LIB_DIR/$PKG_NAME/firefox $INSTALL_DIR/$BIN_DIR
	[ 0 -ne $? ] && return 1

	# create a link to the icon
	mkdir -p $INSTALL_DIR/$PIXMAPS_DIR
	[ 0 -ne $? ] && return 1
	ln -s /$LIB_DIR/$PKG_NAME/browser/chrome/icons/default/default48.png \
	      $INSTALL_DIR/$PIXMAPS_DIR/firefox.png
	[ 0 -ne $? ] && return 1

	return 0
}