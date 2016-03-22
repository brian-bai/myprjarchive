/*************************************/
   /* create the Stocks data set        */
   /*************************************/
data stocks;
   input Year @7 DateOfHigh:date9. 
         DowJonesHigh @26 DateOfLow:date9. 
         DowJonesLow;
   format LogDowHigh LogDowLow 5.2 
          DateOfHigh DateOfLow date9.;
   LogDowHigh=log(DowJonesHigh);
   LogDowLow=log(DowJonesLow);
   datalines;
1954  31DEC1954  404.39  11JAN1954  279.87
1955  30DEC1955  488.40  17JAN1955  388.20
1956  06APR1956  521.05  23JAN1956  462.35
1957  12JUL1957  520.77  22OCT1957  419.79
1958  31DEC1958  583.65  25FEB1958  436.89
1959  31DEC1959  679.36  09FEB1959  574.46
1960  05JAN1960  685.47  25OCT1960  568.05
1961  13DEC1961  734.91  03JAN1961  610.25
1962  03JAN1962  726.01  26JUN1962  535.76
1963  18DEC1963  767.21  02JAN1963  646.79
1964  18NOV1964  891.71  02JAN1964  768.08
1965  31DEC1965  969.26  28JUN1965  840.59
1966  09FEB1966  995.15  07OCT1966  744.32
1967  25SEP1967  943.08  03JAN1967  786.41
1968  03DEC1968  985.21  21MAR1968  825.13
1969  14MAY1969  968.85  17DEC1969  769.93
1970  29DEC1970  842.00  06MAY1970  631.16
1971  28APR1971  950.82  23NOV1971  797.97
1972  11DEC1972 1036.27  26JAN1972  889.15
1973  11JAN1973 1051.70  05DEC1973  788.31
1974  13MAR1974  891.66  06DEC1974  577.60
1975  15JUL1975  881.81  02JAN1975  632.04
1976  21SEP1976 1014.79  02JAN1976  858.71
1977  03JAN1977  999.75  02NOV1977  800.85
1978  08SEP1978  907.74  28FEB1978  742.12
1979  05OCT1979  897.61  07NOV1979  796.67
1980  20NOV1980 1000.17  21APR1980  759.13
1981  27APR1981 1024.05  25SEP1981  824.01
1982  27DEC1982 1070.55  12AUG1982  776.92
1983  29NOV1983 1287.20  03JAN1983 1027.04
1984  06JAN1984 1286.64  24JUL1984 1086.57
1985  16DEC1985 1553.10  04JAN1985 1184.96
1986  02DEC1986 1955.57  22JAN1986 1502.29
1987  25AUG1987 2722.42  19OCT1987 1738.74
1988  21OCT1988 2183.50  20JAN1988 1879.14
1989  09OCT1989 2791.41  03JAN1989 2144.64
1990  16JUL1990 2999.75  11OCT1990 2365.10
1991  31DEC1991 3168.83  09JAN1991 2470.30
1992  01JUN1992 3413.21  09OCT1992 3136.58
1993  29DEC1993 3794.33  20JAN1993 3241.95
1994  31JAN1994 3978.36  04APR1994 3593.35
1995  13DEC1995 5216.47  30JAN1995 3832.08
1996  27DEC1996 6560.91  10JAN1996 5032.94
1997  06AUG1997 8259.31  11APR1997 6391.69
1998  23NOV1998 9374.27  31AUG1998 7539.07
;
run;
/*************************************/
   /* create a single plot (PROC PLOT)  */
   /*************************************/
proc plot data=stocks;
   plot dowjoneshigh*year='*';
   title 'High Dow Jones Values';
   title2 'from 1954 to 1998';
run;
quit;

   /*************************************/
   /* create overlaid plots (PROC PLOT) */
   /*************************************/
proc plot data=stocks;
   plot dowjoneshigh*year='*'
        dowjoneslow*year='o' / overlay box;
   title 'Plot of Highs and Lows';
   title2 'for the Dow Jones Industrial Average';
run;
quit;

   /*************************************/
   /* create a single plot and connect  */
   /* plot data points (PROC GPLOT)     */
   /*************************************/
proc gplot data=stocks;
   plot dowjoneshigh*year / haxis=1955 to 1995 by 5
                            vaxis=0 to 6000 by 1000
                            hminor=3
                            vminor=1
                            vref=1000 3000 5000
                            lvref=2
                            cvref=blue
                            caxis=blue
                            ctext=red;
   symbol1 color=red
           interpol=join
           value=dot
           height=1;
   title1 'Dow Jones Yearly Highs';
run;
quit;

   /*************************************/
   /* create interactive overlaid plots */
   /* with filled areas (PROC GPLOT,    */
   /* ODS, and ActiveX)                 */
   /*************************************/
ods html body='plot.htm';
goptions reset=global gunit=pct border cback=white
         colors=(blue red) ctext=black
         ftitle=swissb ftext=swiss htitle=6 htext=4
         device=activex; 
proc gplot data=stocks;
   plot dowjoneslow*year 
        dowjoneshigh*year / overlay
                            haxis=axis1
                            hminor=4
                            vaxis=axis2
                            vminor=1
                            caxis=black
                            areas=2;
   symbol1 interpol=join;
   axis1 order=(1955 to 1995 by 5) offset=(2,2)
         label=none
         major=(height=2)
         minor=(height=1);
   axis2 order=(0 to 6000 by 1000) offset=(0,0)
         label=none
         major=(height=2)
         minor=(height=1);
run;
quit;
ods html close;

   /*************************************/
   /* clear any titles in effect        */
   /*************************************/
title;
