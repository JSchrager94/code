/*THE JULIO MACRO, FOR PAIRWISE COMPARISONS BETWEEN VARIABLE AND CLASS*/

/*Simple pairwise comparison*/
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

*Call statement; %mixC1c(cts2s_score3mo, , ,OUTCOME: CTS2S Score, where study_id ne 1128 );








/*A nested macro for comparison of 2 variables, while controlling for baseline of the variable in the call statement.
All the variables in the inner loop will be compared to the variable specified in the call statement*/
%macro mixC1c(y,c,z,titl,wher);
%macro mixC1d(x);
ods select Tests3 diffs  lsmeans;
data lsmeans; data diffs; run;
proc mixed data= derived.mod3mo noclprint ORDER=FORMATTED; *ORDER=INTERNAL; 
&wher;
    class  condition study_id &x &z;
    model  &y = condition condition*&x &x &z/OUTPRED=pred RESIDUAL;
    lsmeans condition*&x  /diffs cl;
    ods output lsmeans=lsmeans diffs=diffs Tests3=Tests3;     
    title1 "Table 2a Pairwise P-values With Moderators";
    title2 "&y | &titl";
quit;  

proc print data = Tests3;
run;
 
/*
PROC SORT DATA = LSMEANS; BY CONDITION; QUIT;
proc print data=lsmeans(drop = DF   tValue  Alpha ) label ; *NOOBS;
 	*where effect = 'weeks*Condition';
	 var  condition Estimate StdErr  Lower  Upper Probt;
    label Probt = 'P-value';
    title3 'Overall Comparisons'; 
	format estimate stderr  lower upper 8.2 CONDITION   GROUP.;
quit;  

PROC SORT DATA=DIFFS; BY CONDITION  _condition; QUIT;
proc print data=diffs (drop = DF   tValue  Alpha); * NOOBS label; 
   *where  effect not = 'condition';* or effect  = 'weeks';  
   *where weeks = _weeks ; 
    label Probt = 'P-value';
    title3 'Pairwise Comparisons';	
	var   condition  _condition Estimate StdErr Probt  Lower  Upper;
	format estimate stderr  lower upper 8.2 CONDITION  _condition GROUP.;
*/
quit; 
%MEND; 
%mixC1d(web_battering);
%mixC1d(danger_cat);
%mixC1d(alchdepend);
%mixC1d(drugs_any);
%mixC1d(drug_ill_rx);
%mixC1d(depression_flag);
%mixC1d(ptsd_flag);
%mixC1d(csa);
%mixC1d(partner_drink);
%mixC1d(audit_c_scorepd);
%mixC1d(pdheavy_drink);
%mend; 

*Call statement; %mixC1c(cts2s_score3mo, cts2s_score, ,OUTCOME: CTS2S Score, where study_id ne 1128 );






/*Pairwise comparison looking at the interaction between group and a time variable */

%macro mixC1b(dat,y,x,titl,wher);
ods select Tests3 ;
data lsmeans; data diffs; data pred; run;
proc mixed data=raw.&dat noclprint ORDER=FORMATTED; *ORDER=INTERNAL; 
&wher;
    class   group study_id ;
    model  &y = group|nthweek  &x /OUTPRED=pred RESIDUAL;
    *lsmeans  condition  /diffs cl;    
    ods output lsmeans=lsmeans diffs=diffs;    
	repeated /type=cs subject =study_id;
    title1 "&y | &titl";
quit;  
 
*Residual analysis;
/*proc univariate data=pred normal plot;*/
/*	var StudentResid;*/
/*run;*/
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

*Call Statements;
%mixC1b(dsmb201404long,q12, ,Percent of heavy drinking days vs Group and week q12, where q12 > 0 );
%gen(violance,q2, ,Percentage of any verbal abuse q2, where q2 > 0 );
