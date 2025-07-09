# schedule plot thesis/dissertation proposal
#
reset
set termoption dash
set terminal svg  background "#ffffff" fontscale 1.0 dashed size 740, 480
set termoption enhanced
set encoding utf8
# set bmargin 7
#
# ----------------------------------------------------------------------------------------
# line types, point types and explicit rgbcolor names
# ----- line spec -----
#  lt   : 1;  2; 3;  4;  5;
#  style: -; --; .; -.; -:
#
# ----- point spec -----
#  pt   : 1; 2; 3;      4;      5; 6;      7; 8;      9; 10;      11; 12;     13;
#  style: +; x; *; square; 4-fill; o; 6-fill; ^; 8-fill;  v; 10-fill; <>;12-fill;
#
# ----- color spec -----
#  black, dark-grey, grey[10-10-100],
#  red, dark-red, light-red, magenta, coral, light-coral, orange-red, dark-magenta, light-magenta
#  green, dark-green, spring-green, forest-green, sea-green, web-green, light-green, dark-spring-green
#  blue, dark-blue, midnight-blue, web-blue, royalblue, medium-blue, light-blue, aquamarine,
#        navy,  skyblue, cyan, dark-cyan, light-cyan
#  yellow, goldenrod, light-goldenrod,
#  purple, dark-chartreuse, orchid, brown
#  khaki, dark-khaki
# ----------------------------------------------------------------------------------------

# --- custom variables
completed = 0x000000;# 0xFFE599;
uncompleted = 0xD5D1D1; # 0xF1C232;

set style arrow 1 heads back filled lt 2 lc rgb "red" lw 2
set style arrow 2 heads back nofilled lt 3 lc rgb "red" lw 2  size screen 0.008,90.000,90.000
set style arrow 3 heads filled  lt 1 lc rgb "red" lw 2 size screen 0.025,30,45
set style arrow 4 nohead nofilled dt 2 lc rgb "red" lw 2
set style arrow 5 heads noborder lc rgb "red" lw 2 size screen 0.03,15,135
set style arrow 6 heads empty lc rgb "red" lw 2 size screen 0.03,15,135
set style arrow 7 nohead back nofilled lc rgb "red" lw 2

# --- schedule data
# resource	procorder	    start    end   status
$SCHEDULES << EOD 
31A            T18412       2025-08-05     2025-08-05     OPEN
31A            T19806       2025-08-07     2025-08-08     OPEN
catota            thing1    2025-08-07     2025-08-08   CLOSED
"something else"   thing2   2025-08-07     2025-08-08   CLOSED
giroscópio        thing3    2025-08-07     2025-08-08     OPEN
"event 3"      thing4      2025-08-07     2025-08-08     OPEN
research      thing5        2025-08-07     2025-08-08     OPEN
research      thing6       2025-08-07     2025-08-08   CLOSED
"event 1"     thing7      2025-08-07     2025-08-08   CLOSED
"event 2"     thing8      2025-08-07     2025-08-08   CLOSED
"giroscópio"    thing9         2025-08-07     2025-08-08    CLOSED
EOD

# set output
set output "MPSgantt.svg"

# disable legend
unset key

# grid and tics
set mxtics 
set mytics
set grid xtics
set grid ytics
set grid mxtics

# create list of keys
List = ''
set table $Dummy
    plot $SCHEDULES u (List=List.'"'.strcol(1).'" ',NaN) w table
unset table
# print List

# create list of unique keys (events)
scheduleList = ''
do for [i=1:words(List)] {
    item = word(List,i)
    found = 0
    do for [j=1:words(scheduleList)] {
        if (item eq word(scheduleList,j)) { found=1; break }
    }
    if (!found) { scheduleList = scheduleList.'"'.item.'" '}}
# print scheduleList  # test

# define functions for lookup/index and color
Lookup(s) = (Index = NaN, sum [i=1:words(scheduleList)] \
    (Index = s eq word(scheduleList,i) ? i : Index,0), Index)
# print Lookup("research") # little testiculus

Color(s) = s eq "CLOSED" ?  completed : uncompleted

# set range of x-axis and y-axis
set xdata time
set timefmt '%Y-%m-%d'
# set xrange [:]
set yrange [0.5:words(scheduleList)+0.5]

unset xlabel

# set today
today = '2025-07-09'

set arrow from today, 0.5 to today,words(scheduleList)+0.5 as 7

plot $SCHEDULES using 3:(Idx=Lookup(strcol(1))): 4 : 3 :(Idx-0.2):(Idx+0.2): \
    (Color(strcol(5))): ytic(strcol(1)) w boxxyerror fill solid 0.7 lw 2.0 lc rgb var notitle
