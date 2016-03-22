/***********************************************************
* Creating SAS Data Sets from HTML select Definitions      *
************************************************************/

%macro readhtml(url);
%global selecttag optiontag closetags drops renames dates nobs nselects;
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
	array which{2} $8 _temporary_ ('select','option');
	array whichsrc{2} $8 _temporary_;
	length tag $8;
	closetags='N';
	failure=0;

	do i=1 to 2;
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

		if which{i}^='select' and n_lower_close+n_upper_close>0 then
			closetags='Y';

		if (n_upper_open>0 and n_lower_open>0) or
			(n_upper_close>0 and n_lower_close>0) then
			do;
				put 'ERROR: There is a mixture of upper and lower case' which{i} ' tags';
				failure=1;
			end;

		if which{i}='select' then
			do;
				nselects=n_lower_open+n_upper_open;

				if nselects=0 then
					do;
						put 'ERROR: There are no selects defined in the HTML.';
						failure=1;
					end;
				else if n_upper_close+n_lower_close=0 then
					do;
						put 'ERROR: There are no closing tags for selects in the HTML.';
						failure=1;
					end;
			end;

		whichsrc{i}=which{i};

		if n_upper_open>0 then
			whichsrc{i}=upcase(whichsrc{i});
	end;

	call symput('selecttag',trim(whichsrc{1}));
	call symput('optiontag', trim(whichsrc{2}));
	call symput('closetags',closetags);
	call symput('nobs', cats(nobs));
	call symput('nselects', cats(nselects));

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
	array selectstart{&nselects} _temporary_;

	* start loc for each select;
	array selectend {&nselects} _temporary_;

	* end loc for each select;
	array selectnrows{&nselects} _temporary_;

	* no. of rows in the select;
/*	array selectncols{&nselects} _temporary_;*/

	* no. of cols in the select;
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

	*-----set the select start/end arrays-----*;
	j=0;

	do i=1 to &nobs;
		if taglist{i}='<select' then
			do;
				j+1;
				selectstart{j}=tagstart{i};
				selectend{j}=tagend{i};
			end;
	end;

	jj=0;

	do i=1 to &nobs;
		*-----find smallest select containing each <OPTION tag-----*;
		if taglist{i}='<OPTION' then
			do;
				minsize=1e10;

				do j=1 to &nselects;
					if selectstart{j}<=tagstart{i}<=selectend{j} then
						do;
							size=selectend{j}-selectstart{j}+1;

							if size<minsize then
								do;
									jj=j;
									minsize=size;
								end;
						end;
				end;

				if jj>0 then
					do;
						selectnrows{jj}+1;
					end;

/*				ncols=0;*/
			end;

		*-----increment column count for the <td tags-----*;
/*		else if jj>0 and taglist{i}='<TD' then*/
/*			do;*/
/*				ncols+1;*/
/*				selectncols{jj}=max(selectncols{jj},ncols);*/
/*			end;*/
	end;

	*-----determine if there is overlap (which would be a problem)-----*;
	overlap=0;

	do i=1 to &nselects;
		put selectstart{i}= selectend{i}= selectnrows{i}=;

		if i>1 and selectend{i-1}>selectstart{i} then
			overlap=1;
		else if i<&nselects and selectstart{i+1} < selectend{i} then
			overlap=1;
	end;

	put overlap=;
	file sascode;

	do i=1 to &nselects;
		if selectstart{i}>0 and selectend{i}>0 and selectnrows{i}>0 then
			do;
				args=catx(',',i,selectstart{i},selectend{i},selectnrows{i},1);
				put '%readselect(' args ');';
			end;
	end;

	stop;
run;

proc delete data=detail;
run;

*-----invoke the generated code that calls the readselect macro-----*;
%include sascode/source2;
run;

filename sascode clear;
%mend readhtml;

%macro readselect(selectnum,start,end,nrows,&ncols);

	data select&selectnum.;
		infile myfile recfm=f lrecl=&filesize. column=c missover;
		array col{*} $200 col1-col&ncols.;
		keep col1-col&ncols.;

		*-----start at the beginning of our select-----*;
		input @&start @;
		endrow=.;

		*-----read each row-----*;
		do i=1 to &nrows;
			*-----row starts with <TR or <tr tag-----*;
			input @"<&optiontag" @;
			startcol=c;

			*-----determine where to stop, using </tr, next <tr, or next <select-----*;
			%if &closetags.=Y %then
				%do;
					input @"</&optiontag" @;
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
							input @"<&selecttag " @;
							endrow=c-7;
						end;
				%end;

			*-----go back to start reading contents of row-----*;
			input @startcol @;

			*-----read all the column data for the row-----*;
			do j=1 to &ncols;
				*-----col starts with <TD or <td tag-----*;
				input @"<&optiontag" @;

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

				*-----compute where to end the column data using </td, <tr, or <select----*;
				%if &closetags.=Y %then
					%do;
						input @"</&selecttag" @;
					%end;
				%else
					%do;
						if j<&ncols then
							input @"<&optiontag" @;
						else if i<&nrows then
							input @"<&optiontag" @;
						else input @"</&selecttag" @;
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

	data select&selectnum.;
		set select&selectnum. end=eof;
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
	data select&selectnum.;
		set select&selectnum.(&drops &renames);
		&dates;
	run;

	*-----print the resultant select-----*;
	options nocenter;

	proc print data=select&selectnum.;
		title "select&selectnum.";
	run;

%mend readselect;

%readhtml('http://support.sas.com/certify/directory/index.hsql');
