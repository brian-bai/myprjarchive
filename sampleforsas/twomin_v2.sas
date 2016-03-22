
data aa;
   input   a1  a2  a3  a4  a5  d1   d2   d3   d4 d5 @@; 
   cards;
2    1   4   3  4 145  45   34   45 80
1    3   3   1  3  43   3   55   45 70
.    2   .   4  2   .  32    .   44 60
3    4   1   .  1  44  55    3    . 50
4    .   2   2  3  22  .     34   6 40
;
run;


%macro twomin(num);
if a&num ne . then do;
      if mst(1,&num) = 0 or a&num<mst(1,&num) then do;
            mst(2,&num)=mst(1,&num);
                trn(2,&num)=trn(1,&num);
        mst(1,&num)=a&num;
                trn(1,&num)=d&num;
          end;
      else if mst(2,&num) = 0 or a&num<mst(2,&num) then do;
           mst(2,&num)=a&num;
                   trn(2,&num)=d&num;
          end;
  end;   
%mend twomin;

%macro genbb(varnum);
data bb(drop=j);
        array mst(2,&varnum) _temporary_;
        array trn(2,&varnum) _temporary_;
        do i=1 to 2;
          do j=1 to &varnum;
            mst(i,j)=0;
                trn(i,j)=0;
          end;
        end;
        do i=1 to toobs;
           set aa point=i nobs=toobs;        
           %do k=1 %to &varnum;
             %twomin(&k)
		   %end;
        end;
        do i=1 to 2;
		   %do j=1 %to &varnum;
	           a&j=mst(i,&j);
	           d&j=trn(i,&j);
		   %end;
	       output;
	    end;        
        stop;

run;
%mend genbb;

%genbb(5)
proc print data=bb;
run;
