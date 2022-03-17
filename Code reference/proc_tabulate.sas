
/*PROC TABULATE gives you the same output as a proc means, but you have more control over how your output tables look*/
proc tabulate data = dataset format=8.2;
      class ______;	*Classes for evaluation;
      var variable1 variable2 variable3; *Variables to be used for the analysis;
      table (variable1 variable2 variable3)*class_variable*(n mean std);  *The final parentheses can include whatever statistical values you would like;
      title ______;   *Whatever your title is;
run;

/*
whatever variables you want in the tables HAVE to be listed in the var statement (it does some wierd things if not.  
Same with the class variable/ class statement.  It automatically makes each variable a different table.  You can have\
multiple class statements.

Most importantly, the table statements have to be made in the order you want them to appear from top to bottom.  So the
output for the above code would look like:

                   Variable1
                   Class Name
   C1                 C2             C3   
n mean std        n mean std     n mean std

	            Variable2
                Class Name
   C1                 C2             C3   
n mean std        n mean std     n mean std

	            Variable3
                Class Name
   C1                 C2             C3   
n mean std        n mean std     n mean std

Also, in order to get lines between the outputs, when we did the ods rtf we DID NOT use a style command at the end of the
file path.  If you use STYLE=JOURNAL there won't be lines and the table will be hard to read.

This is a good reference for the command:  http://www.ats.ucla.edu/stat/sas/faq/tabulate.htm

If you want to make labeled rows by another class variable, you put that variable in the class statement as well and then
change the table by:
table rowvar, (variable variable variable)*class*(n mean std);
*/
