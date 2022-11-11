/********************************************************************************/
/* Variable Definitions: */

/* x = binary [0,1] treatment variable*/
/* y = binary [0,1] outcome variable */
/* c1 - c5 = binary [0,1] covariates */
/* y_dur = time until censoring for event y=*/
/********************************************************************************/

/* Propensity score is the conditional probability of being treated based on individual covariates 

   Use logistic regression to predict probability of event occuring as a function of independent variables (continuous or dichotmous)
    (proc logistic or proc genmod) creates data set with predicited treatment probabilities as a variable 
  			proc logistic data = indsn;
			class naive0;
			model tx (event=’Drug A’) = age female b_hmopre_drug_cnt_subset naive0 
			pre_refill_pctcopay_idxdrug pre_sulf pre_htn pre_asthmapre_pain pre_lipo 
			pre_depress/link=logit rsquare;
			output out = psdataset pred = psxbeta=logit_ps;
			run;


   These Scores by MATCHING scores by p scores can balance groups on covariates      ***Need to decide what your matching on and what is considered a match
     1:1 or 1:many  
          Different methods ( Stratified, NN Nearest neighbor, Radius Matching, Caliber, Kernal Matching, Mahalanobis Metric) 


    ******** Main Goal is to increase balance between groups ***********/




















/********************************************/
/* Estimating a propensity score*/
/********************************************/


/* Modeling treatment = 1 given covariates and outputting data with the propensity score
into a new dataset, 'PS_DATA'
PS = estimated propensity score */
PROC LOGISTIC DATA=raw_data DESCENDING;
 MODEL x = c1 c2 c3 c4 c5;
 OUTPUT OUT=ps_data PROB=ps;
 TITLE "Estimation of the propensity score from measured covariates";
RUN;

/********************************************/
/* Evaluating the PS distribution */
/********************************************/


/* Creating PS treatment groups for plotting */
DATA ps_data;
 SET ps_data;
 IF x = 1 THEN treated_ps = ps;
  ELSE treated_ps = .;
 IF x = 0 THEN untreated_ps = ps;
  ELSE untreated_ps = .;
RUN;
/* Plot the overlap of the PS distributions by treatment group
Turn on ODS output to get high quality graphics saved as an image file
PLOTS=ALL gives you multiple plots. If you only want the overlay plot,
use PLOTS=DENSITYOVERLAY */
ODS GRAPHICS ON;
PROC KDE DATA=ps_data;
 UNIVAR untreated_ps treated_ps / PLOTS=densityoverlay;
 TITLE "Propensity score distributions by treatment group";
RUN;
ODS GRAPHICS OFF;


/********************************************/
/* Calculating PS weights! ! ! ! ! */
/********************************************/

/* Calculating the marginal probability of treatment for the stabilized IPTW */
PROC MEANS DATA=ps_data(keep=ps) NOPRINT;
 VAR ps;
 OUTPUT OUT=ps_mean MEAN=marg_prob;
RUN;
DATA _NULL_;
 SET ps_mean;
 CALL SYMPUT("marg_prob",marg_prob);
RUN;

/* Calculating weights from the propensity score */
DATA ps_data;
 SET ps_data;
 *Calculating IPTW;
 IF x = 1 THEN iptw = 1/ps;
  ELSE IF x = 0 then iptw = 1/(1-ps);
 *Calculating stabilized IPTW;
 IF x = 1 THEN siptw = &marg_prob/ps;
  ELSE IF x = 0 THEN siptw = (1-&marg_prob)/(1-ps);
 *Calculating SMRW;
 IF x = 1 THEN smrw = 1;
  ELSE IF x = 0 THEN smrw = ps/(1-ps);
 LABEL! ps = "Propensity Score"
   iptw = "Inverse Probability of Treatment Weight"
   sisptw = "Stabilized Inverse Probability of Treatment Weight"
   smrw = "Standardized Mortality Ratio Weight";
RUN;

/********************************************/
/* Evaluating the weights and preparing for */
/* trimming if necessary */
/********************************************/


/* Performing univariate analysis on the weight variables by treatment status
   to check for extreme weights */
PROC UNIVARIATE DATA=ps_data;
 CLASS x;
 VAR iptw siptw smrw;
 TITLE "Evaluating weights by treatment group";
RUN;

/* Identifying percentiles at the upper and lower extremes of the untreated and treated
   PS distributions for trimming, if needed. If other percentiles are needed, they can
   be created in the OUTPUT statement either by using a predefined SAS percentile,
   or by creating one in PCTLPTS=" */
PROC UNIVARIATE DATA=ps_data NOPRINT;
 CLASS x;
 VAR ps;
 OUTPUT OUT=ps_pctl MIN=min MAX=max P1=p1 P99=p99 PCTLPTS=0.5 99.5 PCTLPRE=p;
 title "Distribution of Propensity Score for Statin use, by statin use";
RUN;

/* Labeling the percentiles at the lower extremes of the treated in macro variables which can be
   called later.
   Defining the minimum, 0.5th percentiles, and 1st percentile of the treated */
DATA _NULL_;
 SET ps_pctl;
 WHERE x = 1;
 CALL SYMPUT("treated_min",min);
 CALL SYMPUT("treated_05",p0_5);
 CALL SYMPUT("treated_1",p1);
RUN;

/* Labeling the percentiles at the upper extremes of the untreated in macro variables
   which can be called later.
   Defining the maximum, 99th, and 99.5th percentile of the untreated. */
DATA _NULL_;
 SET ps_pctl;
 WHERE x = 0;
 CALL SYMPUT("untreated_max",max);
 CALL SYMPUT("untreated_99",p99);
 CALL SYMPUT("untreated_995",p99_5);
RUN;

/* When applying PS weights to analyses, these defined percentiles can be applied to trim areas
   of non-overlap and individuals treated contrary to prediction.
   To trim non-overlapping regions of the PS distribution, include the following statement
   in the modeling procedure: WHERE &treated_min <= ps <= &untreated_max;
   To trim those treated contrary to prediction, include the following
   statement: WHERE &treated_05 <= ps <= &untreated_995
   Trimming percentiles can be moved in progressively as far as desired */


/********************************************/
/* Checking for treatment effect ! ! ! */
/* heterogeneity! ! ! ! ! ! ! */
/********************************************/

/* Stratify the PS distribution into deciles
 If a different number of strata are desired, change to the desired number, N, in
 the GROUPS statement
 If changing the number of strata, also change the number in the '%DO i=0 %TO N'
 statement below to N-1 */
/* Create a new dataset with the strata indicator variables, 'ps_strata'
 Create a new variable for the strata rank, 'ps_decile' */
PROC RANK DATA=ps_data
 GROUPS = 10
 OUT = ps_data;
 VAR ps;
 RANKS ps_decile;
RUN;

/* Evaluate the outcomes, PS, and weights by treatment in each strata
Check for heterogeneity of treatment effect across the strata
Create a macro to perform the descriptive statistics and estimate
effect measure in each decile */
%MACRO deciles;
%DO i= 0 %TO 9;
PROC FREQ DATA=ps_data;
 WHERE ps_decile = &i;
 TABLE y*x;
 TITLE "Outcome Y by Exposure X in PS deciles in decile &i";
run;
PROC MEANS DATA=ps_data MIN MEDIAN MAX MEAN;
 WHERE ps_decile = &i;
 CLASS X;
 VAR ps iptw siptw smrw;
 TITLE "Distribution of PS and weights by treatment in decile &i";
RUN;
/* y_dur is the time until censoring for event y */
PROC PHREG DATA=ps_data;
 WHERE ps_decile = &i;
 CLASS x / desc;
 MODEL y_dur*y(0) = x;
 HAZARDRATIO x;
 TITLE "Hazard ratio of Exposure X on Outcome Y in decile &i";
RUN;
%END;
%MEND deciles;
/* Call the macro to estimate frequencies, PS distributions, and effect measures in each strata */
%deciles;
/* The weights can be applied to various modelling PROCs in SAS, or PS matching
   can be performed using any number of matching algorithms */
