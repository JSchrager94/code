
**********************************
partial r-squared code
*********************************;


%macro partial(y,x,z,wher,titl);

/*proc glm data=attend;*/
/*	&wher;*/
/*	class &x; */
/*	model weight_change = &x &z/ss3;*/
/*	title1 'partial corr using GLM and manova |OUTCOME: M24 WEIGHT_CHANGE';*/
/*	title2 &titl;*/
/*run;*/

	proc reg data=attend; where condition ne 1;
		model weight_change= &x &z / pcorr1 pcorr2;
		title1 'partial corr using reg';
		title2 "&titl";
	run;
	quit;

%mend;


 

ods rtf file="C:\bsc\project\CWED\biostats\power\Documents\Reports\LCV vs weight_change partial corr &today..rtf" style=journal; OPTIONS PAGENO = 1; *LCV;

%partial(  ,conditionc gender black  site1 site3 site4 site5 site6   age1, ,where condition ne 1,
No PCPV and No LCV);

%partial(  ,conditionc gender black  site1 site3 site4 site5 site6 age1 pcpv_month_total_avg, ,where condition ne 1, add PCPV but no LCV);

%partial(  ,conditionc gender black site1 site3 site4 site5 site6  age1	pcpv_month_total_avg
lcv_month_total_avg , ,where condition ne 1, add PCPV and LCV );

%partial(  ,conditionc gender black site1 site3 site4 site5 site6  age1	lcv_month_total_avg ,
,where condition ne 1, add LCV but no PCPV ); ods rtf close;
