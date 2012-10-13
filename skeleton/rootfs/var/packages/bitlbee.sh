#!/bin/sh

PKG_NAME="bitlbee"
PKG_VER="3.0.5"
PKG_REV="1"
PKG_DESC="An IRC to other networks gateway"
PKG_CAT="Internet"
PKG_DEPS="+gnutls,+glib2"

# the package source files
PKG_SRC="http://get.bitlbee.org/src/$PKG_NAME-$PKG_VER.tar.gz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# set the pkgconfig files directory
	sed -i s~"pcdir='\$prefix/lib/pkgconfig'"~"pcdir='/$LIB_DIR/pkgconfig'"~ \
	    configure
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure --prefix=/$BASE_INSTALL_PREFIX \
	            --bindir=/$BIN_DIR \
	            --sbindir=/$SBIN_DIR \
	            --etcdir=/$CONF_DIR \
	            --mandir=/$MAN_DIR \
	            --datadir=/$SHARE_DIR/$PKG_NAME \
	            --plugindir=/$LIB_DIR/$PKG_NAME \
	            --pidfile=/$RUN_DIR/$PKG_NAME \
	            --config=/$VAR_DIR/lib/$PKG_NAME \
	            --msn=1 \
	            --jabber=1 \
	            --oscar=1 \
	            --yahoo=1 \
	            --purple=0 \
	            --debug=0 \
	            --strip=0 \
	            --gcov=0 \
	            --plugins=1 \
	            --otr=0 \
	            --skype=0 \
	            --events=glib \
	            --ssl=gnutls
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
	make DESTDIR=$INSTALL_DIR install-etc
	[ 0 -ne $? ] && return 1
	make DESTDIR=$INSTALL_DIR install-dev
	[ 0 -ne $? ] && return 1

	# create the variable data directory
	mkdir -p $INSTALL_DIR/$VAR_DIR/lib/$PKG_NAME
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 doc/AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1
	install -D -m 644 doc/CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1

	return 0
}
