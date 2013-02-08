#!/bin/sh

PKG_NAME="licenses"
PKG_VER="1"
PKG_REV="1"
PKG_DESC="The text of various free software licenses"
PKG_CAT="Help"
PKG_DEPS=""
PKG_LICENSE="custom"
PKG_ARCH="noarch"

# the package source files
PKG_SRC="http://www.gnu.org/licenses/gpl-3.0.txt
         http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
         http://www.gnu.org/licenses/lgpl-3.0.txt
         http://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
         http://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt
         http://www.gnu.org/licenses/fdl-1.3.txt
         http://www.gnu.org/licenses/old-licenses/fdl-1.2.txt
         http://www.gnu.org/licenses/old-licenses/fdl-1.1.txt
         http://www.debian.org/misc/bsd.license
         http://www.apache.org/licenses/LICENSE-2.0.txt"

download() {
	return 0
}

build() {
	return 0
}

package() {
	# install all licenses
	mkdir -p $INSTALL_DIR/$COMMON_LICENSES_DIR
	[ 0 -ne $? ] && return 1
	install -m 644 * $INSTALL_DIR/$COMMON_LICENSES_DIR
	[ 0 -ne $? ] && return 1

	return 0
}
