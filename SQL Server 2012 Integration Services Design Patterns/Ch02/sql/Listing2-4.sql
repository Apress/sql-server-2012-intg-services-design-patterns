/* Select the SSISDB database */
Use SSISDB
Go

 /* Create a parameter (variable) named @Sql */
Declare @Sql varchar(2000)

 /* Create the Custom schema if it does not already exist */
print 'Custom Schema'
If Not Exists(Select name 
              From sys.schemas
Where name = 'custom')
 begin
   /* Create Schema statements must occur first in a batch */
  print ' - Creating custom schema'
  Set @Sql = 'Create Schema custom'
  Exec(@Sql)
  print ' - Custom schema created'
 end
Else
 print ' - Custom Schema already exists.'
print ''

 /* Drop the Custom.execute_catalog_package_with_data_tap
 Stored Procedure if it already exists */
print 'Custom.execute_catalog_package_with_data_tap Stored Procedure'
  If Exists(Select s.name + '.' +  p.name
            From sys.procedures p
            Join sys.schemas s
                On s.schema_id = p.schema_id
        Where s.name = 'custom'
           And p.name = 'execute_catalog_package_with_data_tap')
   begin
    print ' - Dropping custom.execute_catalog_package_with_data_tap'
    Drop Procedure custom.execute_catalog_package_with_data_tap
    print ' - Custom.execute_catalog_package_with_data_tap dropped'
   end

   /* Create the Custom.execute_catalog_package_with_data_tap Stored Procedure */
  print ' - Creating custom.execute_catalog_package_with_data_tap'
go

/*


 Stored Procedure: custom.execute_catalog_package_with_data_tap
 Author: Andy Leonard
 Date: 4 Apr 2012
 Description: Creates a wrapper around the SSISDB Catalog procedures
              used to start executing an SSIS Package and create a 
              data tap. Packages in the
              SSIS Catalog are referenced by a multi-part identifier
              - or path - that consists of the following hierarchy:
  Catalog Name: Implied by the database name in Integration Server 2012
  |-Folder Name: A folder created before or at Deployment to contain the SSIS project
    |-Project Name: The name of the SSIS Project deployed
      |-Package Name: The name(s) of the SSIS Package(s) deployed
 Parameters:
   @FolderName [nvarchar(128)] {No default} - contains the name of the
     Folder that holds the SSIS Project
   @ProjectName [nvarchar(128)] {No default} - contains the name of the
    SSIS Project that holds the SSIS Package
   @PackageName [nvarchar(260)] {No default} - contains the name of the
    SSIS Package to be executed
   @ExecutionID [bigint] {Output} - Output parameter (variable) passed back
    to the caller
   @LoggingLevel [varchar(16)] {Default} - contains the (case-insensitive)
    name of the logging level to apply to this execution instance
   @Use32BitRunTime [bit] {Default} - 1 == Use 64-bit run-time
		                      0 == Use 32-bit run-time
   @ReferenceID [bigint] {Default} - contains a reference to an Execution Environment
   @ObjectType [smallint] - contains an identifier that appears to be related
    to the SSIS PackageType property 
   
   Guessing: @ObjectType == PackageType.ordinal (1-based-array) * 10
    Must be 20, 30, or 50 for catalog.set_execution_parameter_value
     stored procedure
 @DataFlowTaskName [nvarchar(255)] - contains the name of the Data Flow Task in which to 
   to apply the data tap.
 @IdentificationString [nvarchar(255)] - contains the Data Flow Path Identification string
   in which to apply the data tap.
 @DataTapFileName [nvarchar(4000)] - contains the name of the file to create to contain
   the rows captured from the data tap.
   Saved in the <drive>:\Program Files\Microsoft SQL Server\110\DTS\DataDumps folder.
 @DataTapMaxRows [int] - contains the maximum number of rows to send to the data tap file.

 Test: 
  1. Create and deploy an SSIS Package to the SSIS Catalog.
  2. Exec custom.execute_catalog_package_with_data_tap and pass it the 
     following parameters: @FolderName, @ProjectName, @PackageName,
     @DataFlowTaskName, @IdentificationString, @DataTapFileName,
     @ExecutionID Output
  @LoggingLevel, @Use32BitRunTime, @ReferenceID, @ObjectType,
   and @DataTapMaxRows are optional and defaulted parameters.

 Example:
  Declare @ExecId bigint
  Exec custom.execute_catalog_package_with_data_tap
   'SSISConfig2012','SSISConfig2012','Child1.dtsx',
   'Data Flow Task', 'OLESRC Temperature.OLE DB Source Output',
   'Child1_DataFlowTask_OLESRCTemperature_OLEDBSourceOutput.csv',@ExecId Output
 
  3. When execution completes, an Execution_Id value should be returned.
     View the SSIS Catalog Reports to determine the status of the
     execution instance and the test.

*/
Create Procedure [custom].[execute_catalog_package_with_data_tap]
  @FolderName nvarchar(128)
 ,@ProjectName nvarchar(128)
 ,@PackageName nvarchar(260)
 ,@DataFlowTaskName nvarchar(255)
 ,@IdentificationString nvarchar(255)
 ,@DataTapFileName nvarchar(4000)
 ,@ExecutionID bigint Output
 ,@LoggingLevel varchar(16) = 'Basic'
 ,@Use32BitRunTime bit = 0
 ,@ReferenceID bigint = NULL
 ,@ObjectType smallint = 50
 ,@DataTapMaxRows int = NULL
As

 begin
  
  Set NoCount ON
  
   /* Call the catalog.create_execution stored procedure
      to initialize execution location and parameters */
  Exec catalog.create_execution
   @package_name = @PackageName
  ,@execution_id = @ExecutionID Output
  ,@folder_name = @FolderName
  ,@project_name = @ProjectName
  ,@use32bitruntime = @Use32BitRunTime
  ,@reference_id = @ReferenceID

   /* Populate the @ExecutionID parameter for OUTPUT */
  Select @ExecutionID As Execution_Id

  /* Configure Data Tap parameters */
  If (Left(@DataFlowTaskName, 9) <> '\Package\')
   Set @DataFlowTaskName = '\Package\' + @DataFlowTaskName

  If Left(@IdentificationString,6) <> 'Paths['
   Set @IdentificationString = 'Paths[' + @IdentificationString + ']'

  /* Create the Data Tap */
  EXEC [SSISDB].[catalog].add_data_tap  @ExecutionID, @DataFlowTaskName,   
   @IdentificationString, @DataTapFileName, @DataTapMaxRows

   /* Create a parameter (variable) named @Sql */
  Declare @logging_level smallint
   /* Decode the Logging Level */
  Select @logging_level = Case 
                           When Upper(@LoggingLevel) = 'BASIC'
                                           Then 1
                                           When Upper(@LoggingLevel) = 'PERFORMANCE'
                                           Then 2
                                            When Upper(@LoggingLevel) = 'VERBOSE'
                                           Then 3
                                           Else 0 /* 'None' */
                                          End 
   /* Call the catalog.set_execution_parameter_value stored
      procedure to update the LOGGING_LEVEL parameter */
  Exec catalog.set_execution_parameter_value
    @ExecutionID
   ,@object_type = @ObjectType
   ,@parameter_name = N'LOGGING_LEVEL'
   ,@parameter_value = @logging_level

   /* Call the catalog.start_execution (self-explanatory) */
  Exec catalog.start_execution
    @ExecutionID

 end
