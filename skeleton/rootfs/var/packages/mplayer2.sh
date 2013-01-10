#!/bin/sh

PKG_NAME="mplayer2"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="2"
PKG_DESC="Video player forked from MPlayer"
PKG_CAT="Multimedia"
PKG_DEPS="ncurses,alsa-lib,libpng,libjpeg,libgif,libmng,libvorbis,libtheora,libspeex,xvidcore,libmad,directfb,xorg_base,libav"

# the package source files
PKG_SRC=""

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 git://git.mplayer2.org/mplayer2.git $PKG_NAME-$PKG_VER
	[ 0 -ne $? ] && return 1

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
	            --bindir=/$BIN_DIR \
	            --datadir=/$SHARE_DIR/$PKG_NAME \
	            --mandir=/$MAN_DIR \
	            --confdir=/$CONF_DIR/$PKG_NAME \
	            --localedir=/$LOCALE_DIR \
	            --libdir=/$LIB_DIR \
	            --codecsdir=/$LIB_DIR/$PKG_NAME/codecs \
	            --enable-termcap \
	            --disable-termios \
	            --disable-langinfo \
	            --disable-lirc \
	            --disable-lircc \
	            --disable-joystick \
	            --disable-apple-remote \
	            --disable-apple-ir \
	            --enable-vm \
	            --enable-xf86keysym \
	            --disable-radio \
	            --disable-radio-capture \
	            --disable-radio-v4l2 \
	            --disable-radio-bsdbt848 \
	            --enable-tv \
	            --disable-tv-v4l1 \
	            --enable-tv-v4l2 \
	            --disable-tv-bsdbt848 \
	            --enable-pvr \
	            --enable-rtc \
	            --enable-networking \
	            --disable-winsock2_h \
	            --disable-smb \
	            --disable-libquvi \
	            --disable-lcms2 \
	            --disable-vcd \
	            --disable-bluray \
	            --disable-dvdnav \
	            --disable-dvdread \
	            --disable-dvdread-internal \
	            --disable-libdvdcss-internal \
	            --disable-cddb \
	            --disable-unrarexec \
	            --enable-sortsub \
	            --disable-enca \
	            --disable-macosx-finder \
	            --disable-macosx-bundle \
	            --enable-inet6 \
	            --enable-gethostbyname2 \
	            --disable-ftp \
	            --disable-vstream \
	            --enable-pthreads \
	            --disable-w32threads \
	            --disable-libass \
	            --enable-libpostproc \
	            --disable-libavresample \
	            --enable-gif \
	            --enable-png \
	            --enable-mng \
	            --enable-jpeg \
	            --disable-libcdio \
	            --disable-win32dll \
	            --disable-qtx \
	            --disable-xanim \
	            --disable-real \
	            --enable-xvid \
	            --disable-libnut \
	            --enable-libav \
	            --enable-libvorbis \
	            --disable-tremor \
	            --enable-speex \
	            --enable-theora \
	            --disable-faad \
	            --disable-ladspa \
	            --disable-libbs2b \
	            --disable-libdv \
	            --disable-mpg123 \
	            --enable-mad \
	            --disable-xmms \
	            --disable-libdca \
	            --disable-liba52 \
	            --disable-musepack \
	            --enable-gl \
	            --disable-sdl \
	            --disable-caca \
	            --disable-direct3d \
	            --disable-directx \
	            --enable-v4l2 \
	            --enable-dvb \
	            --disable-xv \
	            --enable-vdpau \
	            --enable-vm \
	            --enable-xinerama \
	            --enable-x11 \
	            --disable-xshape \
	            --disable-xss \
	            --enable-directfb \
	            --disable-tga \
	            --disable-pnm \
	            --disable-md5sum \
	            --disable-yuv4mpeg \
	            --disable-corevideo \
	            --disable-cocoa \
	            --disable-sharedbuffer \
	            --enable-alsa \
	            --disable-ossaudio \
	            --disable-rsound \
	            --disable-pulse \
	            --disable-portaudio \
	            --disable-jack \
	            --disable-openal \
	            --disable-coreaudio \
	            --disable-select \
	            --disable-translation \
	            --language-doc=en \
	            --language-man=en \
	            --language-msg=en \
	            --language=en \
	            --enable-runtime-cpudetection \
	            --cc="$CC" \
	            --disable-static \
	            --disable-debug \
	            --disable-profile \
	            --disable-sighandler \
	            --disable-crash-debug
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

	# install the sample configuration
	install -D -m 644 etc/codecs.conf $INSTALL_DIR/$CONF_DIR/$PKG_NAME/codecs.conf
	[ 0 -ne $? ] && return 1
	install -D -m 644 etc/input.conf $INSTALL_DIR/$CONF_DIR/$PKG_NAME/input.conf
	[ 0 -ne $? ] && return 1
	install -D -m 644 etc/example.conf $INSTALL_DIR/$CONF_DIR/$PKG_NAME/example.conf
	[ 0 -ne $? ] && return 1

	# install the list of authors and the copyright notice
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1
	install -D -m 644 Copyright $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/Copyright
	[ 0 -ne $? ] && return 1

	return 0
}
