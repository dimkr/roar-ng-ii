#!/bin/sh

# create /etc/ca-certificates.conf, a list of all certificates
if [ ! -f ./etc/ca-certificates.conf ]
then
	find ./usr/share/ca-certificates -type f | \
	cut -f 5- -d / > ./etc/ca-certificates.conf
fi