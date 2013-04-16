PKG_NAME="gtk-theme-switch"
PKG_VER="2.1.0"
PKG_REV="1"
PKG_DESC="A GTK+ theme switcher"
PKG_CAT="Desktop"
PKG_DEPS="gtk"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://ftp.de.debian.org/debian/pool/main/g/$PKG_NAME/${PKG_NAME}_$PKG_VER.orig.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball ${PKG_NAME}_$PKG_VER.orig.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	sed s~'^CLFAGS =.*'~"CFLAGS = $CFLAGS"~ -i Makefile
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	install -D -m 755 gtk-theme-switch2 $INSTALL_DIR/$BIN_DIR/gtk-theme-switch2
	[ 0 -ne $? ] && return 1
	install -D -m 644 gtk-theme-switch2.1 \
	                  $INSTALL_DIR/$MAN_DIR/man1/gtk-theme-switch2.1
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 readme $INSTALL_DIR/$DOC_DIR/$PKG_NAME/readme
	[ 0 -ne $? ] && return 1

	return 0
}