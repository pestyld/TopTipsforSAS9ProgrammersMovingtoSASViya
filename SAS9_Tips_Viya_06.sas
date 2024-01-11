/********************************************************************/
/* 9 for SAS9 – Top Tips for SAS 9 Programmers Moving to SAS Viya   */
/********************************************************************/

/********************************************************************/
/* 6 - Execute SQL in the distributed CAS server                    */
/********************************************************************/
/* NOTE: Continue processing the final_home_equity CAS table from   */
/*       the previous program. Once the data is loaded in-memory    */
/*       it stays in-memory until dropped or the CAS session ends.  */
/********************************************************************/

/* To run SQL in the distributed CAS server you must use FedSQL with the sessref = option and the CAS session name */

/* Simple LIMIT */
proc fedsql sessref=conn;
	select *
	from casuser.final_home_equity
	limit 10;
quit;


/* GROUP BY */
proc fedsql sessref=conn;
	select BAD, 
           count(*) as TotalLoans, 
           mean(MORTDUE) as avgMORTDUE, 
           mean(YOJ) as avgYOJ
	from casuser.final_home_equity
	group by BAD;
quit;



/*****************************************************************/
/* Continue to the next program without disconnecting from CAS   */
/*****************************************************************/