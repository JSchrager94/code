*********
				ARRAY FOR JULIO-MACRO RETAIN STATEMENT
																******************;


data derived.high_signal;
	set derived.high_signal;
	by sourceid;

	
	array six (*) vta r_nacc l_nacc r_ofc l_ofc r_amy l_amy r_ins l_ins r_hipp l_hipp hypothalamus r_acc l_acc r_tha l_tha R_DLPFC L_DPLFC;
	array bl (*) bl_vta bl_r_nacc bl_l_nacc bl_r_ofc bl_l_ofc bl_r_amy bl_l_amy bl_r_ins bl_l_ins bl_r_hipp bl_l_hipp bl_hypo bl_r_acc bl_l_acc bl_r_tha bl_l_tha bl_r_pfc bl_l_pfc;
	array change (*)change_vta change_r_nacc change_l_nacc change_r_ofc change_l_ofc change_r_amy change_l_amy change_r_ins change_l_ins change_r_hipp change_l_hipp change_hypo change_r_acc change_l_acc change_r_tha change_l_tha change_r_pfc change_l_pfc;

	retain bl;
		if first.sourceid and event="baseline_arm" then do i=1 to dim(six); bl(i) = six(i);
	end;
	do i=1 to dim(six);
		change(i) = six(i) - bl(i);
	end;

run;

*QA;
proc print data=derived.high_signal (obs=50);
var sourceid event vta bl_vta change_vta l_nacc bl_l_nacc change_l_nacc r_ins bl_r_ins change_r_ins;
run;
