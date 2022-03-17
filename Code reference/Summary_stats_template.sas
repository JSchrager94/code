*used for macro calls;
/*%include "U:\SAMPLE_SAS_PROGRAM\macros\Summary_stats_template.sas";*/

*******************************************************************************************************************
Useful macros that we can call into other programs
******************************************************************************************************************;
*Don't forget your place holder var;
/*%Let datas=library.dataset name;*/

***************************************************
Most Common
**************************************************;

*generate contents on dataset. Do not list variables;
%macro getcont();
    proc contents data=&datas;
/*	title4 font=Calibri j=left height=14pt color=&color "Proc cont: &var. variable";*/
	quit;
%mend getcont;

*generate frequency on categorical variables. Must list for each variable;
%macro getfreq(var,color);
      proc freq data= &datas;
      table &var;
/*      title4 font=Calibri j=left height=14pt color=&color "Proc freq: &var. variable";*/
      quit;
%mend getfreq;
 
*hides labels;
/* options nolabel; */

*generate means on continuous variables;
%macro getmeans(); *var,color;
      proc means data=&datas n nmiss mean std min p25 median p75 max maxdec=2;
/*      var &var;*/
/*      title4 font=Calibri j=left height=14pt color=&color "Proc means: &var. variable";*/
      quit;
%mend getmeans;
 
*%Let out= directory;

/*ods rtf file="&out\title &sysdate..rtf" style=journal;*/
/**/
/*...*/
/*ods pdf close;*/

**********
Others
*********;
 
*generate box plots on continuous variables, please note there is a ‘vnum’ variable you may need to change it to the name of visit variable in your dataset;
%macro getbox (var,color);
      proc boxplot data= &datas ;
            plot (&var)*vnum/boxstyle=schematic;
            title4 font=Calibri j=left height=14pt color=&color "Box Plot: &var. (for each time point)";
      quit;
%mend getbox;
 
 
*generate scatter plots on continuous variables that need to be compare to each other;
%macro getscatter(var1, var2, color, title);
title4 font=Calibri j=left height=14pt color=&color "Scatter Plot: &title.";
proc gplot data= &datas;
      where &var1 ne . and &var2 ne .;
      symbol value=dot color=black height=1;
      plot &var1 * &var2;
run; quit;
%mend getscatter;
 
 
*IMPORTANT: here are the macro calls, be sure to use the actual variable name where you see the word ‘var’ 
(the variable name should not have any spaces);

/*%getcont();*/
/*%getfreq(var,blue);*/
/*%getmeans();*/
/*%getbox(var,green);*/
/*%getscatter(var1,var2,purple,var1 vs var2 over all timepoints);*/

 
