#!/bin/bash
# translate JIS(CR+LF) -> utf-8(LF)
# delimiter csv(comma) -> ssv(space)

for file in *.csv
do
    nkf -Lu -w "$file" > "$file".tmp
    cat "${file}".tmp |awk -F"," '{print $1 " " $2}' > "${file/.csv/.dat}"
    rm "$file".tmp
done
