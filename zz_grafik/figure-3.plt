# Ploting for HRT434 class in gnuplot.
set terminal postscript eps size 20.0,10.0 enhanced color font 'Helvetica,40' linewidth 1
set output "figure-3.eps"
set tmargin 3
set tics out
set grid x y
set x2label " PRECISE - BROADCAST_{12h} "
set xtics 0,2,24
set ylabel "[m]"
set ytics -600,100,600
set ytics nomirror
set y2label "[ns]"
set y2tics
set xlabel " t [h] \n\n Sekil-3 PRE-BRO_{12h} duzeltme vektorlerinin ( v_X , v_Y , v_Z , v_S [m] ve v_T [ns] ) grafikleri. "
plot \
"figure-3.txt" u 1:2 title "v_X" with lines axes x1y1 linewidth 2 lt rgb "#CC00CC", \
"figure-3.txt" u 1:3 title "v_Y" with lines axes x1y1 linewidth 2 lt rgb "#0055FF", \
"figure-3.txt" u 1:4 title "v_Z" with lines axes x1y1 linewidth 2 lt rgb "#55FF00", \
"figure-3.txt" u 1:5 title "v_S" with lines axes x1y1 linewidth 2 lt rgb "#FF0000", \
"figure-3.txt" u 1:6 title "v_T" with lines axes x1y2 linewidth 2 lt rgb "#FFCC00"