
*%let str=%str(A B C);

%let str=%str(A,B,C);
options MLOGIC MPrint;
%macro splitvars(instr, delim);
%let nub=%sysfunc(countw(&instr, &delim));
%do i=1 %to &nub;
    %global STR&i;
	%let STR&i=%scan(&instr,&i, &delim);
%end;
%global STR;
%LET STR=%sysfunc(translate(&instr,'_',&delim));
%mend splitvars;

%splitvars(&str, ',')
%put &STR1 &STR2;
%put &STR;
