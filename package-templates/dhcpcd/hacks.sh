#!/bin/dash

# Debian calls the daemon executable "dhcpcd5" - create a symlink
if [ -f ./sbin/dhcpcd5 ] && [ ! -e ./sbin/dhcpcd ]
then
	ln -s dhcpcd5 ./sbin/dhcpcd
fi