%let path = Path name left out for Privacy;
libname raw "&Path\data\Raw";
libname derived "&Path\data\Derived";
libname output "&Path\documents\output";
footnote "SAS Program Stored in: &path\programs\Draft\Import OBGYN.sas";

/* IMPORT DATA */
/*PROC IMPORT OUT= raw.OBGYN*/
/*DATAFILE= "Path name left out for Privac\data\Raw\ex_pfaan.csv" */
/*DBMS=CSV REPLACE;*/
/*avoids truncation by checking x rows for format vs default 20*/
/*GUESSINGROWS = 4850;  */
/*GETNAMES=YES;*/
/*DATAROW=2;*/
/*RUN;*/

proc import out=raw.OBGYN
datafile="Path name left out for Privacy\data\Raw\ex_pfaan.csv" 
dbms=csv replace;
guessingrows=4860;
getnames=yes;
datarow=2;
run;

proc contents data= raw.OBGYN; run;
proc print data= raw.OBGYN (obs=50); 
var CASE_PROCEDURES;
run;
proc print data=raw.OBGYN;
where log_id = 295512;
run;


PROC IMPORT OUT= RAW.OBGYN 
            DATAFILE= "Path name left out for Privacy\data\Raw\EpiduralDB_edit1_DeID_jesse.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="'0$'"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


proc print data=raw.OBGYN(obs=50);
var Ketorolac_FIRST_DOSE_AFTER_IN_RO;
run;
ods rtf file = "Path name left out for Privacy\documents\output\Contents of data OBGYN &sysdate..doc" ;
proc contents data=raw.OBGYN;
run;
ods rtf close;

ods rtf file = "Path name left out for Privacy\documents\output\Summary Statistics OBGYN &sysdate..doc" ;
proc means data=raw.OBGYN maxdec=2 n nmiss max min mean median std;
run;
ods rtf close;


proc contents data=raw.OBGYN;
run;

proc print data=raw.OBGYN(obs=50);
var Base_Class RACE ETHNIC_GROUP CASE_PROCEDURES;
run;

/*FIND # OF SEMICOLINS*/
data test;
set raw.OBGYN;
num_semicolons = COUNTC(CASE_PROCEDURES, ";");
run;

proc print data= test;
where LOG_ID=295512;
var LOG_ID num_semicolons CASE_PROCEDURES;
run;

/* Creating numeric variables for analysis*/
data derived.OBGYN;
set raw.OBGYN;

/* creating new variable for time and dose from Ketorolac_FIRST_DOSE_AFTER_IN_RO */

drug= substr(Ketorolac_FIRST_DOSE_AFTER_IN_RO, 1, 5);
dose= substr(Ketorolac_FIRST_DOSE_AFTER_IN_RO, 49, 3);
date_time= substr(Ketorolac_FIRST_DOSE_AFTER_IN_RO, 58, 19);

if dose eq "PAH" then do ;
                            dose =30 ; date_time = "Apr 5 2016 12:52PM";

                    end;

new_date_time=input(date_time, anydtdtm.);
dosage = dose*1;

PROCEDURE_1 = SCAN(CASE_PROCEDURES, 1,";");
PROCEDURE_2 = SCAN(CASE_PROCEDURES, 2,";");
PROCEDURE_3 = SCAN(CASE_PROCEDURES, 3,";");
PROCEDURE_4 = SCAN(CASE_PROCEDURES, 4,";");
PROCEDURE_5 = SCAN(CASE_PROCEDURES, 5,";");
PROCEDURE_6 = SCAN(CASE_PROCEDURES, 6,";");
PROCEDURE_7 = SCAN(CASE_PROCEDURES, 7,";");
PROCEDURE_8 = SCAN(CASE_PROCEDURES, 8,";");
PROCEDURE_9 = SCAN(CASE_PROCEDURES, 9,";");
PROCEDURE_10 = SCAN(CASE_PROCEDURES, 10,";");
PROCEDURE_11 = SCAN(CASE_PROCEDURES, 11,";");

/*CP_01 = substr(CASE_PROCEDURES,1,5);*/
/*CP_02 = substr(CASE_PROCEDURES,8,13);*/


   
    /*Create new binary variables from the categorical ones*/
array old(*) MEDIAN_PAIN_SCALE_POD_1 IQR1 LOWER_QUARTILE_POD_1 UPPER_QUARTILE_POD_1 MEDIAN_PAIN_SCALE_POD_2 IQR2 
                 LOWER_QUARTILE_POD_2 UPPER_QUARTILE_POD_2 MEDIAN_PAIN_SCALE_POD_3 IQR3 LOWER_QUARTILE_POD_3 UPPER_QUARTILE_POD_3 

                 TOTAL_PO_POD0 TOTAL_PO_POD1 TOTAL_PO_POD2 TOTAL_PO_POD3 TOTAL_PO_POD4 TOTAL_PO_POD5;

array new (*)n_MEDIAN_PAIN_SCALE_POD_1 n_IQR1 n_LOWER_QUARTILE_POD_1 n_UPPER_QUARTILE_POD_1 n_MEDIAN_PAIN_SCALE_POD_2 n_IQR2 
                 n_LOWER_QUARTILE_POD_2 n_UPPER_QUARTILE_POD_2 n_MEDIAN_PAIN_SCALE_POD_3 n_IQR3 n_LOWER_QUARTILE_POD_3 n_UPPER_QUARTILE_POD_3 

                 n_TOTAL_PO_POD0 n_TOTAL_PO_POD1 n_TOTAL_PO_POD2 n_TOTAL_PO_POD3 n_TOTAL_PO_POD4 n_TOTAL_PO_POD5;

    do i = 1 to dim(new); 
             new(i) = 1*old(i); 
    end;


if n_TOTAL_PO_POD0 ne . then POD_0_500= (n_TOTAL_PO_POD0 ge 500);
if n_TOTAL_PO_POD1 ne . then POD_1_500= (n_TOTAL_PO_POD1 ge 500);
if n_TOTAL_PO_POD2 ne . then POD_2_500= (n_TOTAL_PO_POD2 ge 500);
if n_TOTAL_PO_POD3 ne . then POD_3_500= (n_TOTAL_PO_POD3 ge 500);
if n_TOTAL_PO_POD4 ne . then POD_4_500= (n_TOTAL_PO_POD4 ge 500);
if n_TOTAL_PO_POD5 ne . then POD_5_500= (n_TOTAL_PO_POD5 ge 500);




format new_date_time datetime18.;
run;
proc contents data=derived.OBGYN;
run;

/* QC on new case procdure variable*/
proc print data=derived.OBGYN;
where PROCEDURE_11 ne "";
var CASE_PROCEDURES PROCEDURE_:;
run;

proc sort data=derived.OBGYN;
by log_id;
WHERE LOG_ID NE .;
run;


proc print data=derived.OBGYN;
where CASE_PROCEDURES = "";
/*var LOG_ID CASE_PROCEDURES PROCEDURE_1-PROCEDURE_11;*/
run;

proc transpose data=derived.OBGYN OUT=PROCEDURES PREFIX=PROC;
by log_id;
WHERE CASE_PROCEDURES ne "";
var PROCEDURE_1-PROCEDURE_11;
run;

data derived.procedures;
set procedures;
n_proc1 = proc1*1;
run;

proc print data=procedures (obs=500);
run;


 /* QA on case procedures to original data*/
proc print data=procedures;
where LOG_ID = 84258;
run;
proc print data=procedures;
where proc1 eq "" and _NAME_ = "PROCEDURE_1";
run;

proc freq data=derived.procedures noprint;   
tables n_proc1/out= case_codes;
where n_proc1 ne .;
run;
proc sort data=case_codes;
by descending count;
run;


ods rtf file = "Path name left out for Privacy\documents\output\Case Procedures Summary Descending &sysdate..doc" ;
proc print data= case_codes;
run;
ods trf close;

ods rtf file = "Path name left out for Privacy\documents\output\Case Procedures summary &sysdate..doc" ;
proc freq data=derived.procedures;
tables n_proc1;
where n_proc1 ne .;
run;
ods rtf close;




/* QA on new date variable */
proc print data=derived.OBGYN (obs=50);
var date_time new_date_time;
run;


/*   QA  on POD_0_500,POD_1_500,POD_2_500,POD_3_500,POD_4_500,POD_5_500*/
%macro POD_QC (p,p_new);

proc means data= derived.OBGYN;
class &p;
var &p_new;
run;

proc freq data=derived.OBGYN;
tables &p*&p_new /list missing;
run;

%mend;


%POD_QC (POD_0_500,n_TOTAL_PO_POD0);
%POD_QC (POD_1_500,n_TOTAL_PO_POD1);
%POD_QC (POD_2_500,n_TOTAL_PO_POD2);
%POD_QC (POD_3_500,n_TOTAL_PO_POD3);
%POD_QC (POD_4_500,n_TOTAL_PO_POD4);
%POD_QC (POD_5_500,n_TOTAL_PO_POD5);


ods rtf file = "Path name left out for Privacy\documents\output\Binary count for POD over 500 &sysdate..doc" ;
proc freq data=derived.OBGYN;
table POD_0_500 POD_1_500 POD_2_500 POD_3_500 POD_4_500 POD_5_500;
run;
ods rtf close;


/* QA  on date time variable*/
proc print data=derived.OBGYN (obs=50);
var Ketorolac_FIRST_DOSE_AFTER_IN_RO drug dose date_time;
run;
proc freq data=derived.OBGYN;
table date_time dosage drug;
run;
/* QC on obs 2050 */
proc print data=derived.OBGYN;
var Ketorolac_FIRST_DOSE_AFTER_IN_RO drug dose date_time MRN; 
where MRN eq 7512171;
run;



ods rtf file = "Path name left out for Privacy\documents\output\Summary Statistics pain scores &sysdate..doc" ;
Proc means data=derived.OBGYN maxdec=2 n nmiss mean std min max median qrange;
var n_MEDIAN_PAIN_SCALE_POD_1 n_IQR1 n_LOWER_QUARTILE_POD_1 n_UPPER_QUARTILE_POD_1 n_MEDIAN_PAIN_SCALE_POD_2 n_IQR2 
    n_LOWER_QUARTILE_POD_2 n_UPPER_QUARTILE_POD_2 n_MEDIAN_PAIN_SCALE_POD_3 n_IQR3 n_LOWER_QUARTILE_POD_3 n_UPPER_QUARTILE_POD_3;
    title "Descriptive Statistics on Pain Scores";
run;
title close;
ods rtf close;

ods rtf file = "Path name left out for Privacy\documents\output\Summary   Statistics pain scores by Epidural yes_no  &sysdate..doc" ;

Proc means data=derived.OBGYN maxdec=2 n nmiss mean std min max median qrange;
var n_MEDIAN_PAIN_SCALE_POD_1 n_IQR1 n_LOWER_QUARTILE_POD_1 n_UPPER_QUARTILE_POD_1 n_MEDIAN_PAIN_SCALE_POD_2 n_IQR2 
    n_LOWER_QUARTILE_POD_2 n_UPPER_QUARTILE_POD_2 n_MEDIAN_PAIN_SCALE_POD_3 n_IQR3 n_LOWER_QUARTILE_POD_3 n_UPPER_QUARTILE_POD_3;
class EPIDURAL;
    title "Descriptive Statistics on Pain Scores";
run;

Proc npar1way data=derived.OBGYN anova;
var n_MEDIAN_PAIN_SCALE_POD_1  n_MEDIAN_PAIN_SCALE_POD_2  n_MEDIAN_PAIN_SCALE_POD_3;
class EPIDURAL;
    title "Descriptive Statistics on Pain Scores";
run;
ods rtf close;



/* QA on missing values for pain score*/
proc print data=derived.OBGYN;
var MEDIAN_PAIN_SCALE_POD_1;
where n_MEDIAN_PAIN_SCALE_POD_1 = . and MEDIAN_PAIN_SCALE_POD_1  ne "";
run;


/* Base_Class, RACE, ETHNIC_GROUP, CASE_PROCEDURES  */     /* age*/
/* CASE_PROCEDURES has 0 missing values (we need to clean variable) */     ****************************************************************
proc contents data=raw.OBGYN;
run;
proc print data=raw.OBGYN(obs=50);
var Base_Class RACE ETHNIC_GROUP CASE_PROCEDURES;
run;


ods rtf file = "Path name left out for Privacy\documents\output\Summary Statistics Base_Class, RACE, ETHNIC_GROUP, CASE_PROCEDURES &sysdate..doc" ;
proc freq data= raw.OBGYN;
tables Base_Class RACE ETHNIC_GROUP CASE_PROCEDURES;
run;
ods rtf close;



/* Length of Stay (LOS)TOTAL_PO_POD0 TOTAL_PO_POD1 TOTAL_PO_POD2 TOTAL_PO_POD3 TOTAL_PO_POD4 TOTAL_PO_POD5 */
ods rtf file = "Path name left out for Privacy\documents\output\Summary Statistics Length of stay &sysdate..doc" ;
  Proc means data=derived.OBGYN maxdec=2 n nmiss mean std min max median qrange;
var LOS n_TOTAL_PO_POD0 n_TOTAL_PO_POD1 n_TOTAL_PO_POD2 n_TOTAL_PO_POD3 n_TOTAL_PO_POD4 n_TOTAL_PO_POD5;
title "Decriptive Statistics on LOS TOTAL_PO_POD0 TOTAL_PO_POD1 TOTAL_PO_POD2 TOTAL_PO_POD3 TOTAL_PO_POD4 TOTAL_PO_POD5";
 run; 
title close;
ods rtf close;


/* Length of stay QC */
ods rtf file = "Path name left out for Privacy\documents\output\QC on Length of stay &sysdate..doc" ;
proc univariate data= derived.OBGYN;
var LOS;
id LOG_ID MRN;
run;
ods rtf close;


/* Date and time and dose are important: (delimited by -)
   Create two more variables one for dose and on for date and time
        Ketorolac_FIRST_DOSE_AFTER_IN_RO*/

proc print data=derived.OBGYN (obs=50);
var Ketorolac_FIRST_DOSE_AFTER_IN_RO;
run;








