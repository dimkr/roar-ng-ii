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
PKG_SRC="http://www.gnu.org/licenses/gpl-3.0.txt
         http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
         http://www.gnu.org/licenses/lgpl-3.0.txt
         http://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
         http://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt
         http://www.gnu.org/licenses/fdl-1.3.txt
         http://www.gnu.org/licenses/old-licenses/fdl-1.2.txt
         http://www.gnu.org/licenses/old-licenses/fdl-1.1.txt
         http://www.debian.org/misc/bsd.license
         http://www.apache.org/licenses/LICENSE-2.0.txt
         http://www.mozilla.org/MPL/2.0/index.txt"

# files to rename
RENAME_RULES="bsd.license,bsd.txt
              LICENSE-2.0.txt,apache-2.0.txt
              index.txt,mpl-2.0.txt"

download() {
	# create a directory for all files
	mkdir $PKG_NAME-$PKG_VER
	[ 0 -ne $? ] && return 1

	# move all files to the directory; rename those which have a non-descriptive
	# name
	for url in $PKG_SRC
	do
		file_name="${url##*/}"
		target_name="$file_name"
		for rule in $RENAME_RULES
		do
			if [ "${rule%,*}" = "$file_name" ]
			then
				target_name="${rule#*,}"
				break
			fi
		done

		mv "$file_name" "$PKG_NAME-$PKG_VER/$target_name"
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
