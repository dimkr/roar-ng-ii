#!/bin/sh

# in Debian, the default configuration file is named cupsd.conf.default, but the
# required cupsd.conf is missing
if [ -e ./etc/cups/cupsd.conf.default ] && [ ! -e ./etc/cups/cupsd.conf ]
then
	mv ./etc/cups/cupsd.conf.default ./etc/cups/cupsd.conf
fi