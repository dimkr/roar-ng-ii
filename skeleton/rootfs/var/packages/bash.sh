#!/bin/sh

PKG_NAME="bash"
PKG_VER="4.2.042"
PKG_REV="1"
PKG_DESC="A sh-compatible shell"
PKG_CAT="BuildingBlock"
PKG_DEPS=""

# the package source files
PKG_SRC="http://ftp.gnu.org/gnu/$PKG_NAME/$PKG_NAME-$PKG_MAJOR_VER.tar.gz"

# the package major version
PKG_MAJOR_VER="$(echo $PKG_VER | cut -f 1-2 -d .)"

# the patch version
PKG_PATCH_VER="$(echo $PKG_VER | cut -f 3 -d .)"

download() {
	[ -f $PKG_NAME-$PKG_MAJOR_VER.001-$PKG_PATCH_VER.tar.xz ] && return 0

	# create a directory for the patches
	mkdir $PKG_NAME-$PKG_MAJOR_VER.001-$PKG_PATCH_VER
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_MAJOR_VER.001-$PKG_PATCH_VER

	# download the patches
	for i in $(seq -w $PKG_PATCH_VER)
	do
		file_name="$PKG_NAME$(echo $PKG_MAJOR_VER | sed s/'\.'//g)"-$i
		[ -f "$file_name" ] && continue
		download_file http://ftp.gnu.org/gnu/$PKG_NAME/$PKG_NAME-$PKG_MAJOR_VER-patches/$file_name
		[ 0 -ne $? ] && return 1
	done

	cd ..

	# create a patches tarball
	make_tarball_and_delete $PKG_NAME-$PKG_MAJOR_VER.001-$PKG_PATCH_VER $PKG_NAME-$PKG_MAJOR_VER.001-$PKG_PATCH_VER.tar.xz
	[ 0 -ne $? ] && return 1

	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_MAJOR_VER.tar.gz
	[ 0 -ne $? ] && return 1

	# extract the patches tarball
	extract_tarball $PKG_NAME-$PKG_MAJOR_VER.001-$PKG_PATCH_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_MAJOR_VER

	# apply all patches
	for i in $(seq -w $PKG_PATCH_VER)
	do
		file_name="$PKG_NAME$(echo $PKG_MAJOR_VER | sed s/'\.'//g)"-$i
		patch -p0 < ../$PKG_NAME-$PKG_MAJOR_VER.001-$PKG_PATCH_VER/$file_name
		[ 0 -ne $? ] && return 1
	done

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-debugger \
	            --disable-help-builtin \
	            --enable-multibyte \
	            --disable-restricted \
	            --enable-single-help-strings \
	            --disable-mem-scramble \
	            --disable-profiling \
	            --disable-static-link \
	            --without-afs \
	            --without-bash-malloc \
	            --with-curses \
	            --without-installed-readline
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

	# create backwards-compatibility symlinks
	if [ "bin" != "$BIN_DIR" ]
	then
		mkdir $INSTALL_DIR/bin
		[ 0 -ne $? ] && return 1
		ln -s ../$BIN_DIR/bash $INSTALL_DIR/bin/bash
		[ 0 -ne $? ] && return 1
	fi

	if [ "usr/bin" != "$BIN_DIR" ]
	then
		mkdir -p $INSTALL_DIR/usr/bin
		[ 0 -ne $? ] && return 1
		ln -s ../../$BIN_DIR/bash $INSTALL_DIR/usr/bin/bash
		[ 0 -ne $? ] && return 1
	fi

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}
