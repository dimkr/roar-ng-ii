PKG_NAME="linux-headers"
PKG_VER="3.2"
PKG_REV="43"
PKG_DESC="API headers of the Linux kernel, with Linux-libre modifications and Aufs"
PKG_CAT="Development"
PKG_DEPS="perl,linux-source"
PKG_LICENSE="custom"
PKG_ARCH="noarch"

package() {
	cd /$SOURCE_DIR/linux

	# install the kernel API headers
	make INSTALL_HDR_PATH=$INSTALL_DIR/$BASE_INSTALL_PREFIX headers_install
	[ 0 -ne $? ] && return 1

	# remove unneeded files from the kernel headers installation
	find $INSTALL_DIR/$BASE_INSTALL_PREFIX -name .install -or \
	                                       -name ..install.cmd | xargs rm -f
	[ 0 -ne $? ] && return 1

	# link the legal information directory to the kernel package's, since both
	# packages share the same source
	mkdir -p $INSTALL_DIR/$LEGAL_DIR
	[ 0 -ne $? ] && return 1
	ln -s linux $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME
	[ 0 -ne $? ] && return 1

	return 0
}