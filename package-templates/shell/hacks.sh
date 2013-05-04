#!/bin/sh

# ensure /bin/sh points to DASH
if [ -e ./bin/sh ]
then
	[ ! -e ./bin/dash ] && rm -f ./bin/sh
else
	[ -e ./bin/dash ] && ln -s dash ./bin/sh
fi