/* Switch to SSISDB database */
Use SSISDB
Go

/* Build custom Schema */
print 'Custom Schema'
/* Check for existence of custom Schema */
If Not Exists(Select name 
              From sys.schemas
                          Where name = 'custom')
 begin
  /* Build and execute custom Schema SQL 
     if it does not exist */
  print ' - Creating custom schema'
  declare @CustomSchemaSql varchar(32) = 'Create Schema custom'
  exec(@CustomSchemaSql)
  print ' - Custom schema created'
 end
Else
  /* If the custom schema exists, tell us */
 print ' - Custom schema already exists.'
 print ''
Go

/* Build custom.Application table */
print 'Custom.Application Table'
/* Check for existence of custom.Application table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
                          Join sys.schemas s
                            On s.schema_id = t.schema_id
                          Where s.name = 'custom'
                            And t.name = 'Application')
 begin
  /* Create custom.Application table
     if it does not exist */
  print ' - Creating custom.Application Table'
  Create Table custom.Application
  (
    ApplicationID int identity(1,1)
         Constraint PK_custom_Application Primary Key Clustered
   ,ApplicationName nvarchar(256) Not Null
     Constraint U_custom_ApplicationName Unique
   ,ApplicationDescription nvarchar(512) Null
  )
  print ' - Custom.Application Table created'
 end
Else
  /* If the custom.Application table exists, tell us */
 print ' - Custom.Application Table already exists.'
print ''

/* Build custom.Package table */
print 'Custom.Package Table'
/* Check for existence of custom.Package table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
                          Join sys.schemas s
                            On s.schema_id = t.schema_id
                          Where s.name = 'custom'
                            And t.name = 'Package')
 begin
  /* Create custom.Package table
     if it does not exist */
  print ' - Creating custom.Package Table'
  Create Table custom.Package
  (
    PackageID int identity(1,1)
	 Constraint PK_custom_Package Primary Key Clustered
   ,FolderName nvarchar(128) Not Null
   ,ProjectName nvarchar(128) Not Null
   ,PackageName nvarchar(256) Not Null
   ,PackageDescription nvarchar(512) Null
  )
  print ' - Custom.Package Table created'
 end
Else
  /* If the custom.Package table exists, tell us */
 print ' - Custom.Package Table already exists.'
print ''

/* Build custom.ApplicationPackage table */
print 'Custom.ApplicationPackage Table'
/* Check for existence of custom.ApplicationPackage table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
                          Join sys.schemas s
                            On s.schema_id = t.schema_id
                          Where s.name = 'custom'
                            And t.name = 'ApplicationPackage')
 begin
  /* Create custom.ApplicationPackage table
     if it does not exist */
  print ' - Creating custom.ApplicationPackage Table'
  Create Table custom.ApplicationPackage
  (
    ApplicationPackageID int identity(1,1)
         Constraint PK_custom_ApplicationPackage Primary Key Clustered
   ,ApplicationID int Not Null
     Constraint FK_custom_ApplicationPackage_Application 
          Foreign Key References custom.Application(ApplicationID)
   ,PakcageID int Not Null
     Constraint FK_custom_ApplicationPackage_Package 
          Foreign Key References custom.Package(PackageID)
   ,ExecutionOrder int Not Null
     Constraint DF_custom_ApplicationPackage_ExecutionOrder
          Default(10)
   ,ApplicationPackageEnabled bit Not Null
     Constraint DF_custom_ApplicationPackage_ApplicationPackageEnabled
          Default(1)
  )
  print ' - Custom.ApplicationPackage Table created'
 end
Else
  /* If the custom.ApplicationPackage table exists, tell us */
 print ' - Custom.ApplicationPackage Table already exists.'
print ''

/* Build custom.GetApplicationPackages stored procedure */
print 'Custom.GetApplicationPackages'
/* Check for existence of custom.GetApplicationPackages stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
                  Join sys.schemas s
                    On s.schema_id = p.schema_id
                  Where s.name = 'custom'
                    And p.name = 'GetApplicationPackages')
 begin
  /* If custom.GetApplicationPackages stored procedure
     exists, drop it */
  print ' - Dropping custom.GetApplicationPackages Stored Procedure'
  Drop Procedure custom.GetApplicationPackages
  print ' - custom.GetApplicationPackages Stored Procedure dropped'
 end
print ' - Creating custom.GetApplicationPackages Stored Procedure'
go

/*

        Procedure: custom.GetApplicationPackages
           Author: Andy Leonard
 Parameter(s): ApplicationName [nvarchar(256)]
               - contains the name of the SSIS Application
                             for which to retrieve SSIS Packages.
  Description: Executes against the custom.ApplicationPackages
                table joined to the custom.Application
                                and custom.Packages tables. Returns a 
                                list of enabled Packages related to the 
                                Application ordered by ExecutionOrder.
          Example: exec custom.GetApplicationPackages 'TestSSISApp'

*/
Create Procedure custom.GetApplicationPackages
 @ApplicationName nvarchar(256)
As
 begin

  Set NoCount On

        Select p.FolderName, p.ProjectName, p.PackageName, ap.ExecutionOrder
        From custom.ApplicationPackage ap
        Join custom.Package p
          On p.PackageID = ap.PackageID
        Join custom.Application a
          On a.ApplicationID = ap.ApplicationID
        Where a.ApplicationName = @ApplicationName
          And ap.ApplicationPackageEnabled = 1
        Order By ap.ExecutionOrder
 end
go
print ' - Custom.GetApplicationPackages Stored Procedure created.'
print ''

/* Build custom.AddApplication stored procedure */
print 'Custom.AddApplication'
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
                  Join sys.schemas s
                    On s.schema_id = p.schema_id
                  Where s.name = 'custom'
                    And p.name = 'AddApplication')
 begin
  /* If custom.AddApplication stored procedure
     exists, drop it */
  print ' - Dropping custom.AddApplication Stored Procedure'
  Drop Procedure custom.AddApplication
  print ' - custom.AddApplication Stored Procedure dropped'
 end
print ' - Creating custom.AddApplication Stored Procedure'
go

/*

        Procedure: custom.AddApplication
        Author: Andy Leonard
         Parameter(s): ApplicationName [nvarchar(256)]
               - contains the name of the SSIS Application
                             to add to the Framework database.
                           ApplicationDescription [nvarchar(512)]
                           - contains a description of the SSIS Application.
         Description: Stores an SSIS Application.
          Example: exec custom.AddApplication 'TestSSISApp', 'A test SSIS Application.'

*/
Create Procedure custom.AddApplication
  @ApplicationName nvarchar(256)
 ,@ApplicationDescription nvarchar(512) = NULL
As
 begin

  Set NoCount On

        Insert Into custom.Application
        (ApplicationName
        ,ApplicationDescription)
        Output inserted.ApplicationID
        Values
        (@ApplicationName
        ,@ApplicationDescription)

 end
go
print ' - Custom.AddApplication Stored Procedure created.'
print ''

/* Build custom.AddPackage stored procedure */
print 'Custom.AddPackage'
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
                  Join sys.schemas s
                    On s.schema_id = p.schema_id
                  Where s.name = 'custom'
                    And p.name = 'AddPackage')
 begin
  /* If custom.AddPackage stored procedure
     exists, drop it */
  print ' - Dropping custom.AddPackage Stored Procedure'
  Drop Procedure custom.AddPackage
  print ' - custom.AddPackage Stored Procedure dropped'
 end
print ' - Creating custom.AddPackage Stored Procedure'
go

/*

        Procedure: custom.AddPackage
        Author: Andy Leonard
        Parameter(s): FolderName [nvarchar(128)]
               - contains the name of the SSISDB Catalog
                             folder containing the SSIS Package.
                           ProjectName [nvarchar(128)]
               - contains the name of the SSISDB Catalog
                             project containing the SSIS Package.
                           PackageName [nvarchar(128)]
               - contains the name of the SSISDB Catalog
                             SSIS Package.
                           PackageDescription [nvarchar(512)]
                           - contains a description of the SSIS Package.
        Description: Stores an SSIS Package.
          Example: exec custom.AddPackage 'Chapter2', 'Chapter 2'
                                        , 'Chapter2.dtsx', 'A test SSIS Package.'

*/
Create Procedure custom.AddPackage
  @FolderName nvarchar(128)
 ,@ProjectName nvarchar(128)
 ,@PackageName nvarchar(256)
 ,@PackageDescription nvarchar(512) = NULL
As
 begin

  Set NoCount On

        Insert Into custom.Package
        (FolderName
        ,ProjectName
        ,PackageName
        ,PackageDescription)
        Output inserted.PackageID
        Values
        (@FolderName
        ,@ProjectName
        ,@PackageName
        ,@PackageDescription)

 end
go
print ' - Custom.AddPackage Stored Procedure created.'
print ''

/* Build custom.AddApplicationPackage stored procedure */
print 'Custom.AddApplicationPackage'
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
                  Join sys.schemas s
                    On s.schema_id = p.schema_id
                  Where s.name = 'custom'
                    And p.name = 'AddApplicationPackage')
 begin
  /* If custom.AddApplicationPackage stored procedure
     exists, drop it */
  print ' - Dropping custom.AddApplicationPackage Stored Procedure'
  Drop Procedure custom.AddApplicationPackage
  print ' - custom.AddApplicationPackage Stored Procedure dropped'
 end
print ' - Creating custom.AddApplicationPackage Stored Procedure'
go

/*

        Procedure: custom.AddApplicationPackage
        Author: Andy Leonard
        Parameter(s): ApplicationID [int]
               - contains the ID returned from the execution
                             of custom.AddApplication.
                           PackageID [int]
               - contains the ID returned from the execution
                             of custom.AddPackage.
                           ExecutionOrder [int]
               - contains the order the package will execute
                             within the SSIS Application.
                           ApplicationPackageEnabled [bit]
                           - 1 == Enabled and will run as part of the SSIS Application.
                             0 == Disabled and will not run as part of the SSIS Application.
        Description: Links an SSIS Package to an SSIS Application
          Example: exec custom.AddApplicationPackage 1, 1, 10, 1

*/
Create Procedure custom.AddApplicationPackage
  @ApplicationID int
 ,@PackageID int
 ,@ExecutionOrder int = 10
 ,@ApplicationPackageEnabled bit = 1
As
 begin

  Set NoCount On

        Insert Into custom.ApplicationPackage
        (ApplicationID
        ,PackageID
        ,ExecutionOrder
        ,ApplicationPackageEnabled)
        Values
        (@ApplicationID
        ,@PackageID
        ,@ExecutionOrder
        ,@ApplicationPackageEnabled)

 end
go
print ' - Custom.AddApplicationPackage Stored Procedure created.'
print ''
