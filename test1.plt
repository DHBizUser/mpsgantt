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
BeautyPharma = 5


$WorkCenters >> EOD
# workcenter description	biz	technology
20A	     lipcare		beauty	lipcare
26A	     lipcare		beauty	lipcare
27A	     lipcare		beauty	lipcare
36A	     lipcare		beauty	lipcare
40A	     lipcare		beauty	lipcare
41A	     lipcare		beauty	lipcare
45A	     lipcare		beauty	lipcare
65A	     cosmetics		beauty	cosmetics
91A	     cosmetics		beauty	cosmetics
92A	     cosmetics		beauty	cosmetics
AER201	     aerosol		beauty	aerosol
AER202	     aerosol		beauty	aerosol
AER203	     aerosol		beauty	aerosol
AER204	     aerosol		beauty	aerosol
AER205	     aerosol		beauty	aerosol
72A	     blister		pharma	solids
78A	     pouch		pharma	solids
79A	     pouch		pharma	solids
82A	     bottles		pharma	solids
83A	     bottles		pharma	solids
5A	     "4oz bottles"	pharma	liquid
61A	     "glass bottles"	pharma	liquid
62A	     "8oz bottles"	pharma	liquid
63A	     "4oz bottles"	pharma	liquid
31A	     topicals		pharma	topicals
32A	     topicals		pharma	topicals
33A	     topicals		pharma	topicals
34A	     topicals		pharma	topicals
35A	     topicals		pharma	topicals
50A	     topicals		pharma	topicals
51A	     blister		pharma	topicals
57A	     topicals		pharma	topicals
58A	     topicals		pharma	topicals
59A	     topicals		pharma	topicals
66A	     topicals		pharma	topicals
77A	     topicals		pharma	topicals
EOD





set table $datatable
plot "test-data.dat" using 0:(stringcolumn(1)):(stringcolumn(2)):((timecolumn(2)-timecolumn(1))/(60*60*24)):   \
3:(stringcolumn(4)):(stringcolumn(5)):(stringcolumn(6)) with table
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
   ."\n\n🥥🌭☻😴📝\n\n",$datatable


#   $WorkCenters,"\n\n"
   