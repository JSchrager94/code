******************************************************************************************************************************************************************

RESIDUAL ANALYSIS 

*******************************************************************************************************************************************************************;


*RESIDUAL ANALYSIS, SINGLE VARIABLE;

%macro mixC1b(dat,y,z,titl,wher);
*ods select Tests3 ;
data lsmeans; data diffs; data pred; run;
proc mixed data=derived.&dat noclprint ORDER=FORMATTED; *ORDER=INTERNAL; 
&wher;
    class   condition study_id &z;
    model  &y = group    &z/OUTPRED=pred RESIDUAL;
    lsmeans  condition  /diffs cl;    
    ods output lsmeans=lsmeans diffs=diffs;     
    title1 "Table 2a Pairwise p-values ";
    title2 "&y | &titl";
quit;  
 
*Residual analysis;
proc univariate data=pred normal plot;
	id study_id ;
	var StudentResid;
	histogram StudentResid;
run;
/*
PROC SORT DATA = LSMEANS; BY weeks CONDITION; QUIT;
proc print data=lsmeans(drop = DF   tValue  Alpha ) label ; *NOOBS;
 	*where effect = 'weeks*Condition';
	 var weeks condition Estimate StdErr  Lower  Upper Probt;
    label Probt = 'P-value';
    title3 'Estimated Change from Baseline'; 
	format estimate stderr  lower upper 8.2 ;
quit;  

PROC SORT DATA=DIFFS; BY weeks CONDITION  _condition; QUIT;
proc print data=diffs (drop = DF   tValue  Alpha); * NOOBS label; 
   where weeks = _weeks and effect not = 'condition';* or effect  = 'weeks';  
   *where weeks = _weeks ; 
    label Probt = 'P-value';
    title3 'Pairwise Comparisons';	
	var  weeks  condition _weeks  _condition Estimate StdErr Probt  Lower  Upper;
	format estimate stderr  lower upper 8.2;* CONDITION  _condition GROUP.;
quit; */
%MEND; 

/*call 1*/ 	%mixC1b(table2, ctc2s_score3mo, ,OUTCOME: CTS2S Score, );




*RESIDUAL ANALYSIS, CONTROLLING FOR BASELINE VARIABLES;

%macro mixC1b(dat,y,x,z,titl,wher);
*ods select Tests3 ;
data lsmeans; data diffs; data pred; run;
proc mixed data=derived.&dat noclprint ORDER=FORMATTED; *ORDER=INTERNAL; 
&wher;
    class   condition study_id &z;
    model  &y = group   &x &z/OUTPRED=pred RESIDUAL;
    lsmeans  condition  /diffs cl;    
    ods output lsmeans=lsmeans diffs=diffs;     
    title1 "Table 2a Pairwise p-values ";
    title2 "&y | &titl";
quit;  
 
*Residual analysis;
proc univariate data=pred normal plot;
	id study_id ;
	var StudentResid;
	histogram StudentResid;
run;
/*
PROC SORT DATA = LSMEANS; BY weeks CONDITION; QUIT;
proc print data=lsmeans(drop = DF   tValue  Alpha ) label ; *NOOBS;
 	*where effect = 'weeks*Condition';
	 var weeks condition Estimate StdErr  Lower  Upper Probt;
    label Probt = 'P-value';
    title3 'Estimated Change from Baseline'; 
	format estimate stderr  lower upper 8.2 ;
quit;  

PROC SORT DATA=DIFFS; BY weeks CONDITION  _condition; QUIT;
proc print data=diffs (drop = DF   tValue  Alpha); * NOOBS label; 
   where weeks = _weeks and effect not = 'condition';* or effect  = 'weeks';  
   *where weeks = _weeks ; 
    label Probt = 'P-value';
    title3 'Pairwise Comparisons';	
	var  weeks  condition _weeks  _condition Estimate StdErr Probt  Lower  Upper;
	format estimate stderr  lower upper 8.2;* CONDITION  _condition GROUP.;
quit; */
%MEND;  

/*call 1*/ 	%mixC1b(table2, ctc2s_score3mo, cts2s_score, ,OUTCOME: CTS2S Score, );
