PKG_NAME="ted"
PKG_VER="2.23"
PKG_REV="1"
PKG_DESC="A rich text editor"
PKG_CAT="Office"
PKG_DEPS="zlib,gtk"
PKG_LICENSE="gpl-3.0.txt"

# the package source files
PKG_SRC="http://ftp.nluug.nl/pub/editors/ted/$PKG_NAME-$PKG_VER.src.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.src.tar.gz
	[ 0 -ne $? ] && return 1

	cd Ted-$PKG_VER

	# configure the package
	sed s~'^CONFIGURE_OPTIONS=.*'~"CONFIGURE_OPTIONS=$AUTOTOOLS_BASE_OPTS --with-GTK --without-MOTIF --with-FONTCONFIG --with-XFT"~ \
	    -i Makefile
	[ 0 -ne $? ] && return 1

	# build the package
	make package
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	mkdir -p $INSTALL_DIR
	[ 0 -ne $? ] && return 1
	make DESTDIR=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	return 0
}