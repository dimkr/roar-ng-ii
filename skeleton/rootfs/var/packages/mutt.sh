#!/bin/sh

PKG_NAME="mutt"
PKG_VER="1.5.21"
PKG_REV="1"
PKG_DESC="E-mail client"
PKG_CAT="Internet"
PKG_DEPS="gdbm,ncurses,gnutls,cyrus-sasl2,gpgme"

# the package source files
PKG_SRC="ftp://ftp.mutt.org/mutt/devel/$PKG_NAME-$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-gpgme \
	            --enable-smime \
	            --enable-pop \
	            --enable-imap \
	            --enable-smtp \
	            --disable-flock \
	            --disable-debug \
	            --enable-fcntl \
	            --disable-nfs-fix \
	            --disable-mailtool \
	            --disable-locales-fix \
	            --disable-exact-address \
	            --enable-hcache \
	            --enable-nls \
	            --enable-full-doc \
	            --with-curses \
	            --with-regex \
	            --with-mailpath=/$MAIL_DIR \
	            --with-docdir=/$DOC_DIR/$PKG_NAME \
	            --without-gss \
	            --without-ssl \
	            --with-gnutls \
	            --with-sasl \
	            --without-tokyocabinet \
	            --with-gdbm \
	            --without-bdb \
	            --without-included-gettext \
	            --without-idn \
	            --with-wc-funcs
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

	# remove the GPL license copy
	rm -f $INSTALL_DIR/$DOC_DIR/$PKG_NAME/GPL
	[ 0 -ne $? ] && return 1
	ln -s /$LEGAL_DIR/licenses/gpl-2.0.txt $INSTALL_DIR/$DOC_DIR/$PKG_NAME/GPL
	[ 0 -ne $? ] && return 1

	return 0
}
