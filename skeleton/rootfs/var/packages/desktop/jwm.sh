PKG_NAME="jwm"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="A lightweight window manager"
PKG_CAT="Desktop"
PKG_DEPS="xserver_xorg"
PKG_LICENSE="gpl-2.0.txt"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 \
	          git://github.com/joewing/jwm.git \
	          $PKG_NAME-$PKG_VER
	[ 0 -ne $? ] && return 1

	# create a sources tarball
	make_tarball_and_delete $PKG_NAME-$PKG_VER $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# generate a configure script
	autoreconf
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-fribidi \
	            --disable-debug
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

	# install the default configuration
	install -D -m 644 example.jwmrc $INSTALL_DIR/$CONF_DIR/system.jwmrc
	[ 0 -ne $? ] && return 1

	return 0
}