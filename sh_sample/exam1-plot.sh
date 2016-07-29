#!/bin/bash

### variable setting ###
itrs=1
itre=3200000
eve="every ::${itrs}::${itre}"
dimx="((-600-\$2)/1000)"

### time-average ###
file="fz01.dat"
cat $file | \
    awk 'BEGIN{f=0;time=0;sum=0;n=0}$1>0.05&&$1<0.08{time=$1;sum=sum+$2;n=n+1}END{rho=1.17;uinf=20;S=0.0683;print "file=",file,"n=",n,"f[N]=",sum/n,"cf=",sum/n/0.5/rho/uinf^2/S}' file=$file

#### fx (wing)###
#gnuplot -persist <<EOF
#load "./function.gp"
#plot "$file" u 1:2 $eve title "f"
##replot "ave.dat" u 1:2 $eve title "ave"
##replot "" u (filter(\$1,0.1)):2 $eve smooth unique title "ave"
#exit
#EOF

#### position ###(dt0.5-dt1.0)
#gnuplot -persist <<EOF
#set xr[-0.6:0.6]
#set yr[-350:50]
#plot "./Friction-laminar/motion/position.dat" u $dimx:3 $eve w d title "position1.0dt"
#replot "./laminar0.5dt/motion/position.dat" u $dimx:3 $eve w d title "position0.5dt"
#set terminal png
#set output "comp-posi-dt.png"
#replot
#exit
#EOF

#### position ###(turb)
#gnuplot -persist <<EOF
#set xr[-0.6:0.6]
#set yr[-350:50]
#plot "./Friction-turb/motion/position.dat" u $dimx:3 $eve w d title "position1.0dt"
#set terminal png
#set output "single-posi-turb.png"
#replot
#exit
#EOF
 
#### cd ###
#x="(filter($dimx,0.005))"
#y="(\$6*0.1851)"
#gnuplot -persist <<EOF
#load "./Friction-laminar/motion/function.gp"
#set xr[-0.6:0.6]
#set yr[-1:0.8]
# 
#plot "< paste Friction-laminar/motion/position.dat Friction-laminar/motion/force.dat" u $x:$y $eve smooth unique w l title "cd"
#exit 
#EOF

#### cm ###
#x="(filter($dimx,0.005))" 
#gnuplot -persist <<EOF
#load "./Friction-laminar/motion/function.gp"
#set xr[-0.6:-0.55]
#set yr[-5:5]
#plot "< paste Friction-laminar/motion/position.dat Friction-laminar/motion/moment.dat" u $dimx:8 $eve w l title "cm"
#replot "< paste Friction-laminar/motion/position.dat Friction-laminar/motion/moment.dat" u $x:8 $eve smooth unique w l title "cm"
#set terminal png
#set output "cm3.png"
#replot
#exit
#EOF


### accel ###
itrs=2000
itre=20000
eve="every ::${itrs}::${itre}"
#gnuplot -persist <<EOF
#plot "./Friction-laminar/motion/accele.dat" u 1:2 $eve w d title "accelx-lami"
#replot "./Friction-turb/motion/accele.dat" u 1:2 $eve w d title "accelx-turb"
#exit
#EOF


#### cm ###
#gnuplot -persist <<EOF
#plot "./Friction-laminar/motion/moment.dat" u 1:4 $eve w d title "cm-lami"
# 
#EOF
