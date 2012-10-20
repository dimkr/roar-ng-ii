#!/bin/dash

# ~/.xinitrc: a startup script for the X server
# dependencies: dash, xsetroot and cwm

# set the desktop background
xsetroot -solid \#333333

# start the rxvt-unicode daemon
urxvtd -q -f -o

# execute the window manager
exec cwm
