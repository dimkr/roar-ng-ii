#!/bin/sh

PKG_NAME="dropbear"
PKG_VER="2012.55"
PKG_REV="1"
PKG_DESC="SSH2 server and client"
PKG_CAT="Network"
PKG_DEPS="+zlib"

# the programs to build
PROGRAMS="dbclient dropbearkey"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.bz2 ] && return 0
	# download the sources tarball
	download_file http://matt.ucc.asn.au/dropbear/releases/$PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1
	return 0
}

build() {
	# extract the sources
	tar -xjvf $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-pam \
	            --enable-syslog \
	            --disable-lastlog \
	            --disable-utmp \
	            --disable-utmpx \
	            --disable-wtmp \
	            --disable-wtmpx
	[ 0 -ne $? ] && return 1

	# set the xauth path
	sed -i s~'/usr/bin/X11/xauth'~"$(which xauth)"~ options.h
	[ 0 -ne $? ] && return 1
	
	# set the key paths
	sed -i s~/etc/dropbear~"/$CONF_DIR/dropbear"~g options.h
	[ 0 -ne $? ] && return 1
	
	# build the package
	make -j $BUILD_THREADS PROGRAMS="dropbear $PROGRAMS" MULTI=1
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the multi-call binary
	install -D -m 755 dropbearmulti $INSTALL_DIR/$BIN_DIR/dropbear
	[ 0 -ne $? ] && return 1

	# add the configuration directory
	mkdir -p $INSTALL_DIR/$CONF_DIR/dropbear
	[ 0 -ne $? ] && return 1

	# create symlinks to the multi-call binary
	for i in $PROGRAMS ssh
	do
		ln -s dropbear $INSTALL_DIR/$BIN_DIR/$i
		[ 0 -ne $? ] && return 1
	done

	# install the man page
	install -D -m 644 dbclient.1 $INSTALL_DIR/$MAN_DIR/man1/dhclient.1
	[ 0 -ne $? ] && return 1

	# install the license
	install -D -m 644 LICENSE $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE
	[ 0 -ne $? ] && return 1

	return 0
}
