
set terminal push
set terminal postscript eps enhanced "Times, 26"
set output FILE.".eps"
replot
unset output
set terminal pop