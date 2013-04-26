#!/bin/sh

# in Debian, the yacc executable is /usr/bin/bison.yacc
if [ -e /usr/bin/bison.yacc ] && [ ! -e ./usr/bin/yacc ]
then
	ln -s bison.yacc ./usr/bin/yacc
fi