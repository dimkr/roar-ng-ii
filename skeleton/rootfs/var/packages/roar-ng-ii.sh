#!/bin/sh

PKG_NAME="roar-ng-ii"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="A GNU/Linux distribution building system"
PKG_CAT="Develop"
PKG_DEPS=""
PKG_ARCH="noarch"

# the package source files
PKG_SRC=""

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 \
	          git://github.com/iguleder/roar-ng-ii.git \
	          $PKG_NAME-$PKG_VER
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

	return 0
}

package() {
	# create the installation directories
	mkdir -p $INSTALL_DIR/$SHARE_DIR/roar-ng
	[ 0 -ne $? ] && return 1

	# install roar-ng
	install -D -m 755 roar-ng $INSTALL_DIR/$BIN_DIR/roar-ng
	[ 0 -ne $? ] && return 1

	# install the configuration
	install -D -m 644 roar-ng.conf $INSTALL_DIR/$CONF_DIR/roar-ng.conf
	[ 0 -ne $? ] && return 1

	# install plug-ins, skeletons and support files
	for i in distro media package-templates skeleton
	do
		cp -ar $i $INSTALL_DIR/$SHARE_DIR/roar-ng
		[ 0 -ne $? ] && return 1
	done

	# install the README
	install -D -m 644 README $INSTALL_DIR/$DOC_DIR/$PKG_NAME/README
	[ 0 -ne $? ] && return 1

	return 0
}
