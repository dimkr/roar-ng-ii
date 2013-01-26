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
	make_tarball_and_delete $PKG_NAME-$PKG_VER $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

	# remove .gitignore files
	find . -name .gitignore -delete
	[ 0 -ne $? ] && return 1

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
	install -D -m 644 roar-ng.conf $INSTALL_DIR/$CONF_DIR/roar-ng/roar-ng.conf
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

	# install the license and the list of authors
	install -D -m 644 COPYING $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/COPYING
	[ 0 -ne $? ] && return 1
	install -D -m 644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ 0 -ne $? ] && return 1
	install -D -m 644 THANKS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/THANKS
	[ 0 -ne $? ] && return 1

	return 0
}
