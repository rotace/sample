#!/bin/sh
for name in * ;do
    ext=`echo ${name} | awk -F . \
        '{ n=split($0,e); if(n==1) print ""; \
        else print "."e[n]; }'`
    bnm=`basename ${name} ${ext}`
    nwm=`ls -g \
        --time-style="+%Y.%m.%d-%H:%M:%S %N" \
        ${name} | \
        awk '{ printf "%s.%s\n",$5,substr($6,1,3) }'`
    echo cp -i ${name} ${nwm}-${bnm}${ext}
done
