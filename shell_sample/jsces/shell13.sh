#!/bin/sh

\rm -f gA*.png graph.gif gA*.gp
cat > gp.gp <<EOF
set terminal png size MWS,MHS enhanced font 'verdana,20'
set output MN
set size ratio 0.67
set samples 2000
set grid
set xrange [-2*pi:2*pi]
set yrange [-1.2:1.2]
set xtics ('-2{/Symbol p}' -2*pi, '-{/Symbol p}'  -pi, 0, \
             '{/Symbol p}'    pi, '2{/Symbol p}' 2*pi)
set title "sin(MA*x) curves"
plot sin(MA*x) w l lw ML
EOF
WSIZE=900
HSIZE=600
LWIDTH=2
OA=0.1
for i in $(seq 1 100); do
    T=`echo ${i}*${OA} | bc -l`
    A=`printf "%05.2f" ${T}`
    N=gA${A}
    echo ${N}
    sed -e "s/MA/${A}/g" \
	-e "s/MWS/${WSIZE}/g"  \
	-e "s/MHS/${HSIZE}/g"  \
	-e "s/ML/${LWIDTH}/g"  \
	-e "s/MN/\"${N}.png\"/g" < gp.gp > ${N}.gp
    gnuplot ${N}.gp
done
convert -geometry 50% -loop 0 -delay 5 gA*.png graph.gif

