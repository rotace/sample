#!/bin/bash
\rm  -f *.txt
for n in sample1.txt sample1A.txt sample1A1.txt \
    sampleAA.txt sample_A.txt
do
    touch ${n}
done

cat > data.txt <<EOF
First Name, Family Name, Initial,ID $,Year

JOHN,ABC,-,25,2011
ROBERT,DEF,-,35,2000
JOHN,GHI,-,42,1998
end
EOF
