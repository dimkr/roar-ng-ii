#!/bin/sh

# remove the default X startup script
rm -f ./etc/X11/xinit/xinitrc

# create a /usr/share/X11/rgb.txt, a symlink to rgb.txt
[ ! -e ./usr/share/X11 ] && mkdir ./usr/share/X11
ln -s $(find . -name rgb.txt -type f | cut -b 2-) ./usr/share/X11/rgb.txt

# disable bitmap fonts
[ -e ./etc/fonts/conf.avail/70-no-bitmaps.conf ] && \
                       ln -s ../conf.avail/70-no-bitmaps.conf ./etc/fonts/conf.d