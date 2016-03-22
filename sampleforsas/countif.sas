/*x1 x2 x3 x4 x5       y1 y2 y3 y4
*1    1   2   3   4    2  1   1    1 
*2    2   2   3   3    0  3   2    0
*/

data test;
infile datalines;
input x1 x2 x3 x4 x5;
datalines;
1    1   2   3   4 
2    2   2   3   3 
4    4   3   2   1
;
run;
options mprint mlogic;
%macro countif(orgset, num);
data &orgset;
   set &orgset;
   array y(4) y1-y4 (0 0 0 0);
   %do i=1 %to &num;
	   select (x&i);
	     %do j=1 %to 4;
		   when(&j) y&j=y&j+1;
		 %end
	     otherwise;
	   end;
   %end;
run;
%mend countif;
%countif(test,5)
