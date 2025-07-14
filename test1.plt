# -*- comment-start: "# " -*-
# a test file to work with gnuplot cli


reset

# show version
# show variables all


set encoding utf8


set terminal svg
set print "test-print.txt"
set output "test.svg"
set timefmt "%Y-%m-%d"


linecount = 3
margin = 0.5
timezone = -4			# VA is -5 hours outside DST, -4 hours inside DST





$WorkCenters << EOD
# comment
20A	1     BEAUTY
36A	2     PHARMA
EOD



set table $datatable
plot "test-data.dat" using 0:(stringcolumn(1)):(stringcolumn(2)):((timecolumn(2)-timecolumn(1))/(60*60*24)):   \
3:(stringcolumn(4)):(stringcolumn(5)) with table
unset table










set xdata time
set format x "%b-%d\n%Y"

set ytics
set yrange[0-margin:linecount-margin]




plot "test-data.dat" using 1:0:(timecolumn(2)-timecolumn(1)):(0):yticlabel(5) with vector


print strftime("%Y-%m-%d %I:%M %p",time(0)+(timezone*60*60)) \
   ."\n\ncompiled from here:\n"         \
   .GPVAL_PWD                         \
   ."\n\nwith Gnuplot version ".gprintf("%.1f",GPVAL_VERSION)."  patch ".GPVAL_PATCHLEVEL               \
   ."\n\n🥥🌭☻😴📝\n\n",              \
   $WorkCenters,"\n\n",                       \
   $datatable