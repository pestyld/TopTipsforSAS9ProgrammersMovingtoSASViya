/********************************************************************/
/* 9 for SAS9 – Top Tips for SAS 9 Programmers Moving to SAS Viya   */
/********************************************************************/

/**********************************************************************************/
/* 7 - Use the native CAS language (CASL) for additional data types and actions   */
/**********************************************************************************/
/* NOTE: Continue processing the home_equity_final CAS table from                 */
/*       the previous program. Once the data is loaded in-memory                  */
/*       it stays in-memory until dropped or the CAS session ends.                */
/**********************************************************************************/

/* Use CASL data types */
proc cas;
	/* String */
	myString = 'Peter Styliadis';
	print myString;
	describe myString;

	/* Numeric */
	myInt = 35;
	print myInt;
	describe myInt;
	
	myDouble = 35.5;
	print myDouble;
	describe myDouble;

	/* List */
	myList = {'Peter', 'SAS', 37, 'Curriculum Development', {'Owen', 'Eva'}};
	print myList;
	describe myList;

	/* Dictionary */
	myDict = {Name='Peter', Age=37, Job='Curriculum Development', Children={'Owen', 'Eva'}};
	print myDict;
	describe myDict;
quit;


/* Use native CAS actions on the CAS server for MPP */
proc cas;
	/* View available files in a caslib */
	table.fileInfo / caslib = 'samples';

	/* View available in-memory CAS tables in a caslib */
	table.tableInfo / caslib = 'casuser';

	/* Reference the CAS table using a dictionary */
	tbl = {name="FINAL_HOME_EQUITY", caslib="casuser"};

	/* Preview 10 rows of the CAS table */
    table.fetch / table = tbl, to=10; 

	/* View the number of missing values and distinct values */
	simple.distinct / table = tbl;

	/* View descriptive statistics */
	simple.summary / table = tbl;

	/* View frequency values */
	cols_for_freq = {'BAD','REASON','JOB'};
	simple.freq / table = tbl, input = cols_for_freq;
quit;


/***********************************/
/* Disconnect from the CAS server  */
/***********************************/
cas conn terminate;