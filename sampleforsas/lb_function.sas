data contest;
INPUT Name $16. Age 3. +1 Type $1. +1 Date MMDDYY10. (Scr1 Scr2 Scr3 Scr4 Scr5) (4.1);
AvgScore = MEAN(Scr1, Scr2, Scr3, Scr4, Scr5);
DayEntered = DAY(Date);
Type = UPCASE(Type);
datalines;
Alicia Grossman  13 c 10-28-2008 7.8 6.5 7.2 8.0 7.9
Matthew Lee       9 D 10-30-2008 6.5 5.9 6.8 6.0 8.1
Elizabeth Garcia 10 C 10-29-2008 8.9 7.9 8.5 9.0 8.8
Lori Newcombe     6 D 10-30-2008 6.7 5.6 4.9 5.2 6.1
Jose Martinez     7 d 10-31-2008 8.9 9.510.0 9.7 9.0
Brian Williams   11 C 10-29-2008 7.8 8.4 8.5 7.9 8.0
;
run;
PROC PRINT DATA = contest;
TITLE 'Pumpkin Carving Contest';
RUN;
