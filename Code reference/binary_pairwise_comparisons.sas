**************************************************************************************************************************************************************

																PAIRWISE BINARY OUTCOME COMPARISONS

**************************************************************************************************************************************************************;


%macro gen (dat,y,titl);
ods select type3 diffs ;
Proc genmod data=derived.&dat DESCENDING;
                Class  group ;
                Model   &y =  group   / type3 LINK=LOGIT DIST=BIN; 
                       * estimate "nthweek" nthweek 1 /exp;                            
                        lsmeans group /exp diffs cl;
                        *repeated subject=study_id/ type=cs;
             title "&titl ";
                  format group group.;  
ods output LSMeans = LSMeans  Diffs= Diffs estimate=estimate;
Run;
%mend;
%gen(sec_out,cas_ipv_pos3mo,IPV Positive );

*CONTROLLING FOR BASELINE;
%macro gen (dat,y,x,titl);
ods select type3 diffs ;
Proc genmod data=derived.&dat DESCENDING;
                Class  group ;
                Model   &y =  group &x  / type3 LINK=LOGIT DIST=BIN; 
                       * estimate "nthweek" nthweek 1 /exp;                            
                        lsmeans group /exp diffs cl;
                        *repeated subject=study_id/ type=cs;
             title "&titl ";
                  format group group.;  
ods output LSMeans = LSMeans  Diffs= Diffs estimate=estimate;
Run;
%mend;
%gen(sec_out,cas_ipv_pos3mo, ,IPV Positive );
