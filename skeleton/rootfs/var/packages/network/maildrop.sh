PKG_NAME="maildrop"
PKG_VER="2.6.0"
PKG_REV="1"
PKG_DESC="An e-mail delivery agent"
PKG_CAT="Network"
PKG_DEPS="gdbm,libidn,gamin"
PKG_LICENSE="gpl-3.0.txt"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/courier/maildrop/$PKG_VER/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-shared \
	            --disable-static \
	            --with-db=gdbm \
	            --enable-sendmail=/usr/bin/sendmail \
	            --enable-maildrop-uid=root \
	            --enable-maildrop-gid=mail \
	            --disable-authlib \
	            --enable-use-flock=1 \
	            --enable-use-dotlock=0 \
	            --disable-tempdir \
	            --enable-crlf-term=0 \
	            --enable-keep-fromline=1 \
	            --enable-syslog=1 \
	            --with-etcdir=/$CONF_DIR \
	            --without-devel
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

	# install the license
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}