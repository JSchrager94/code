************************************************************************************************************************************
USING A MACRO TO BRING IN single SHEET OF AN EXCEL FILE, DON'T HAVE TO MANUALLY IMPORT DATA
**********************************************************************************************************************************;
options fmterr=no  compress=yes mprint;
PROC IMPORT OUT= work.Followup /*what the dataset will be called once brought in*/
            DATAFILE= "U:\Karin Rhodes\NIAAA\MAIN_PAPER_Spring_2013\data\Raw\IDs_DSMB_Data_9-9-2013.xlsx" /*path of where excel file exists*/ 
            DBMS=EXCEL REPLACE;
     RANGE="Follow-up$";/*Sheet you want brought in*/ 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

proc print data=Followup; run; *to check if brought in correctly;

******************************************************************************************************************************
USING A MACRO TO BRING IN MULTIPLE SHEETS OF AN EXCEL FILE
*********************************************************************************************************************************;



%let directory=C:\Users\tes57\Dropbox\bsc\project\SON\biostats\hanlonale20120531;*this is where the subdirectory that has the exel file is located;

/*Import All Excel Sheet*/ 
%macro readin(sheet,datn); /*([Sheet name in excel workbook], [what you want the dataset to be called])*/
PROC IMPORT OUT= raw.&datn /*what the dataset will be called THIS IS SET TO HAVE IT SENT TO THE RAW SUBDIRECTORY*/
            DATAFILE= "&directory\data\raw\Absent.xlsx" /*the path to where excel file exits*/
            DBMS=EXCEL REPLACE;
			SHEET="'&sheet$'"; 
			GETNAMES=YES;
		     MIXED=NO;
		     SCANTEXT=YES;
		     USEDATE=YES;
		     SCANTIME=YES;
RUN;
%mend;

%readin(e,d2011_2012); *for example, this dataset set is from Sheet E in Excel Workbook and will be called raw.d2011_2012;
%readin(B, d2010_2011);
%readin(C, d2009_2010);
%readin(D, d2008_2009);
%readin(P, d2007_2008);
%readin(F, d2006_2007);


run;
