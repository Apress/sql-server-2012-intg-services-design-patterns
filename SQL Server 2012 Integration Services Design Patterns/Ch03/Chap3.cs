/*
	SSIS Design Patterns
	Chapter 3: Scripting Design Patterns
	
	Note: All code samples included in this chapter are just snippets, and are not fully functional
	on their own.
*/

// Listing 3-1. Create the ADO.NET database connection
ConnectionManager connMgr = Dts.Connections["ADONET_PROD"];
System.Data.SqlClient.SqlConnection theConnection
	= (System.Data.SqlClient.SqlConnection)connMgr.AcquireConnection(Dts.Transaction);



	
// Listing 3-2. Create the OLEDB database connection
ConnectionManager cm = Dts.Connections["OLEDB_PROD"];
Microsoft.SqlServer.Dts.Runtime.Wrapper.IDTSConnectionManagerDatabaseParameters100 cmparams
   = cm.InnerObject AS Microsoft.SqlServer.Dts.Runtime.Wrapper.IDTSConnectionManagerDatabaseParameters100;
System.Data.OleDb.OleDbConnection conn = (System.Data.OleDb.OleDbConnection)cmParams.GetConnectionForSchema();



// Listing 3-3. Create the OLEDB database connection
SqlConnection conn = Connections.ADONET_PROD.AcquireConnection(null);



// Listing 3-4. Script Task Variable Syntax
public void main()
{
	// Get the current RunID
	int runID = int.Parse(Dts.Variables["RunID"].Value.ToString());
	
	// Set the ClientID
	Dts.Variables["ClientID"].Value = ETL.GetClientID(runID);

	Dts.TaskResult = (int)ScriptResults.Success;
}


// Listing 3-5. Script Component Variable Syntax
public override void Input0_ProcessInputRow(Input0Buffer Row)
{
	// Push the SSIS variable ClientName to the value in the current row
	Row.ClientName = Variables.ClientName;
}



// Listing 3-6. Manually lock a variable
// Programmatically lock the variable we need
Variable vars = null;
Dts.VariableDispenser.LockOneForRead("RunID", ref vars);

// Assign to script variable
runID = int.Parse(vars["RunID"].Value.ToString());

// Unlock the variable object
vars.Unlock();

