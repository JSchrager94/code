data derived.table3;
	set raw.table3;

	*CREATION OF VICTIMIZATION SCORE;
*counting the number of missings;
	victim_nmiss = nmiss( q2, q3, q4, q5, q6, q7, q8, q9);
	label victim_nmiss = "Number of missing for Victimization score";

	*getting the percentage of missing questions;
	victim_pctmiss=(victim_nmiss*100)/8; *the total amount of variables in composite;
	label victim_pctmiss = "Percent missing Victimization score variables";

	*rounding the percentage of missing questions;
	victim_pctmiss_round=round(victim_pctmiss);
	label victim_pctmiss_round = "Percent missing Victimization score rounded version";

	*Victimization score;
	victim_score = sum ( q2, q3, q4, q5, q6, q7, q8, q9);*put mathematical operation for composite;
	label victim_score = " Victimization score";

	*if subject is missing more than 50% of the subscales then the restraint variable will be converted to missing;
	if restraint_pctmiss_round > 50 then restraint_score = .;
	*This is the cutoff value for missing values, PI should give this to you, otherwise, 20% or 50% is commonly used;


	run;
