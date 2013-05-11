#!/bin/sh

SHELLS="bash busybox dash"

# ensure /bin/sh points to the the top-priority shell
if [ -e ./bin/sh ]
then
	rm -f ./bin/sh
else
	[ ! -d ./bin ] && mkdir ./bin
fi

for shell in $SHELLS
do
	[ ! -e ./bin/$shell ] && continue
	ln -s $shell ./bin/sh
	break
done