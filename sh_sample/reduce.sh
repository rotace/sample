#!/bin/bash
# reduce number
# reserve only every 400 
nbr=0
for f in *.flow
do
numf=${f%.flow}
numf=${numf#3d}
# echo "$numf,$nbr"
if [ $numf -ne $nbr ];then
echo "remove $f"
rm $f
fi
if [ $numf -eq $nbr ];then
echo "reserve $f"
nbr=$(($nbr+400))
fi
done
