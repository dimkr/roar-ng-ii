#!/bin/sh

# ensure /usr/bin/less exists, since PAGER uses the full path
if [ ! -e ./usr/bin/less ] && [ -e ./bin/less ]
then
	mkdir -p ./usr/bin
	ln -s ../../bin/less ./usr/bin/less
fi