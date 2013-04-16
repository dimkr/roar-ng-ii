PKG_NAME="ffmpeg"
PKG_VER="1.2"
PKG_REV="1"
PKG_DESC="Complete audio and video conversion, recording and streaming solution forked from FFmpeg"
PKG_CAT="Multimedia"
PKG_DEPS="gnutls,libvorbis,libogg,libtheora,flac,xorg_base"
PKG_LICENSE="gpl-3.0.txt,custom"

# the package source files
PKG_SRC="http://ffmpeg.org/releases/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# prevent extra compiler flags from being added
	sed s~'=\$_cflags_speed'~'='~ -i configure
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure --prefix=/$BASE_INSTALL_PREFIX \
	            --bindir=/$BIN_DIR \
	            --datadir=/$SHARE_DIR/$PKG_NAME \
	            --libdir=/$LIB_DIR \
	            --shlibdir=/$LIB_DIR \
	            --incdir=/$INCLUDE_DIR \
	            --mandir=/$MAN_DIR \
	            --enable-gpl \
	            --enable-version3 \
	            --disable-nonfree \
	            --disable-static \
	            --enable-shared \
	            --disable-small \
	            --enable-runtime-cpudetect \
	            --disable-gray \
	            --disable-swscale-alpha \
	            --disable-ffplay \
	            --enable-gnutls \
	            --enable-libfreetype \
	            --disable-libpulse \
	            --disable-openssl \
	            --enable-x11grab \
	            --cc="$CC" \
	            --extra-cflags="$CFLAGS" \
	            --extra-cxxflags="$CXXFLAGS" \
	            --extra-ldflags="$LDFLAGS" \
	            --arch="$PKG_ARCH" \
	            --cpu="$PKG_CPU" \
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
	make DESTDIR=$INSTALL_DIR \
	         install install-man
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	# install the license
	install -D -m 644 LICENSE $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/LICENSE
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1

	return 0
}