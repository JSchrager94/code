

proc sort data=cdi; by measure_name provider_name period; quit;


proc rank data=cdi out=results ties=low;  
      by measure_name;
   var period;
   ranks periodRank;
run; 
