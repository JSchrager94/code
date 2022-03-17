



******creating pre year variable for piecewise regression;
data derived.oycy_count_states;
set derived.oycy_count_states;
year2008p = max(0, year-2008);
run;

*Qa;
proc freq data=derived.oycy_count_states;
where state ne "OH";
	tables year*year2008p/list missing;
run;

*********doing piecewise linear regression to compare slopes of states before 2008 and after 2008 seperately;
ODS RTF FILE="T:\documents\output\Piecewise Linear Regression &sysdate..rtf"style=journal;
ods graphics on;
proc glm data=derived.oycy_count_states plots=all;
class state;
where state ne "OH";
		title2 ’Fit a change point model with known change point in 2008’;
			model cum_diff = year year2008p state year|state year2008p|state/solution;
		lsmeans state / stderr pdiff;
	*ods output ParameterEstimates=est2008cp;
	output out=predfit pred=pred;
run;
quit;
ods graphics off;
ods rtf close;



data new2009;
	set raw.residency;
		year2009p = max(0, year-2009);
run;

*Qa;
proc freq data=new2009;
	tables year*year2009p/list missing;
run;

*********doing piecewise linear regression to compare slopes of states before 2008 and after 2008 seperately;
*ODS RTF FILE="T:\documents\output\Piecewise Linear Regression &sysdate..rtf"style=journal;
ods graphics on;
proc glm data=new2009 plots=all;
*class sex;
		title2 ’Fit a change point model with known change point in 2009’;
			model surg_natl_med_abhyst_ = year year2009p/solution;
	*ods output ParameterEstimates=est2008cp;
	output out=predfit  PREDICTED=  PREDICTED;
run;
quit;
ods graphics off;
*ods rtf close;
proc contents data=predfit; run;
symbol1 i=none v=dot c=black;
symbol2 i=join v=none c=blue;
proc gplot data=predfit;
plot (surg_natl_med_abhyst_ PREDICTED)*year/overlay;
run;
quit;

