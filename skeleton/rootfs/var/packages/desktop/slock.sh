PKG_NAME="slock"
PKG_VER="1.1"
PKG_REV="1"
PKG_DESC="A screen locking tool"
PKG_CAT="Desktop"
PKG_DEPS="xserver_xorg"
PKG_LICENSE="custom"

# the package source files
PKG_SRC="http://dl.suckless.org/tools/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	sed -e s~' -Os'~" $CFLAGS"~ \
	    -e s~'^LDFLAGS ='~"& $LDFLAGS"~ \
	    -e s~'^CC =.*'~"CC = $CC"~ \
	    -i config.mk
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	install -D -m 1755 slock $INSTALL_DIR/$BIN_DIR/slock
	[ 0 -ne $? ] && return 1

	# install the license
	install -D -m 644 LICENSE $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE
	[ 0 -ne $? ] && return 1

	return 0
}