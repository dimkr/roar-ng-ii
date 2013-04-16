PKG_NAME="elinks"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="Tabbed text web browser"
PKG_CAT="Network"
PKG_DEPS="zlib,bzip2,xz,gnutls,gpm"
PKG_LICENSE="custom"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 git://repo.or.cz/elinks.git $PKG_NAME-$PKG_VER
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
	./autogen.sh
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-bookmarks \
	            --disable-xbel \
	            --disable-sm-scripting \
	            --enable-nls \
	            --enable-cookies \
	            --enable-formhist \
	            --enable-globhist \
	            --disable-mailcap \
	            --enable-mimetypes \
	            --enable-ipv6 \
	            --disable-bittorrent \
	            --disable-data \
	            --disable-uri-rewrite \
	            --disable-cgi \
	            --disable-finger \
	            --disable-fsp \
	            --enable-ftp \
	            --disable-gopher \
	            --disable-nntp \
	            --disable-smb \
	            --enable-mouse \
	            --disable-sysmouse \
	            --enable-88-colors \
	            --enable-256-colors \
	            --disable-true-color \
	            --disable-exmode \
	            --enable-leds \
	            --enable-marks \
	            --enable-css \
	            --disable-html-highlight \
	            --disable-backtrace \
	            --disable-no-root \
	            --disable-debug \
	            --enable-fastmem \
	            --disable-own-libc \
	            --enable-utf-8 \
	            --enable-combining \
	            --without-xterm \
	            --with-gpm \
	            --with-zlib \
	            --with-bzlib \
	            --without-idn \
	            --without-gc \
	            --with-lzma \
	            --without-gssapi \
	            --without-spidermonkey \
	            --without-guile \
	            --without-perl \
	            --without-python \
	            --without-lua \
	            --without-tre \
	            --without-ruby \
	            --with-gnutls \
	            --without-openssl \
	            --without-nss_compat_ossl \
	            --without-x
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

	# install the license and the list of authors
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1

	return 0
}