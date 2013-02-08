#!/bin/sh

PKG_NAME="libav"
PKG_VER="0.8-git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="Complete audio and video conversion, recording and streaming solution forked from FFmpeg"
PKG_CAT="Multimedia"
PKG_DEPS="libvorbis,libogg,libtheora"
PKG_LICENSE="gpl-3.0.txt"

# the package source files
PKG_SRC=""

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone git://git.libav.org/libav.git $PKG_NAME-$PKG_VER
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# switch to the stable branch
	git checkout release/0.8
	[ 0 -ne $? ] && return 1

	cd ..

	# create a sources tarball
	make_tarball_and_delete $PKG_NAME-$PKG_VER $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure --prefix=/$BASE_INSTALL_PREFIX \
	            --libdir=/$LIB_DIR \
	            --shlibdir=/$LIB_DIR \
	            --disable-static \
	            --enable-shared \
	            --enable-gpl \
	            --disable-nonfree \
	            --enable-avconv \
	            --disable-ffmpeg \
	            --disable-avplay \
	            --disable-avserver \
	            --enable-postproc \
	            --enable-x11grab \
	            --disable-network \
	            --enable-pthreads \
	            --enable-small \
	            --enable-gnutls \
	            --enable-libtheora \
	            --enable-libvorbis \
	            --disable-runtime-cpudetect \
	            --disable-hardcoded-tables \
	            --disable-devices \
	            --arch=$PKG_ARCH \
	            --cpu=$PKG_CPU \
	            --disable-symver \
	            --disable-debug
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

	# create a FFmpeg backwards-compatibility symlink
	ln -s avconv $INSTALL_DIR/$BIN_DIR/ffmpeg
	[ 0 -ne $? ] && return 1

	# install the license and the list of contributors
	install -D -m 644 LICENSE $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE
	[ 0 -ne $? ] && return 1
	install -D -m 644 CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1

	return 0
}
