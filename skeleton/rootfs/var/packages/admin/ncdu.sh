PKG_NAME="ncdu"
PKG_VER="1.9"
PKG_REV="1"
PKG_DESC="Disk usage analyzer"
PKG_CAT="Administration"
PKG_DEPS="ncurses"
PKG_LICENSE="custom"

# the package source files
PKG_SRC="http://dev.yorhel.nl/download/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS
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

	# install the license; the README contains only installation guidelines
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1

	return 0
}