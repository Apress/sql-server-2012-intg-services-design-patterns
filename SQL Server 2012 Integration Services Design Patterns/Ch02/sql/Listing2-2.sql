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

 /* Drop the Custom.execute_catalog_package Stored Procedure if it already exists */
print 'Custom.execute_catalog_package Stored Procedure'
  If Exists(Select s.name + '.' +  p.name
            From sys.procedures p
            Join sys.schemas s
                On s.schema_id = p.schema_id
         Where s.name = 'custom'
           And p.name = 'execute_catalog_package')
   begin
    print ' - Dropping custom.execute_catalog_package'
    Drop Procedure custom.execute_catalog_package
    print ' - Custom.execute_catalog_package dropped'
   end

   /* Create the Custom.execute_catalog_package Stored Procedure */
  print ' - Creating custom.execute_catalog_package'
go

/*

     Stored Procedure: custom.execute_catalog_package
     Author: Andy Leonard
     Date: 4 Mar 2012
     Description: Creates a wrapper around the SSISDB Catalog procedures
                  used to start executing an SSIS Package. Packages in the
                SSIS Catalog are referenced by a multi-part identifier
                 - or path - that consists of the following hierarchy:
        Catalog Name: Implied by the database name in Integration Server 2012
        |-Folder Name: A folder created before or at Deployment to contain the SSIS project
        |-Project Name: The name of the SSIS Project deployed
        |-Package Name: The name(s) of the SSIS Package(s) deployed

        Parameters:
        @FolderName [nvarchar(128)] {No default} – 
         contains the name of the Folder that holds the SSIS Project
        @ProjectName [nvarchar(128)] {No default} – 
         contains the name of the SSIS Project that holds the SSIS Package
        @PackageName [nvarchar(260)] {No default} – 
         contains the name of the SSIS Package to be executed
        @ExecutionID [bigint] {Output} – 
         Output parameter (variable) passed back to the caller
        @LoggingLevel [varchar(16)] {Default} – 
         contains the (case-insensitive) name of the logging level
         to apply to this execution instance
        @Use32BitRunTime [bit] {Default} – 
         1 == Use 64-bit run-time
                                                      0 == Use 32-bit run-time
        @ReferenceID [bigint] {Default} –          contains a reference to an Execution Environment
        @ObjectType [smallint] –          contains an identifier that appears to be related to the          SSIS PackageType property 
        Guessing: @ObjectType == PackageType.ordinal (1-based-array) * 10
         Must be 20, 30, or 50 for catalog.set_execution_parameter_value
         stored procedure

        Test: 
        1. Create and deploy an SSIS Package to the SSIS Catalog.
        2. Exec custom.execute_catalog_package and pass it the 
          following parameters: @FolderName, @ProjectName, @PackageName, @ExecutionID Output 
        @LoggingLevel, @Use32BitRunTime, @ReferenceID, and @ObjectType are optional and 
        defaulted parameters.

         Example:
           Declare @ExecId bigint
           Exec custom.execute_catalog_package
         'Chapter2'
        ,'Chapter 2'
        ,'Chapter2.dtsx'
        ,@ExecId Output
        3. When execution completes, an Execution_Id value should be returned.
        View the SSIS Catalog Reports to determine the status of the execution 
        instance and the test.

*/
Create Procedure custom.execute_catalog_package
  @FolderName nvarchar(128)
 ,@ProjectName nvarchar(128)
 ,@PackageName nvarchar(260)
 ,@ExecutionID bigint Output
 ,@LoggingLevel varchar(16) = 'Basic'
 ,@Use32BitRunTime bit = 0
 ,@ReferenceID bigint = NULL
 ,@ObjectType smallint = 50
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

GO
