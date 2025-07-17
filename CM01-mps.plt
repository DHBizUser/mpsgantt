# -*- comment-start: "# " -*-
# a test file to work with gnuplot cli



reset

# show version
# show variables all




set terminal svg size 3600, 2400 font "Arial,16"
set encoding utf8
set termoption enhanced
set termoption dash
set print "test-print.txt"
set output "CM01-mps.svg"
set timefmt "%Y-%m-%d"

set datafile columnheaders
# set key autotitle columnhead
set datafile separator "\t"


set style line 3 linecolor black
set style arrow 1 nohead back nofilled lc rgb "red" lw 2
set style arrow 2 nohead back nofilled lc rgb "dark-blue" lw 4





timezone = -4			# VA is -5 hours outside DST, -4 hours inside DST
beautypharma = 26.5
pharmaother = 51.5


file = "CM01-data.dat"





unset key
set grid
set xdata time
set format x "%b-%d\n%Y"



set ytics offset 0,1


set arrow from time(0+timezone*60*60), -0.5 to time(0),55 as 1
set arrow from "2024-12-01", beautypharma to "2026-12-31",beautypharma as 2
set arrow from "2024-12-01", pharmaother to "2026-12-31",pharmaother as 2
set label "Beauty" at "2026-08-20",beautypharma-5 left rotate by -90 font "Arial,72"
set label "Pharma" at "2026-08-20",beautypharma+5 right rotate by -90 font "Arial,72"

plot file using (timecolumn(16)):(column("WCrank")-0.5):\
(timecolumn(16)):(timecolumn(17)):\
(column("WCrank")-0.4):(column("WCrank")+0.4):\
yticlabels(stringcolumn(6)."  ".stringcolumn(4)) with boxxyerror fillstyle solid 0.15 fillcolor "black" linewidth 2.0



print strftime("%Y-%m-%d %I:%M %p",time(0)+(timezone*60*60)) \
   ."\n\ncompiled from here:\n"         \
   .GPVAL_PWD                         \
   ."\n\nwith Gnuplot version ".gprintf("%.1f",GPVAL_VERSION)."  patch ".GPVAL_PATCHLEVEL               \
   ."\n\n🥥🌭☻😴📝\n\n"


