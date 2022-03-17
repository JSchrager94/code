*****************************************************************************************************************************************************************

																	PAIRWISE COMPARISONS

*****************************************************************************************************************************************************************;

*SINGLE VARIABLE;

%macro mixC1c(dat,y,z,titl,wher);
ods select Tests3 ;
data lsmeans; data diffs; run;
proc mixed data=derived.&dat noclprint ORDER=FORMATTED; *ORDER=INTERNAL; 
&wher;
    class  condition study_id &z; *Z IS CATEGORICAL VARIABLES
    model  &y = condition    &z/OUTPRED=pred RESIDUAL;
    lsmeans condition  /diffs cl;
    ods output lsmeans=lsmeans diffs=diffs;     
    title1 "Table 2a Pairwise P-values ";
    title2 "&y | &titl";
quit;  
 

PROC SORT DATA = LSMEANS; BY CONDITION; QUIT; *GIVES OVERALL F VALUE, GENERAL IS THERE A DIFFERENCE
proc print data=lsmeans(drop = DF   tValue  Alpha ) label ; *NOOBS;
 	*where effect = 'weeks*Condition';
	 var  condition Estimate StdErr  Lower  Upper Probt;
    label Probt = 'P-value';
    title3 'Overall Comparisons'; 
	format estimate stderr  lower upper 8.2 CONDITION  _condition GROUP.;
quit;  

PROC SORT DATA=DIFFS; BY CONDITION  _condition; QUIT; *GIVES PAIRWISE COMPARISONS, SHOWS THE DIFFERENCES BETWEEN GROUPS;
proc print data=diffs (drop = DF   tValue  Alpha); * NOOBS label; 
   *where  effect not = 'condition';* or effect  = 'weeks';  
   *where weeks = _weeks ; 
    label Probt = 'P-value';
    title3 'Pairwise Comparisons';	
	var   condition  _condition Estimate StdErr Probt  Lower  Upper;
	format estimate stderr  lower upper 8.2 CONDITION  _condition GROUP.;
quit; 
%MEND;

/*call 1*/ 	%mixC1c(table2, cts2s_score3mo, ,OUTCOME: CTS2S Score, where study_id ne 1128 );


*PAIRWISE COMPARISONS, CONTROLLING FOR BASELINE;

%macro mixC1c(dat,y,x,z,titl,wher);
ods select Tests3 ;
data lsmeans; data diffs; run;
proc mixed data=derived.&dat noclprint ORDER=FORMATTED; *ORDER=INTERNAL; 
&wher;
    class  condition study_id &z; *Z IS ANY CATEGORICAL VARIABLES INCLUDED;
    model  &y = condition   &x &z/OUTPRED=pred RESIDUAL;
    lsmeans condition  /diffs cl;
    ods output lsmeans=lsmeans diffs=diffs;     
    title1 "Table 2a Pairwise P-values ";
    title2 "&y | &titl";
quit;  
 

PROC SORT DATA = LSMEANS; BY CONDITION; QUIT;*GIVES OVERALL F VALUE, IS THERE A DIFFERENCE BETWEEN GROUPS;
proc print data=lsmeans(drop = DF   tValue  Alpha ) label ; *NOOBS;
 	*where effect = 'weeks*Condition';
	 var  condition Estimate StdErr  Lower  Upper Probt;
    label Probt = 'P-value';
    title3 'Overall Comparisons'; 
	format estimate stderr  lower upper 8.2 CONDITION  _condition GROUP.;
quit;  

PROC SORT DATA=DIFFS; BY CONDITION  _condition; QUIT;*GIVES POST HOC TEST, PAIRWISE COMPARISONS;
proc print data=diffs (drop = DF   tValue  Alpha); * NOOBS label; 
   *where  effect not = 'condition';* or effect  = 'weeks';  
   *where weeks = _weeks ; 
    label Probt = 'P-value';
    title3 'Pairwise Comparisons';	
	var   condition  _condition Estimate StdErr Probt  Lower  Upper;
	format estimate stderr  lower upper 8.2 CONDITION  _condition GROUP.;
quit; 
%MEND;

/*call 1*/ 	%mixC1c(table2, cts2s_score3mo, cts2s_score, ,OUTCOME: CTS2S Score, where study_id ne 1128 );
