PKG_NAME="ytree"
PKG_VER="1.97"
PKG_REV="1"
PKG_DESC="Hierarchical file manager"
PKG_CAT="Utilities"
PKG_DEPS="ncurses"
PKG_LICENSE="gpl-2.0.txt"

# the package source files
PKG_SRC="http://www.han.de/~werner/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	sed -e s~'^DESTDIR     =.*'~"DESTDIR     ?= /"~ \
	    -e s~'^BINDIR      =.*'~"BINDIR      = \$(DESTDIR)/$BIN_DIR"~ \
	    -e s~'^MANDIR      =.*'~"MANDIR      = \$(DESTDIR)/$MAN_DIR/man1"~ \
	    -e s~'^MANESDIR    =.*'~"MANESDIR    = \$(DESTDIR)/$MAN_DIR/es/man1"~ \
	    -e s~'^READLINE'~"#READLINE"~ \
	    -e s~'^ADD_CFLAGS  =.*'~"ADD_CFLAGS  = $CFLAGS"~ \
	    -e s~'^LDFLAGS     +=.*'~"LDFLAGS     += -lncurses"~ \
	    -i Makefile
	[ 0 -ne $? ] && return 1

	# build the package
	CC=$CC make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	mkdir -p $INSTALL_DIR/$BIN_DIR \
	         $INSTALL_DIR/$MAN_DIR/man1 \
	         $INSTALL_DIR/$MAN_DIR/es/man1
	[ 0 -ne $? ] && return 1
	make DESTDIR=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1

	return 0
}