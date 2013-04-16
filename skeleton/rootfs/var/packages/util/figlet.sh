PKG_NAME="figlet"
PKG_VER="2.2.5"
PKG_REV="1"
PKG_DESC="A program for making large letters out of text"
PKG_CAT="Utilities"
PKG_DEPS=""
PKG_LICENSE="custom"

# the package source files
PKG_SRC="ftp://ftp.figlet.org/pub/figlet/program/unix/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# build the package
	make -j $BUILD_THREADS CC=$CC LD=$CC \
	                       CFLAGS="$CFLAGS" \
	                       DEFAULTFONTDIR=/$SHARE_DIR/$PKG_NAME/fonts \
	                       all
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR \
	     prefix=/$BASE_INSTALL_PREFIX \
	     BINDIR=/$BIN_DIR \
	     MANDIR=/$MAN_DIR \
	     DEFAULTFONTDIR=/$SHARE_DIR/$PKG_NAME/fonts \
	     install
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	# install the license
	install -D -m 644 LICENSE $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE
	[ 0 -ne $? ] && return 1

	return 0
}