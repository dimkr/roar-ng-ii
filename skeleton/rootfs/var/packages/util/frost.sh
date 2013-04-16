PKG_NAME="frost"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="A simple suspend tool"
PKG_CAT="Utilities"
PKG_DEPS=""
PKG_LICENSE="custom"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 \
	          git://github.com/iguleder/frost.git \
	          $PKG_NAME-$PKG_VER
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

	# build the package
	make CFLAGS="$CFLAGS"
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make PREFIX=$INSTALL_DIR/usr install
	[ 0 -ne $? ] && return 1

	return 0
}