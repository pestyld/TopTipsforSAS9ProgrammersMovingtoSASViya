/********************************************************************/
/* 9 for SAS9 – Top Tips for SAS 9 Programmers Moving to SAS Viya   */
/********************************************************************/

/**********************************************************/
/* 4 - Run DATA step in on the distributed CAS server     */
/**********************************************************/
/* NOTE: The data is small for training purposes          */
/**********************************************************/


/***************************************************************/
/* a. Connect the Compute Server to the distributed CAS Server */
/***************************************************************/
cas conn;


/*************************************************/
/* b. Explicity load a file into memory into CAS */
/*************************************************/

/* Load the demo home_equity.csv client-side file from the SAS Viya example data sets website into the CAS server */
filename out_file url "https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv";
proc casutil;
	load file=out_file
		 casout='home_equity' outcaslib = 'casuser';
quit;

/* Confirm the table was loaded into CAS */
proc casutil;
	/* View available in-memory distributed tables */
	list tables incaslib = 'casuser';
quit;



/********************************************************************/
/* c. Create a library reference to a caslib using the CAS engine   */
/********************************************************************/
libname casuser cas caslib = 'casuser';



/****************************/
/* d. Preview the CAS table */
/****************************/
proc print data=casuser.home_equity(obs=10);
run;



/*************************************************************************/
/* e. Run DATA step on the in-memory table in the distributed CAS server */ 
/*    and create a new in-memory CAS table                               */
/*************************************************************************/

/* Prepare the data using the distributed CAS server */
data casuser.final_home_equity;
	set casuser.home_equity end=end_of_thread;

	/* Fix missing values with means */
	if YOJ = . then YOJ = 9;
	if MORTDUE = . then MORTDUE = 73761;
	if VALUE = . then VALUE = 101776;
	if DEBTINC = . then DEBTINC = 34;

	/* Round column */
	DEBTINC = round(DEBTINC);

	/* Format columns */
	format APPDATE date9.;

	/* Drop columns */
	drop DEROG DELINQ CLAGE NINQ CLNO CITY;

	/* View number of rows processed on each thread (demo data, not all threads will be used) */
	if end_of_thread=1 then	
		put  'Total Available Threads for Processing: ' _NTHREADS_
             'Processing Thread ID: '    _THREADID_ 
             ', Total Rows Processed Thread: '  _N_ ;
run;



/*************************************/
/* Continue to the next program      */
/*************************************/