To convert character variables containing numeric data to numeric variables containing the same numeric data while retaining variable names, use the following:
 data chardata;
x='12345';y='0987'; output;   /*test data, ALL character data*/
a='3';b='4';output;

/*variable names and position*/
proc contents noprint data=chardata out=varname(keep=name npos);
run;


/*sort by position in the data set, yields variables
in the order they appear in the data set*/

proc sort;
by npos;


data _null_;
 do i=1 to nobs;
   set varname nobs=nobs end=end;
    call symput('mac'||left(put(i,4.)),name); /*creates macro variables for name of variables*/
    call symput('num'||left(put(i,4.)),'num'||left(put(i,4.)));       /*creates new macro numeric variables*/
    if end then call symput('end',put(nobs,8.));   /*determines number of variables, 1 per observation*/
 end;         /*assumes none of character variables are larger than 8 bytes*/
run;


/*macro generates the drop and rename, so numeric variables have original names*/
%macro create;
 data numdata(drop= %do i=1 %to &end;&&mac&i %end; rename=(%do i=1 %to &end; &&num&i=&&mac&i  %end;));
set chardata ;
     %do i=1 %to &end;
               &&num&i=input(&&mac&i,5.);     /*creates numeric macro variables, which resolve to num1-num5*/
     %end;
 run;
%mend;


%create;


proc contents data=numdata;   /*verifies new data set is all numeric variables*/
run;
