data aa;
   input   a1  a2  a3  a4   d1   d2   d3   d4 @@; 
   cards;
2    1   4   3   145  45   34   45
1    3   3   1    43   3   55   45
.    2   .   4     .  32    .   44
3    4   1   .    44  55    3    .
4    .   2   2    22  .     34    6
;
run;


%macro twomin(num);
 if a&num ne . then do;
      if mst(1,&num) = . or a&num<mst(1,&num) then do;
	    mst(2,&num)=mst(1,&num);
		trn(2,&num)=trn(1,&num);
        mst(1,&num)=a&num;
		trn(1,&num)=d&num;
	  end;
      else if mst(2,&num) = . or a&num<mst(2,&num) then do;
           mst(2,&num)=a&num;
		   trn(2,&num)=d&num;
	  end;
  end;   
%mend twomin;

data bb(drop=i j);
	array mst(2,4) _temporary_;
	array trn(2,4) _temporary_;
	do i=1 to toobs;
	   set aa point=i nobs=toobs;	
       %twomin(1)
	   %twomin(2)
	   %twomin(3)
	   %twomin(4)
	end;
	do i=1 to 2;
	   a1=mst(i,1);
	   a2=mst(i,2);
	   a3=mst(i,3);
	   a4=mst(i,4);
	   d1=trn(i,1);
	   d2=trn(i,2);
	   d3=trn(i,3);
	   d4=trn(i,4);
      output;
    end;	
	stop;

run;

proc print data=bb;
run;

%macro sex;
%do i=1 %to 4;
data a&i;
set aa;
keep a&i d&i;
run;
proc sort data=a&i;
by a&i;
run;
data a&i;
set a&i;
if a&i not in (1,2) then delete;
run;
%end;
data final;
retain a1-a4 d1-d4;
merge a1 a2 a3 a4;
run;
%mend;

%sex;
