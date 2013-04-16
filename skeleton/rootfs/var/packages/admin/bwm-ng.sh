PKG_NAME="bwm-ng"
PKG_VER="0.6"
PKG_REV="1"
PKG_DESC="Simple bandwidth monitor"
PKG_CAT="Administration"
PKG_DEPS="ncurses"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://www.gropp.org/bwm-ng/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-html \
	            --disable-csv \
	            --enable-extededstats \
	            --enable-configfile \
	            --disable-netstatpath \
	            --disable-netstatbyte \
	            --disable-netstatlink \
	            --enable-time \
	            --without-disktats \
	            --without-partitions
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
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1

	return 0
}