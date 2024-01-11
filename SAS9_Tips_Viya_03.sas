/********************************************************************/
/* 9 for SAS9 – Top Tips for SAS 9 Programmers Moving to SAS Viya   */
/********************************************************************/

/******************************************************************/
/* 3 - Loading data into memory in CAS for distributed processing */
/******************************************************************/

/***************************************************************/
/* a. Connect the Compute Server to the distributed CAS Server */
/***************************************************************/
cas conn;



/**********************************************/
/* b. View data sources connected to SAS Viya */
/**********************************************/

/* View available libraries (data sources) to the SAS Compute server */
libname _all_ list;

/* View available caslibs (data sources) connected to the CAS cluster */
caslib _all_ list;



/*********************************************************/
/* c. View available files in a caslib on the CAS server */
/*********************************************************/
/* The samples caslib is available by default. It's similar to the SASHELP library on the Compute server */

proc casutil;
	list files incaslib = 'samples';
quit;



/********************************************************************************************/
/* d. Load a table into the distributed CAS server and view metadata of the in-memory table */
/********************************************************************************************/
proc casutil;

	/* Explicitly load a server-side file into memory (files can be a database table, or other file formats like CSV,TXT, PARQUET and more) */
	load casdata='RAND_RETAILDEMO.sashdat' incaslib = 'samples'
		 casout='RAND_RETAILDEMO' outcaslib = 'casuser';

	/* View available in-memory tables in the Casuser caslib */
	list tables incaslib = 'casuser';

	/* View the contents of the in-memory table */
	contents casdata='RAND_RETAILDEMO' incaslib = 'casuser';
quit;



/*****************************************/
/* e. Drop a distributed in-memory table */
/*****************************************/
proc casutil;
	droptable casdata='RAND_RETAILDEMO' incaslib = 'casuser';
quit;


/*************************************/
/* f. Disconnect from the CAS server */
/*************************************/
cas conn terminate;