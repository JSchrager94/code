%macro intplot(y,x,fmt,titl);
Goptions reset=all vsize=4in ftext=simplex device=GIF lfactor=2
gsfmode= replace gsfname=graphout gsfmode= replace;

symbol1 c = red interpol=STD1MJ v=none l=1; *l is line type;
symbol2 c = black interpol=STD1MJ v=none l=2; *1 = solid line, 2 = dashed;
symbol3 c = green interpol=STD1MJ v=none l=3; *l is line type;
symbol4 c = blue interpol=STD1MJ v=none l=4; *1 = solid line, 2 = dashed;

options orientation=landscape;
Proc Gplot data=derived.mod3mo;
AXIS1 LABEL = (C=black F=SWISSB  a=90 H=1.5 )
         MINOR=NONE VALUE=(H=1 F=SWISSB) ;
axis2 label = (c=black f=swissb h=1.5) minor=none
 value=(h=1 F=SWISSB);
plot &y*group=&x
/vaxis=axis1 haxis=axis2 ;
where &x ne .;
format group group. &x &fmt.;
title "&titl";
run;

%mend;


ods rtf file= "U:\Karin Rhodes\NIAAA\MAIN_PAPER_Spring_2013\documents\output\ Table 2a plots of moderator interactions &sysdate..rtf" style=journal;

%intplot(audit_score3mo,alchdepend,alch.,AUDIT_SCORE3MO AND ALCHDEPEND INTERACTION);
%intplot(audit_c_score3mo,alchdepend,alch.,AUDIT_C_SCORE3MO AND ALCHDEPEND INTERACTION);
%intplot(fu3i_65,alchdepend,alch.,HEAVY DRINKING AND ALCHDEPEND INTERACTION);
%intplot(cas_tot3_score,web_battering,web.,COMPOSITE ABUSE SCORE AND WEB BATTERING INTERACTION);
%intplot(cas_tot3_score,alchdepend,alch.,COMPOSITE ABUSE SCORE AND ALCOHOL DEPEND INTERACTION);
%intplot(fu3i_55,alchdepend,alch.,QOL AND ALCOHOL DEPEND INTERACTION);
%intplot(fu3i_85,partner_drink,part_drink.,RELATIONSHIP SATISFACTION AND PARTNER DRINKING INTERACTION);
%intplot(severe_abuse_score3mo,danger_cat,,SEVERE ABUSE SCORE AND DANGER SCORE INTERACTION);

ods rtf close;
