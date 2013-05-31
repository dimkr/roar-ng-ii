PKG_NAME="xine-lib"
PKG_VER="1.2.3"
PKG_REV="1"
PKG_DESC="A multimedia playback engine"
PKG_CAT="Multimedia"
PKG_DEPS="libogg,flac,libmad,libjpeg,xorg_base,ffmpeg"
PKG_LICENSE="gpl-2.0.txt,lgpl-2.0.txt"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/xine/$PKG_NAME/$PKG_VER/$PKG_NAME-$PKG_VER.tar.xz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# prevent additional compiler flags from being added
	sed -e s~'^O3_CFLAGS=.*'~'O3_CFLAGS=""'~ \
	    -e s~'^O2_CFLAGS=.*'~'O1_CFLAGS=""'~ \
	    -e s~'^O1_CFLAGS=.*'~'O2_CFLAGS=""'~ \
	    -e s~'^O0_CFLAGS=.*'~'O0_CFLAGS=""'~ \
	    -i configure
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-debug \
	            --disable-profiling \
	            --enable-ipv6 \
	            --disable-antialiasing \
	            --disable-macosx-universal \
	            --disable-static \
	            --enable-shared \
	            --disable-optimizations \
	            --disable-mmap \
	            --disable-coreaudio \
	            --disable-irixal \
	            --disable-oss \
	            --disable-sunaudio \
	            --disable-sndio \
	            --disable-aalib \
	            --disable-dha-kmod \
	            --disable-directfb \
	            --disable-dxr3 \
	            --disable-fb \
	            --disable-macosx-video \
	            --disable-opengl \
	            --disable-glu \
	            --disable-vidix \
	            --enable-xinerama \
	            --disable-static-xv \
	            --enable-xvmc \
	            --enable-dvb \
	            --disable-gnomevfs \
	            --disable-samba \
	            --disable-v4l \
	            --enable-v4l2 \
	            --disable-libv4l \
	            --disable-vcd \
	            --disable-vdr \
	            --disable-bluray \
	            --disable-a52dec \
	            --disable-asf \
	            --disable-gdkpixbuf \
	            --enable-libjpeg \
	            --disable-dts \
	            --enable-mad \
	            --disable-modplug \
	            --disable-libmpeg2new \
	            --disable-musepack \
	            --disable-mlib \
	            --disable-mlib-lazyload \
	            --disable-mng \
	            --disable-real-codecs \
	            --disable-w32dll \
	            --with-freetype \
	            --with-fontconfig \
	            --with-x \
	            --with-alsa \
	            --without-esound \
	            --without-fusionsound \
	            --without-jack \
	            --without-pulseaudio \
	            --without-caca \
	            --without-dxheaders \
	            --without-libstk \
	            --without-sdl \
	            --with-xcb \
	            --without-imagemagick \
	            --with-libflac \
	            --without-speex \
	            --with-theora \
	            --with-vorbis \
	            --without-wavpack
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

	# remove the license copy
	rm -f $INSTALL_DIR/$DOC_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	ln -s /$LEGAL_DIR/$PKG_NAME/gpl-2.0.txt \
	      $INSTALL_DIR/$DOC_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1

	# create a symlink to the list of authors
	mkdir -p $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1
	ln -s /$DOC_DIR/$PKG_NAME/CREDITS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/CREDITS
	[ 0 -ne $? ] && return 1
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}