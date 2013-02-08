#!/bin/sh

PKG_NAME="fetchmail"
PKG_VER="6.3.24"
PKG_REV="1"
PKG_DESC="An e-mail retrieval and forwarding tool"
PKG_CAT="Internet"
PKG_DEPS="openssl"
PKG_LICENSE="custom"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/fetchmail/branch_6.3/$PKG_NAME-$PKG_VER.tar.xz"

download() {
	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-nls \
	            --enable-fallback=no \
	            --disable-POP2 \
	            --enable-POP3 \
	            --enable-IMAP \
	            --enable-ETRN \
	            --enable-ODMR \
	            --enable-RPA \
	            --enable-NTLM \
	            --enable-SDPS \
	            --without-kerberos5 \
	            --without-kerberos \
	            --with-ssl \
	            --without-socks \
	            --without-socks5 \
	            --without-hesiod \
	            --without-gssapi
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

	# install the READMEs
	for i in README*
	do
		install -D -m 644 $i $INSTALL_DIR/$DOC_DIR/$PKG_NAME/$i
		[ 0 -ne $? ] && return 1
	done

	return 0
}
