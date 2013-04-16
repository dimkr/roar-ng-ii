PKG_NAME="deadbeef"
PKG_VER="0.5.6"
PKG_REV="1"
PKG_DESC="A music player"
PKG_CAT="Multimedia"
PKG_DEPS="gtk,libvorbis,flac,libmad"
PKG_LICENSE="gpl-2.0.txt,lgpl-2.1.txt"

# the package source files
PKG_SRC="http://downloads.sourceforge.net/project/$PKG_NAME/$PKG_NAME-$PKG_VER.tar.bz2"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.bz2
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --enable-shared \
	            --disable-static \
	            --enable-threads=posix \
	            --disable-nullout \
	            --enable-alsa \
	            --disable-oss \
	            --disable-pulse \
	            --disable-gtk3 \
	            --enable-gtk2 \
	            --disable-vfs-curl \
	            --disable-lfm \
	            --disable-artwork \
	            --disable-supereq \
	            --disable-sid \
	            --enable-mad \
	            --disable-ffap \
	            --disable-vtx \
	            --disable-adplug \
	            --disable-hotkeys \
	            --enable-vorbis \
	            --disable-ffmpeg \
	            --enable-flac \
	            --disable-sndfile \
	            --disable-wavpack \
	            --disable-cdda \
	            --disable-gme \
	            --disable-notify \
	            --disable-shellexec \
	            --disable-musepack \
	            --disable-wildmidi \
	            --disable-tta \
	            --disable-dca \
	            --disable-aac \
	            --disable-mms \
	            --disable-staticlink \
	            --enable-portable=no \
	            --disable-src \
	            --disable-m3u \
	            --disable-vfs-zip \
	            --disable-converter \
	            --disable-artwork-imlib2 \
	            --disable-dumb \
	            --disable-shn \
	            --disable-psf \
	            --disable-mono2stereo \
	            --disable-shellexecui \
	            --disable-alac \
	            --disable-abstract-socket
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