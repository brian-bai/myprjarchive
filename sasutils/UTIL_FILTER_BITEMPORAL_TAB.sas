/*****************************************************************************/
/* DESCRIPTION : Filter bitemporal table                                     */
/*---------------------------------------------------------------------------*/
/* PARAMETERS IN : L_VALIDDATE,                                              */
/*                 L_TRANSACTIONDATE,                                        */
/*                 L_TABLE is the bitemporal table                           */
/*                 L_PASSTHROUGH is YES for DB, NO for SAS                   */
/*****************************************************************************/
%macro UTIL_FILTER_BITEMPORAL_TAB(L_VALIDDATE=, L_TRANSACTIONDATE=, L_TABLE=, L_PASSTHROUGH=YES);
 
    %if &L_TRANSACTIONDATE. eq %then %do;
       %let L_TRANSACTIONDATE = %sysfunc(kcompress(%sysfunc(datetime(),datetime20.)));
	%end;

	%if &L_PASSTHROUGH eq YES %then %do; /* PASSTHROUGH */
      %if &L_TRANSACTIONDATE. eq %then %do;
        ( &L_TABLE..TTSTART <= to_date(%nrbquote(')&L_VALIDDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') ) and
        ( &L_TABLE..TTEND is null or &L_TABLE..TTEND >= to_date(%nrbquote(')&L_VALIDDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') ) and
        ( &L_TABLE..VTSTART is null or &L_TABLE..VTSTART <= to_date(%nrbquote(')&L_VALIDDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') ) and
        ( &L_TABLE..VTEND is NULL or to_date(%nrbquote(')&L_VALIDDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') < &L_TABLE..VTEND)
      %end; /* end no transaction date */
      %else %do;
		( &L_TABLE..TTSTART <= to_date(%nrbquote(')&L_TRANSACTIONDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') ) and
		( &L_TABLE..TTEND is null or &L_TABLE..TTEND >= to_date(%nrbquote(')&L_TRANSACTIONDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') ) and
		( &L_TABLE..VTSTART is null or &L_TABLE..VTSTART <= to_date(%nrbquote(')&L_VALIDDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') ) and
		( &L_TABLE..VTEND is NULL or to_date(%nrbquote(')&L_VALIDDATE.%nrbquote('),'DDMONYYYY:HH24:MI:SS') < &L_TABLE..VTEND)
      %end; /* end transaction date */
	%end; /* end PASSTHROUGH */
	%else %do; /* NO PASSTHROUGH */
	  %if &L_TRANSACTIONDATE. eq %then %do;
		( &L_TABLE..TTSTART <= "&L_VALIDDATE."dt ) and
		( &L_TABLE..TTEND is null or &L_TABLE..TTEND >= "&L_VALIDDATE."dt ) and
		( &L_TABLE..VTSTART is null or &L_TABLE..VTSTART <= "&L_VALIDDATE."dt ) and
		( &L_TABLE..VTEND is NULL or "&L_VALIDDATE."dt < &L_TABLE..VTEND)
	  %end; /* end no transaction date */
	  %else %do;
		( &L_TABLE..TTSTART <= "&L_TRANSACTIONDATE."dt) and
		( &L_TABLE..TTEND is null or &L_TABLE..TTEND >= "&L_TRANSACTIONDATE."dt ) and
		( &L_TABLE..VTSTART is null or &L_TABLE..VTSTART <= "&L_VALIDDATE."dt ) and
		( &L_TABLE..VTEND is NULL or "&L_VALIDDATE."dt < &L_TABLE..VTEND)
	  %end; /* end transaction date */
	%end; /* end NO PASSTHROUGH */
 
%mend UTIL_FILTER_BITEMPORAL_TAB;
 
