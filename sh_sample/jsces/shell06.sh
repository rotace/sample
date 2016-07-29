#!/bin/sh

alias e='echo ==============='
sh cfile.sh >/dev/null 2>&1
\ls *.txt
conuter=0
for name in *.txt ;do
    let ++counter
    bnam=`echo ${name} | \
        sed "s/\([^.]\)\([^.]\+\)\(.[^.]\+\)$/\U\1\E\2/"`
    exte=`echo ${name} | \
        sed "s/\([^.]\+\)\(.[^.]\+\)$/\2/"`
    nstr=`printf "%s_%05d%s" ${bnam} ${counter} ${exte}`
    echo 'Source file name     :' ${name}
    echo 'Modified file name   :' ${nstr}
    e
    mv ${name} ${nstr}
done
\ls *.txt
