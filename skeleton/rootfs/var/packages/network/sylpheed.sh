PKG_NAME="sylpheed"
PKG_VER="3.3.0"
PKG_REV="1"
PKG_DESC="An e-mail client"
PKG_CAT="Network"
PKG_DEPS="openssl,gpgme,gtk"
PKG_LICENSE="gpl-2.0.txt,lgpl-2.1.txt,custom"

# the package source files
PKG_SRC="http://sylpheed.sraoss.jp/sylpheed/v3.3/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-static \
	            --enable-shared \
	            --enable-gpgme \
	            --disable-jpilot \
	            --disable-ldap \
	            --enable-ssl \
	            --disable-compface \
	            --disable-gtkspell \
	            --disable-oniguruma \
	            --enable-threads \
	            --disable-ipv6 \
	            --disable-updatecheck \
	            --disable-updatecheckplugin \
	            --with-localedir=/$LOCALE_DIR \
	            --with-manualdir=/$DOC_DIR/$PKG_NAME/manual \
	            --with-faqdir=/$DOC_DIR/$PKG_NAME/FAQ \
	            --with-plugindir=/$LIB_DIR/$PKG_NAME
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

	# install the license
	install -D -m 644 LICENSE $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}