PKG_NAME="terminus-font"
PKG_VER="4.38"
PKG_REV="2"
PKG_DESC="A monospace, bitmap font"
PKG_CAT="Artwork"
PKG_DEPS=""
PKG_LICENSE="custom"
PKG_ARCH="noarch"

# the package source files
PKG_SRC="http://sourceforge.net/projects/terminus-font/files/$PKG_NAME-$PKG_VER/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	chmod 755 configure
	[ 0 -ne $? ] && return 1
	./configure --prefix=/$BASE_INSTALL_PREFIX \
	            --x11dir=/$SHARE_DIR/fonts/misc \
	            --psfdir=/usr/share/consolefonts
	[ 0 -ne $? ] && return 1

	# if no X server is present, do not build X11 fonts
	if [ -z "$(which bdftopcf)" ]
	then
		sed -i s~'^PCF =.*'~'PCF ='~ Makefile
		[ 0 -ne $? ] && return 1
	fi

	# build the package
	make -j $BUILD_THREADS
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR install
	[ 0 -ne $? ] && return 1

	# install the license and the list of authors
	install -D -m 644 OFL.TXT $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/OFL.TXT
	[ 0 -ne $? ] && return 1
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	# add the post-installation script
	if [ -n "$(which mkfontscale)" ] && [ -n "$(which mkfontdir)" ]
	then
		echo "#!/bin/sh

mkfontscale ./$SHARE_DIR/fonts/misc
mkfontdir ./$SHARE_DIR/fonts/misc" > $INSTALL_DIR/$POST_INSTALL_SCRIPT_FILE_NAME
		[ 0 -ne $? ] && return 1
		chmod 755 $INSTALL_DIR/$POST_INSTALL_SCRIPT_FILE_NAME
		[ 0 -ne $? ] && return 1
	fi

	return 0
}