PKG_NAME="fbset"
PKG_VER="2.1"
PKG_REV="1"
PKG_DESC="Framebuffer console configuration tool"
PKG_CAT="Utilities"
PKG_DEPS=""
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://users.telenet.be/geertu/Linux/fbdev/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	sed -i s~'^CC =.*'~"CC = $CC $CFLAGS"~ Makefile
	[ 0 -ne $? ] && return 1

	# set the path to fb.modes
	sed -i s~'#define DEFAULT_MODEDBFILE.*'~"#define DEFAULT_MODEDBFILE \"/$CONF_DIR/fb.modes\""~ fbset.c
	[ 0 -ne $? ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	install -D -m 755 fbset $INSTALL_DIR/$SBIN_DIR/fbset
	[ 0 -ne $? ] && return 1
	install -D -m 644 fbset.8 $INSTALL_DIR/$MAN_DIR/man8/fbset.8
	[ 0 -ne $? ] && return 1
	install -D -m 644 fb.modes.5 $INSTALL_DIR/$MAN_DIR/man5/fb.modes.5
	[ 0 -ne $? ] && return 1
	install -D -m 644 etc/fb.modes.ATI $INSTALL_DIR/$CONF_DIR/fb.modes
	[ 0 -ne $? ] && return 1

	return 0
}