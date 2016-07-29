
set terminal x11 enhanced
FILE = "absPalongZ"



set datafile separator ","
# set xrange [0:5000]
set xtics 0.1
set ytics 100
set yrange [50:500]
set xlabel "Z [m]"
set ylabel "Absolute Pressure [Pa]"
set key inside right top


plot "1_dashw/graph.csv" u 19:6 w l lc -1 title "test case",\
     "ref/ref.csv" u 1:2   w p lc -1 title "Jonckheere(2013)"
     
pause -1 "press [Enter] key or [OK] button key to exit"
