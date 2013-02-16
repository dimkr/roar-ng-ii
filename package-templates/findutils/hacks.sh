#!/bin/sh

# for each findutils tool present in the package with the ".findutils" suffix,
# create a symlink with the original name; this happens on Debian, in order to
# make it possible to provide multiple implementations for some tools
for i in ./usr/bin/*.findutils
do
	name="${i##*/}"
	ln -s $name ./usr/bin/${name%.findutils}
done