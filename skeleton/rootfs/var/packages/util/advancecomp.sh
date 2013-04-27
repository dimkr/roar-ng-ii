PKG_NAME="advancecomp"
PKG_VER="1.17"
PKG_REV="1"
PKG_DESC="Recompression utilities"
PKG_CAT="Utilities"
PKG_DEPS="zlib,bzip2"
PKG_LICENSE="gpl-3.0.txt"

# the package source files
PKG_SRC="http://prdownloads.sourceforge.net/advancemame/$PKG_NAME-$PKG_VER.tar.gz"

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.gz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# fix two syntax errors that prevents the package from building with bzip2
	# support
	sed -e s~'(level != shrink_fast'~'(level.level != shrink_fast'~ \
	    -e s~'switch (level)'~'switch (level.level)'~ \
	    -i zipsh.cc
	[ 0 -ne $? ] && return 1

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS --enable-bzip2
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