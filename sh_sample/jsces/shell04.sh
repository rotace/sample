#!/bin/sh

for name in *.txt ; do
    echo 'Source full name    :' ${name}
    mn=`echo ${name} | sed "s/\([^.]\+\)\(.[^.]\+\)$/\1/"`
    nn=`echo ${name} | sed "s/\([^.]\+\)\(.[^.]\+\)$/\2/"`
    echo 'Extracted file name :' ${mn}
    echo 'Extracted extension :' ${nn}
    echo
done
