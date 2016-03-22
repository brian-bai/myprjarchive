/************************************************************
* FROM : Paper 052-2009                                    *
* Creating SAS?Data Sets from HTML Table Definitions       *
* Rick Langston, SAS Institute Inc.                        *
************************************************************/

%macro readhtml(url);
%global tabletag trtag tdtag closetags drops renames dates nobs ntables;
filename urltext url &url;
filename myfile temp;

data _null_;
	infile urltext recfm=f lrecl=1 end=eof;
	file myfile recfm=f lrecl=1;
	input @1 x $char1.;
	put @1 x $char1.;

	if eof;
	call symputx('filesize',_n_);
run;

data detail(keep=text col);
	infile myfile recfm=f lrecl=&filesize. column=c missover;
	array which{3} $8 _temporary_ ('table','tr','td');
	array whichsrc{3} $8 _temporary_;
	length tag $8;
	closetags='N';
	failure=0;

	do i=1 to 3;
		tag='<'||which{i};
		link readfile;
		n_lower_open = obscount;
		tag=upcase(tag);
		link readfile;
		n_upper_open = obscount;
		tag='</'||which{i};
		link readfile;
		n_lower_close = obscount;
		tag=upcase(tag);
		link readfile;
		n_upper_close = obscount;
		nobs+n_lower_open+n_upper_open+n_lower_close+n_upper_close;

		if which{i}^='table' and n_lower_close+n_upper_close>0 then
			closetags='Y';

		if (n_upper_open>0 and n_lower_open>0) or
			(n_upper_close>0 and n_lower_close>0) then
			do;
				put 'ERROR: There is a mixture of upper and lower case' which{i} ' tags';
				failure=1;
			end;

		if which{i}='table' then
			do;
				ntables=n_lower_open+n_upper_open;

				if ntables=0 then
					do;
						put 'ERROR: There are no tables defined in the HTML.';
						failure=1;
					end;
				else if n_upper_close+n_lower_close=0 then
					do;
						put 'ERROR: There are no closing tags for tables in the HTML.';
						failure=1;
					end;
			end;

		whichsrc{i}=which{i};

		if n_upper_open>0 then
			whichsrc{i}=upcase(whichsrc{i});
	end;

	call symput('tabletag',trim(whichsrc{1}));
	call symput('trtag', trim(whichsrc{2}));
	call symput('tdtag', trim(whichsrc{3}));
	call symput('closetags',closetags);
	call symput('nobs', cats(nobs));
	call symput('ntables', cats(ntables));

	if failure then
		abort;
	return;
	readfile:;
	obscount=0;
	text=upcase(tag);
	input @1 @;

	do while(1);
		input @(trim(tag)) @;

		if c>&filesize then
			leave;
		col=c;
		obscount+1;
		output;
	end;

	return;
run;

proc sort data=detail;
	by col;
run;

filename sascode temp;

data _null_;
	array taglist{&nobs} $8 _temporary_;

	* tag text;
	array tagstart{&nobs} _temporary_;

	* start loc for the tag;
	array tagend{&nobs} _temporary_;

	* end loc for the tag;
	array tablestart{&ntables} _temporary_;

	* start loc for each table;
	array tableend {&ntables} _temporary_;

	* end loc for each table;
	array tablenrows{&ntables} _temporary_;

	* no. of rows in the table;
	array tablencols{&ntables} _temporary_;

	* no. of cols in the table;
	*-----populate the arrays from the detail data set-----*;
	do i=1 to &nobs;
		set detail point=i;
		taglist{i}=text;
		tagstart{i}=col;
	end;

	*-----determine the end location for each tag if end tags given-----*;
	do i=1 to &nobs;
		if taglist{i}=:'</' then
			do j=i-1 to 1 by -1;
				if substr(taglist{j},2)=substr(taglist{i},3) then
					do;
						tagend{j}=tagstart{i}-length(taglist{i});
						leave;
					end;
			end;
	end;

	*-----set the table start/end arrays-----*;
	j=0;

	do i=1 to &nobs;
		if taglist{i}='<TABLE' then
			do;
				j+1;
				tablestart{j}=tagstart{i};
				tableend{j}=tagend{i};
			end;
	end;

	jj=0;

	do i=1 to &nobs;
		*-----find smallest table containing each <tr tag-----*;
		if taglist{i}='<TR' then
			do;
				minsize=1e10;

				do j=1 to &ntables;
					if tablestart{j}<=tagstart{i}<=tableend{j} then
						do;
							size=tableend{j}-tablestart{j}+1;

							if size<minsize then
								do;
									jj=j;
									minsize=size;
								end;
						end;
				end;

				if jj>0 then
					do;
						tablenrows{jj}+1;
					end;

				ncols=0;
			end;

		*-----increment column count for the <td tags-----*;
		else if jj>0 and taglist{i}='<TD' then
			do;
				ncols+1;
				tablencols{jj}=max(tablencols{jj},ncols);
			end;
	end;

	*-----determine if there is overlap (which would be a problem)-----*;
	overlap=0;

	do i=1 to &ntables;
		put tablestart{i}= tableend{i}= tablenrows{i}= tablencols{i}=;

		if i>1 and tableend{i-1}>tablestart{i} then
			overlap=1;
		else if i<&ntables and tablestart{i+1} < tableend{i} then
			overlap=1;
	end;

	put overlap=;
	file sascode;

	do i=1 to &ntables;
		if tablestart{i}>0 and tableend{i}>0 and tablenrows{i}>0 and tablencols{i}>0 then
			do;
				args=catx(',',i,tablestart{i},tableend{i},tablenrows{i},tablencols{i});
				put '%readtable(' args ');';
			end;
	end;

	stop;
run;

proc delete data=detail;
run;

*-----invoke the generated code that calls the readtable macro-----*;
%include sascode/source2;
run;

filename sascode clear;
%mend readhtml;

%macro readtable(tablenum,start,end,nrows,ncols);

	data table&tablenum.;
		infile myfile recfm=f lrecl=&filesize. column=c missover;
		array col{*} $200 col1-col&ncols.;
		keep col1-col&ncols.;

		*-----start at the beginning of our table-----*;
		input @&start @;
		endrow=.;

		*-----read each row-----*;
		do i=1 to &nrows;
			*-----row starts with <TR or <tr tag-----*;
			input @"<&trtag" @;
			startcol=c;

			*-----determine where to stop, using </tr, next <tr, or next <table-----*;
			%if &closetags.=Y %then
				%do;
					input @"</&trtag" @;
					endrow=c-4;
				%end;
			%else
				%do;
					if i<&nrows then
						do;
							input @"<&trtag" @;
							endrow=c-4;
						end;
					else
						do;
							input @"<&tabletag " @;
							endrow=c-7;
						end;
				%end;

			*-----go back to start reading contents of row-----*;
			input @startcol @;

			*-----read all the column data for the row-----*;
			do j=1 to &ncols;
				*-----col starts with <TD or <td tag-----*;
				input @"<&tdtag" @;

				*-----blank out remaining columns if we hit the end-----*;
				if c>=endrow then
					do;
						do k=j to &ncols;
							col{j}=' ';
						end;

						input @endrow @;
						leave;
					end;

				*----get past end of tag-----*;
				input @'>' @;
				startcol=c;

				*-----compute where to end the column data using </td, <tr, or <table----*;
				%if &closetags.=Y %then
					%do;
						input @"</&tdtag" @;
					%end;
				%else
					%do;
						if j<&ncols then
							input @"<&tdtag" @;
						else if i<&nrows then
							input @"<&trtag" @;
						else input @"</&tabletag" @;
					%end;

				*-----read everything between----*;
				l=c-5-startcol+1;
				input @startcol text $varying32767. l @;

				*-----remove the prefixing tags like <small>, <a href=...>, etc.-----*;
				do while(left(text)=:'<');
					text=substr(text,index(text,'>')+1);
				end;

				*-----remove everything after a trailing <-----*;
				k=index(text,'<');

				if k then
					substr(text,k)=' ';

				*-----change escape sequences to the right characters-----*;
				text=tranwrd(text,'&amp;','&');
				text=tranwrd(text,'&lt;','<');
				text=tranwrd(text,'&rt;','>');
				text=tranwrd(text,'&nbsp;',' ');

				*-----remove any stray crlf chars and convert tabs to blanks-----*;
				text=compress(text,'0d0a'x);
				text=translate(text,' ','09'x);

				*-----save this as our column value-----*;
				col{j}=text;
			end;

			output;
		end;

		stop;
	run;

	data table&tablenum.;
		set table&tablenum. end=eof;
		array col{*} col1-col&ncols.;
		array numcol{*} numcol1-numcol&ncols.;
		keep col1-col&ncols. numcol1-numcol&ncols.;
		array status{&ncols.} $1 _temporary_;
		length text $1024;

		do i=1 to &ncols;
			if status{i}='C' then
				continue;
			text=left(col{i});
			numcol{i}=.;

			if text=' ' then
				continue;

			if status{i}=' ' then
				do;
					link try_numeric;

					if numcol{i}^=. then
						do;
							status{i}='N';
						end;
					else
						do;
							link try_date;

							if numcol{i}^=. then
								do;
									status{i}='D';
								end;
						end;

					if status{i}=' ' then
						status{i}='C';
				end;
			else if status{i}='D' then
				do;
					link try_date;

					if numcol{i}=. then
						do;
							status{i}='C';
						end;
				end;
			else if status{i}='N' then
				do;
					link try_numeric;

					if numcol{i}=. then
						do;
							status{i}='C';
						end;
				end;
		end;

		output;

		if eof;
		length renames drops dates $32767;

		do i=1 to &ncols;
			if status{i}='N' or status{i}='D' then
				do;
					renames=cat(trim(renames),' numcol',i,'=col',i);
					drops=cat(trim(drops),' col',i);
				end;
			else if status{i}=' ' then
				do;
					drops=cat(trim(drops),' col',i,' numcol',i);
				end;
			else if status{i}='C' then
				do;
					drops=cat(trim(drops),' numcol',i);
				end;

			if status{i}='D' then
				do;
					dates=cat(trim(dates),' col',i);
				end;
		end;

		if drops^=' ' then
			drops='drop='||drops;

		if renames^=' ' then
			renames='rename=('||trim(renames)||')';

		if dates^=' ' then
			dates='format '||trim(dates)||';';
		call symput('drops',trim(drops));
		call symput('renames',trim(renames));
		call symput('dates',trim(dates));
		return;

		/* The TRY_NUMERIC link will use BEST32. on the field to see if it converts
		to a number. We use the INPUT function with the ?? operator to indicate
		that _ERROR_ will not be set and no warning message will appear about
		invalid data. This link will not be invoked if text is blank, so any
		other text causing numcol to become missing indicates an invalid numeric
		value (except for ., which we will assume here to mean non-numeric). The
		TRY_DATE link does the same except it uses ANYDTDTE, which allows for many
		different types of date representations, such as 2008/01/02 or 02JAN2008. */
		try_numeric:;
		numcol{i}=input(text,?? best32.);
		return;
		try_date:;
		numcol{i}=input(text,?? anydtdte32.);
		return;
	run;

	*-----recreate the data set with the changes-----*;
	data table&tablenum.;
		set table&tablenum.(&drops &renames);
		&dates;
	run;

	*-----print the resultant table-----*;
	options nocenter;

	proc print data=table&tablenum.;
		title "table&tablenum.";
	run;

%mend readtable;

%readhtml('http://support.sas.com/certify/directory/dirfound.hsql?pattern=&country=China&cert=_ALL_&x=51&y=9');
