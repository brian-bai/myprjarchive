
options MPRINT;
options MLOGIC SYMBOLGEN SOURCE ;
%let VALIDDATE= %sysfunc(kcompress(%sysfunc(datetime(),datetime20.)));

proc sql;
create table bit_tab 
	(price num, 
	ttstart num format=datetime20., 
	ttend num format=datetime20., 
	vtstart num format=datetime20., 
	vtend num format=datetime20.,
    operator num );
insert into bit_tab values(100,"&VALIDDATE"dt ,"&VALIDDATE"dt,"&VALIDDATE"dt,null,1)		 ;
quit;
proc sql;
*%let LTABLE=bit_tab;
proc sql ;
select * from bit_tab where %UTIL_FILTER_BITEMPORAL_TAB(L_VALIDDATE=&VALIDDATE, L_TRANSACTIONDATE=, L_TABLE=bit_tab, L_PASSTHROUGH=NO);
quit;

