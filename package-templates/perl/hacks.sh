#!/bin/sh

# under Debian and derivatives, Perl modules are placed under
# /usr/lib/perl/$minor_version, while /usr/lib/perl/$major_version is a symlink
# to this directory; this is bad because external modules (e.g Irssi's) are
# placed in a directory named after the minor version, thus preventing these
# modules from being copied to the root file system
if [ -d ./usr/lib/perl ]
then
	# determine the package version
	for module_dir in ./usr/lib/perl/*
	do
		if [ -h "$module_dir" ]
		then
			major_version="$(basename "$module_dir")"
		else
			[ -d "$module_dir" ] && minor_version="$(basename "$module_dir")"
		fi
	done

	# remove the major version symlink - this symlink points to a directory
	# named after the minor version
	rm -f ./usr/lib/perl/$major_version

	# move the minor version directory to a directory named after the removed
	# symlink
	mv ./usr/lib/perl/$minor_version ./usr/lib/perl/$major_version

	# create a link, in the opposite direction
	ln -s $major_version ./usr/lib/perl/$minor_version
fi