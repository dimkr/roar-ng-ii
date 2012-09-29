#!/bin/sh

PKG_NAME="vim"
PKG_VER="hg$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="Improved implementation of the vi text editor"
PKG_CAT="Document"
PKG_DEPS="+ncurses,+gpm"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	hg clone https://vim.googlecode.com/hg/ $PKG_NAME-$PKG_VER
	[ 0 -ne $? ] && return 1

	# create a sources tarball
	tar -c $PKG_NAME-$PKG_VER | xz -9 -e > $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	# clean up
	rm -rf $PKG_NAME-$PKG_VER
	[ 0 -ne $? ] && return 1

	return 0
}

build() {
	# extract the sources tarball
	tar -xJvf $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# set the location of the vimrc file
	echo "#define SYS_VIMRC_FILE \"/$CONF_DIR/vimrc\"" >> src/feature.h
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-darwin \
	            --disable-selinux \
	            --disable-xsmp \
	            --disable-xsmp-interact \
	            --enable-luainterp=no \
	            --disable-mzschemeinterp \
	            --enable-perlinterp=no \
	            --enable-pythoninterp=no \
	            --enable-python3interp=no \
	            --disable-tclinterp \
	            --disable-rubyinterp \
	            --disable-cscope \
	            --disable-workshop \
	            --disable-netbeans \
	            --disable-sniff \
	            --enable-multibyte \
	            --disable-hangulinput \
	            --disable-xim \
	            --disable-fontset \
	            --enable-gui=no \
	            --disable-gtk2-check \
	            --disable-gnome-check \
	            --disable-motif-check \
	            --disable-athena-check \
	            --disable-nextaw-check \
	            --disable-carbon-check \
	            --disable-acl \
	            --enable-gpm \
	            --disable-sysmouse \
	            --with-features=normal \
	            --without-x \
	            --without-gnome
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
	install -D -m 644 runtime/doc/uganda.txt $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/uganda.txt
	[ 0 -ne $? ] && return 1

	return 0
}
