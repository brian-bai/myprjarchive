PROC IMPORT OUT= MYLIB.bookings 
            DATAFILE= "D:\brian\SAS\sasworkspace\sampleforsas\Bookings.x
lsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
