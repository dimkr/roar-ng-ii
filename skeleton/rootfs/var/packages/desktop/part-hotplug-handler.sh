PKG_NAME="part-hotplug-handler"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="A tool for monitoring partition addition and removal"
PKG_CAT="Utilities"
PKG_DEPS=""
PKG_LICENSE="custom"

# the Git branch to use
GIT_BRANCH="shahor"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 \
	          --branch $GIT_BRANCH \
	          git://github.com/iguleder/part-hotplug-handler.git \
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
	CFLAGS="$CFLAGS" make
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# install the package
	make PREFIX=$INSTALL_DIR/usr install
	[ 0 -ne $? ] && return 1

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	# install the license
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1

	# install the list of authors
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1

	return 0
}