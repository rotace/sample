#!/bin/sh

\rm -f gA*.png graph.png gA*.gp
cat > gp.gp <<EOF
set terminal png size MS,MS enhanced font 'verdana,20'
set output MN
set size square
set grid
set xrange [-2*pi:2*pi]
set yrange [-1.2:1.2]
set xtics ('-2{/Symbol p}' -2*pi, '-{/Symbol p}'  -pi, 0, \
             '{/Symbol p}'    pi, '2{/Symbol p}' 2*pi)
set title "sin(MA*x) and cos(MB*x) curves"
plot sin(MA*x) w l lw ML, cos(MB*x) w l lw ML
EOF
SIZE=650
LWIDTH=3
A=("0.10" "0.40" "0.80" "1.60")
B=("0.50" "1.00" "1.25" "1.50")
for i in 0 1 2 3; do
    N=gA${A[${i}]}-B${B[${i}]}
    echo ${A[${i}]} ${B[${i}]} ${N}
    sed -e "s/MA/${A[${i}]}/g" \
	-e "s/MB/${B[${i}]}/g" \
	-e "s/MS/${SIZE}/g"    \
	-e "s/ML/${LWIDTH}/g"  \
	-e "s/MN/\"${N}.png\"/g" < gp.gp > ${N}.gp
    gnuplot ${N}.gp
done
montage gA*.png -tile 2x2 \
    -geometry ${SIZE}x${SIZE} graph.png
