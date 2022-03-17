*******************************************************************************************************************************************************************

															MORE THAN 2 LEVEL CATEGORICAL PAIRWISE COMPARISONS

*****************************************************************************************************************************************************************; 

%macro gen (y,titl);
ods select type3 estimate  Diffs ;
Proc genmod data=derived.scq2 DESCENDING; *where  kcal_missing=0 and icudays_12 = 1 and remain_oral=0;
                Class  	&y;
                Model   scq_bin =  &y  / type3 dist=bin link=logit ;                                
                        lsmeans &y /exp diff cl;
                        *repeated subject=study_id/ type=cs;
             title "&titl &y";  
*ods output LSMeans = LSMeans  Diffs= Diffs estimate=estimate;
quit;
Run;
%mend gen;

ods rtf file="U:\Nancy Burnham\CHOP\ASD001\documents\output\Categorical pairwise comparisons &sysdate..rtf" style=journal;
%gen(Mother_education_4_year, );
%gen( SES_class_4_year, );
%gen( genetic_exclusion_new, );
ods rtf close;
