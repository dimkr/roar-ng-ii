PKG_NAME="xarchiver"
PKG_VER="0.5.2"
PKG_REV="1"
PKG_DESC="An archive manager"
PKG_CAT="Utilities"
PKG_DEPS="gtk"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/$PKG_NAME/$PKG_NAME/$PKG_VER/$PKG_NAME-$PKG_VER.tar.bz2
         http://slackbuilds.org/slackbuilds/14.0/system/xarchiver/xarchiver-0.5.2-add_xz_support.patch"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# apply the XZ support patch
	patch -p1 < ../xarchiver-0.5.2-add_xz_support.patch
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-static \
	            --enable-shared \
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

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}