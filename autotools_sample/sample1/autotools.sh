#!/bin/bash
touch INSTALL NEWS README COPYING AUTHORS ChangeLog
autoheader
aclocal
automake --add-missing --copy
autoconf
