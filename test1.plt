# -*- comment-start: "# " -*-
# a test file to work with gnuplot cli


reset

# show version


set encoding utf8


set terminal svg
set print "test-print.txt"
set output "test.svg"


linecount = 3




set xdata time
set timefmt "%Y-%m-%d"
set format x "%b-%d"

set ytics
set yrange[-0.5:linecount-0.5]




plot "test-data.dat" using 1:0:ytic(4)


print strftime("%Y-%m-%d %I:%M %p",time(0)-4*60*60) \
   ."\n\ncompiled from here:\n"         \
   .GPVAL_PWD                         \
   ."\n\n"                            \
   ."🥥🌭☻😴📝"



