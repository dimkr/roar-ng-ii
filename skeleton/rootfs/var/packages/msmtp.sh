#!/bin/sh

PKG_NAME="msmtp"
PKG_VER="1.4.30"
PKG_REV="1"
PKG_DESC="SMTP client"
PKG_CAT="Internet"
PKG_DEPS="ncurses,gnutls"
PKG_LICENSE="gpl-3.0.txt"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/$PKG_NAME/$PKG_NAME/$PKG_VER/$PKG_NAME-$PKG_VER.tar.bz2"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --without-libgsasl \
	            --without-libidn \
	            --without-gnome-keyring \
	            --without-macosx-keyring
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

	# create /usr/bin/sendmail
	if [ "usr/bin" != "$BIN_DIR" ]
	then
		mkdir -p $INSTALL_DIR/usr/bin
		[ 0 -ne $? ] && return 1
		ln -s ../../$BIN_DIR/msmtp $INSTALL_DIR/usr/bin/sendmail
		[ 0 -ne $? ] && return 1
	else
		ln -s msmtp $INSTALL_DIR/$BIN_DIR/sendmail
		[ 0 -ne $? ] && return 1
	fi

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1

	return 0
}
