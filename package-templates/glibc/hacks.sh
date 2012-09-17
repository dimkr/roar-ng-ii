#!/bin/sh

# on 64-bit systems, link /usr/lib/locale to /usr/lib64/locale, since locale-gen
# always uses this path
if [ -e ./usr/lib64/locale ] && [ ! -e ./usr/lib/locale ]
then
	[ ! -e ./usr/lib ] && mkdir ./usr/lib
	ln -s ../lib64/locale ./usr/lib/locale
fi

# remove all generated locales
rm -rf ./usr/lib/locale/*
