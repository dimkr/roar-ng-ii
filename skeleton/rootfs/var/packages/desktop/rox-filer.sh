PKG_NAME="rox-filer"
PKG_VER="git$(date +%d%m%Y)"
PKG_REV="1"
PKG_DESC="A file manager"
PKG_CAT="Desktop"
PKG_DEPS="dash,gtk,libxml2-utils,xsltproc"
PKG_LICENSE="gpl-2.0.txt"

download() {
	[ -f $PKG_NAME-$PKG_VER.tar.xz ] && return 0

	# download the sources
	git clone --depth 1 git://repo.or.cz/rox-filer.git $PKG_NAME-$PKG_VER
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

	# prevent the building process from blocking upon failure
	sed s~'read WAIT'~''~ -i ROX-Filer/AppRun
	[ 0 -ne $? ] && return 1

	# build the package
	./ROX-Filer/AppRun --compile
	[ 0 -ne $? ] && return 1

	return 0
}

package() {
	# remove the source code and files generated using the building process
	rm -rf ROX-Filer/build ROX-Filer/src ROX-Filer/ROX-Filer.dbg
	[ 0 -ne $? ] && return 1

	# remove the license file; a symlink to it will be created under $LEGAL_DIR
	rm -f ROX-Filer/Help/COPYING
	[ 0 -ne $? ] && return 1

	# install the package
	mkdir -p $INSTALL_DIR/$BIN_DIR \
	         $INSTALL_DIR/$LIB_DIR \
	         $INSTALL_DIR/$SHARE_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1
	cp -r ROX-Filer $INSTALL_DIR/$LIB_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1
	cp -r Choices $INSTALL_DIR/$SHARE_DIR
	[ 0 -ne $? ] && return 1

	# move architecture-independent data to $SHARE_DIR/$PKG_NAME
	for i in Help images Messages
	do
		mv $INSTALL_DIR/$LIB_DIR/$PKG_NAME/$i \
		   $INSTALL_DIR/$SHARE_DIR/$PKG_NAME/$i
		[ 0 -ne $? ] && return 1
		ln -s /$SHARE_DIR/$PKG_NAME/$i $INSTALL_DIR/$LIB_DIR/$PKG_NAME/$i
		[ 0 -ne $? ] && return 1
	done

	# create a symlink under $BIN_DIR
	echo -n "#!/bin/dash
args=\"\$@\"
[ -z \"\$args\" ] && args=\"~\"
/$LIB_DIR/$PKG_NAME/AppRun \"\$@\" &" > $INSTALL_DIR/$BIN_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1
	chmod 755 $INSTALL_DIR/$BIN_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1

	return 0
}