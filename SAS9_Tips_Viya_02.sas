/********************************************************************/
/* 9 for SAS9 – Top Tips for SAS 9 Programmers Moving to SAS Viya   */
/********************************************************************/

/*****************************************/
/* 2 - Check hardcoded paths             */
/*****************************************/

/* Old local path or SAS9 remote server path */
%let old_path = C:\workshop;

proc import datafile="&old_path/home_equity.csv" 
			dbms=csv 
			out=work.new_table replace;
	guessingrows=1000;
run;



/* New path to data in SAS Viya */
/* You can use the path macro variable from the previous program */
%let path = &path; /* ----- modify path to your data on the Viya server. Example - /new_viya_path/user  */

proc import datafile="&path/home_equity.csv" 
			dbms=csv 
			out=work.new_table replace;
	guessingrows=1000;
run;