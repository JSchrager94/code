options nodate pageno=1 linesize=80 pagesize=40;
data score;
   input Student $9. +1 StudentID $ Section $ Test1 Test2 Final;
   datalines;
Capalleti 0545 1  1 1 3
Dubose    1252 2  1 5 1
Engles    1167 1  5 1 2
Grant     1230 2  3 5 4
Krupski   2527 2  5 3 1
Lundsford 4860 1  2 4 4
McBane    0674 1  5 5 3
;
run;

/*we want to get the frequencies for the total number of scores for test1, test2 and final*/

proc sort data=score;
	by StudentID;
run; 

proc transpose data=score out=score_transposed name = Test prefix = score;
by Studentid; /*these are the variables that you want to retain*/
var test1 test2 final; /*these are the variables that you want to transpose*/
run;
proc print data=score_transposed noobs;
    title 'Student Test Scores in Variables';
run;

proc freq data=score_transposed;
	tables score1/ list missing;
run;
