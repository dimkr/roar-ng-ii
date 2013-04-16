PKG_NAME="xchat"
PKG_VER="2.8.8"
PKG_REV="1"
PKG_DESC="An IRC client"
PKG_CAT="Network"
PKG_DEPS="openssl,gtk"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://xchat.org/files/source/2.8/$PKG_NAME-$PKG_VER.tar.xz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# add a missing #include statement
	for i in src/common/servlist.c \
	         src/common/text.c \
	         src/common/util.c \
	         src/common/xchat.h
	do
		sed s~'#include '~'&<glib.h>\n#include '~ -i $i
		[ 0 -ne $? ] && return 1
	done

	# configure the package
	LIBS="-lgmodule-2.0" \
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-static \
	            --enable-shared \
	            --enable-threads=posix \
	            --disable-socks \
	            --enable-ipv6 \
	            --enable-xft \
	            --enable-openssl \
	            --enable-gtkfe \
	            --disable-textfe \
	            --disable-python \
	            --disable-perl \
	            --disable-perl_old \
	            --disable-plugin \
	            --disable-tcl \
	            --disable-dbus \
	            --enable-shm \
	            --enable-spell=none \
	            --disable-ntlm
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

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}