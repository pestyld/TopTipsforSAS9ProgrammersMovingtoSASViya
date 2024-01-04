/********************************************************************/
/* 9 for SAS9 – Top Tips for SAS 9 Programmers Moving to SAS Viya   */
/********************************************************************/

/********************************************************************/
/* 5 - New distributed PROCS for the CAS server                     */
/********************************************************************/
/* NOTE: Continue processing the home_equity_final CAS table from   */
/*       the previous program. Once the data is loaded in-memory    */
/*       it stays in-memory until dropped or the CAS session ends.  */
/********************************************************************/


/************************************/
/* a. Descriptive statistics in CAS */
/************************************/
proc mdsummary data=casuser.final_home_equity;
	output out=casuser.home_equity_summary;
run;
proc print data=casuser.home_equity_summary;
run;



/************************************************/
/* b. Frequencies in the distributed CAS server */
/************************************************/
proc freqtab data=casuser.final_home_equity;
	tables BAD REASON JOB STATE DIVISION REGION / plots=freqplot;
quit;



/************************************************/
/* c. Correlation in the distributed CAS server */
/************************************************/
proc correlation data=casuser.final_home_equity;
run;


/*********************************************************************************************************/
/* d. View the cardinality of the columns using CAS                                                      */
/*********************************************************************************************************/
/*  The CARDINALITY procedure determines a variable’s cardinality or limited cardinality in SAS Viya.    */
/*  The cardinality of a variable is the number of its distinct values, and the limited cardinality of a */
/*  variable is the number of its distinct values that do not exceed a specified threshold.              */
/*********************************************************************************************************/
proc cardinality data=casuser.final_home_equity
				 outcard=casuser.home_equity_cardinality maxlevels=250;
run;
proc print data=casuser.home_equity_cardinality;
run;



/********************************************************/
/* e. Logistic regression in the distributed CAS server */
/********************************************************/

/* Create a model to predict bad loans on SAS9 */
/* proc logistic data=work.final_home_equity; */
/* 	class REASON JOB / param=REFERENCE; */
/* 	model BAD(event='1') = LOAN MORTDUE VALUE REASON JOB YOJ DEBTINC; */
/* 	store mymodel; */
/* run; */

/* Run a linear regression using the distributed CAS server */
proc logselect data=casuser.final_home_equity;
	class REASON JOB / param=REFERENCE;
	model BAD(event='1') = LOAN MORTDUE VALUE REASON JOB YOJ DEBTINC / link=logit dist=binary; 
	selection method=NONE;
	store out=casuser.mymodel;
run;

/* Score the data using your model */
proc astore;
	score data=casuser.final_home_equity 
          rstore=casuser.mymodel
		  copyvars=BAD
          out=casuser.home_equity_scored;
quit;

proc print data=casuser.home_equity_scored(obs=100);
run;