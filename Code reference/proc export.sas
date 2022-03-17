***************************************************************************************************************************************************************
Code for exporting a SAS dataset into another filetype

*************************************************************************************************************************************************************;




PROC EXPORT DATA= derived.all_pat_1999 /* dataset that you want exported, notice NO ; */
            OUTFILE= "R:\RESEARCHERS\VANAK_JILL\Dissertation\data\STATA\nodup_doh_1999.dta" /*path where you want the exported file saved/dumped NOTICE .newfiletype */
            DBMS=STATA REPLACE; /*DBMS is the program/filetype of the new dataset*/
RUN;
