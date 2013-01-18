#!/bin/sh

# if /usr/share/kbd doesn't exist, create a symlink to /usr/share/consolefonts
if [ -e ./usr/share/consolefonts ] && [ ! -e ./usr/share/kbd/consolefonts ]
then
	mkdir -p ./usr/share/kbd
	ln -s ../consolefonts ./usr/share/kbd/consolefonts
fi
