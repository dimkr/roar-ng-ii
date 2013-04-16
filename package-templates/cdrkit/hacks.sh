#!/bin/dash

# create mkisofs, a symlink to genisoimage - it is needed under distributions
# which consider it to be deprecated
if [ -z "$(find . -name mkisofs -type f)" ]
then
	genisoimage_path="$(find . -name genisoimage -type f)"
	[ -n "$genisoimage_path" ] && \
	                          ln -s genisoimage "${genisoimage_path%/*}"/mkisofs
fi