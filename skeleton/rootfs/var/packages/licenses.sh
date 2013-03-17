#!/bin/sh

PKG_NAME="licenses"
PKG_VER="1"
PKG_REV="2"
PKG_DESC="The text of various free software licenses"
PKG_CAT="Help"
PKG_DEPS=""
PKG_LICENSE="custom"
PKG_ARCH="noarch"

# the package source files
PKG_SRC=""

# license files to download
LICENSES="http://www.gnu.org/licenses/gpl-3.0.txt
          http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
          http://www.gnu.org/licenses/lgpl-3.0.txt
          http://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
          http://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt
          http://www.gnu.org/licenses/fdl-1.2.txt
          http://www.gnu.org/licenses/fdl-1.3.txt
          http://www.gnu.org/licenses/old-licenses/fdl-1.2.txt
          http://www.gnu.org/licenses/old-licenses/fdl-1.1.txt
          http://www.debian.org/misc/bsd.license,bsd.txt
          http://www.apache.org/licenses/LICENSE-2.0.txt,apache-2.0.txt
          http://www.mozilla.org/MPL/2.0/index.txt,mpl-2.0.txt"


download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# create a directory for all files
	mkdir $PKG_NAME-$PKG_VER
	[ 0 -ne $? ] && return 1

	# download all license files
	for license in $LICENSES
	do
		case "$license" in
			*,*)
				file_name="${license#*,}"
				url="${license%,*}"
				;;

			*)
				file_name="${license##*/}"
				url="$license"
				;;
		esac

		download_file "$url" "$PKG_NAME-$PKG_VER/$file_name"
		[ 0 -ne $? ] && return 1
	done

	# create a tarball from the directory
	make_tarball_and_delete $PKG_NAME-$PKG_VER $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	return 0
}

build() {
	# extract the sources tarball
	extract_tarball $PKG_NAME-$PKG_VER.tar.xz
	[ 0 -ne $? ] && return 1

	cd $PKG_NAME-$PKG_VER

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
