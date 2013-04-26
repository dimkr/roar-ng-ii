#!/bin/sh

# in Debian, the netcat executable is /bin/nc.openbsd
if [ -e ./bin/nc.openbsd ] && [ ! -e ./usr/bin/nc ]
then
	mkdir -p ./usr/bin
	ln -s ../../bin/nc.openbsd ./usr/bin/nc
fi