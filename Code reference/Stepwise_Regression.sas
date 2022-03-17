********************************************************************************************************************************************************************************************

Name:                       Stepwise Regression

Statistician:	            Jesse L. Chittams and Amos Odeleye

********************************************************************************************************************************************************************************************;

proc reg data=merg_all;

model WEIGHT_CHANGE = gender black age1  site1 site3 site4 site5 site6
                      cognitive_rest_m6 disinhibition_m6 hunger_m6 FRTVEG_TRIM_m6
                      predict_pcf_m6 calc9_m6 pcpv_month0_6_avg_m6 pct_food_diaries_m6
					  lcv_month0_6_avg/
                      SELECTION=stepwise RSQUARE SLS=0.2 SLE=0.1 include=8;
title1 'Table_';
quit;title;

/* 
        NOTE-You may force it to "INCLUDE=i" the first "i" predictors, 
        START=n with n predictor models, and STOP=n with n predictor models.
   
        In the model above, we are FORCING the first 8 variables 
        (gender black age1 site1 site3 site4 site5 site6)
*/
