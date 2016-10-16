Use master
go

/* SSISConfig database */
If Not Exists(Select name
              From sys.databases
              Where name = 'SSISConfig')
 begin
  print 'Creating SSISConfig database'
  Create Database SSISConfig
  print 'SSISConfig database created'
 end
Else
 print 'SSISConfig database already exists.'
print ''
go

Use SSISConfig
go

/* cfg schema */
If Not Exists(Select name
              From sys.schemas
              Where name = 'cfg')
 begin
  print 'Creating cfg schema'
  declare @sql varchar(100) = 'Create Schema cfg'
  exec(@sql)
  print 'Cfg schema created'
 end
Else
 print 'Cfg schema already exists.'
print ''

/* cfg.Packages table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
              Join sys.schemas s
                On s.schema_id = t.schema_id
              Where s.name = 'cfg'
                And t.name = 'Packages')
 begin
  print 'Creating cfg.Packages table'
  Create Table cfg.Packages
  (
    PackageID int identity(1,1)
     Constraint PK_Packages
      Primary Key Clustered
   ,PackageFolder varchar(255) Not Null
   ,PackageName varchar(255) Not Null
  )
  print 'Cfg.Packages created'
 end
Else
 print 'Cfg.Packages table already exists.'
print ''

/* cfg.AddSSISPackage stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'cfg'
            And p.name = 'AddSSISPackage')
 begin
  print 'Dropping cfg.AddSSISPackage stored procedure'
  Drop Procedure cfg.AddSSISPackage 
  print 'Cfg.AddSSISPackage stored procedure dropped'
 end
print 'Creating cfg.AddSSISPackage stored procedure'
print ''
go

Create Procedure cfg.AddSSISPackage
  @PackageName varchar(255)
 ,@PackageFolder varchar(255)
 ,@PkgID int output
As

  Set NoCount On

  declare @tbl table (PkgID int)

  If Not Exists(Select PackageFolder + PackageName
                From cfg.Packages
                Where PackageFolder = @PackageFolder
                  And PackageName = @PackageName)
   begin
    Insert Into cfg.Packages
    (PackageName
    ,PackageFolder)
    Output inserted.PackageID Into @tbl
    Values (@PackageName, @PackageFolder)
   end
  Else
   insert into @tbl
   (PkgID)
   (Select PackageID
    From cfg.Packages
    Where PackageFolder = @PackageFolder
      And PackageName = @PackageName)
   
   Select @PkgID = PkgID From @tbl
go
print 'Cfg.AddSSISPackage stored procedure created.'
print ''

/* Variable Declaration */
declare @PackageFolder varchar(255) = 'F:\SSIS 2012 Design Patterns\SSISConfig2012\SSISConfig2012\'
declare @PackageName varchar(255) = 'Child1.dtsx'
declare @PackageID int

/* Add the Child1.dtsx SSIS Package*/
If Not Exists(Select PackageFolder + PackageName
              From cfg.Packages
              Where PackageFolder = @PackageFolder
                And PackageName = @PackageName)
 begin
  print 'Adding ' + @PackageFolder + @PackageName
  exec cfg.AddSSISPackage @PackageName, @PackageFolder, @PackageID output
 end
Else
 begin
  Select @PackageID = PackageID
  From cfg.Packages
  Where PackageFolder = @PackageFolder
    And PackageName = @PackageName
  print @PackageFolder + @PackageName + ' already exists in the Framework.'
 end

set @PackageName = 'Child2.dtsx'
/* Add the Child2.dtsx SSIS Package*/
If Not Exists(Select PackageFolder + PackageName
              From cfg.Packages
              Where PackageFolder = @PackageFolder
                And PackageName = @PackageName)
 begin
  print 'Adding ' + @PackageFolder + @PackageName
  exec cfg.AddSSISPackage @PackageName, @PackageFolder, @PackageID output
 end
Else
 begin
  Select @PackageID = PackageID
  From cfg.Packages
  Where PackageFolder = @PackageFolder
    And PackageName = @PackageName
  print @PackageFolder + @PackageName + ' already exists in the Framework.'
 End

/* cfg.Applications table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
              Join sys.schemas s
                On s.schema_id = t.schema_id
              Where s.name = 'cfg'
                And t.name = 'Applications')
 begin
  print 'Creating cfg.Applications table'
  Create Table cfg.Applications
  (
    ApplicationID int identity(1,1)
     Constraint PK_Applications
      Primary Key Clustered
   ,ApplicationName varchar(255) Not Null
    Constraint U_Applications_ApplicationName
     Unique
  )
  print 'Cfg.Applications created'
 end
Else
 print 'Cfg.Applications table already exists.'
print ''

/* cfg.AddSSISApplication stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'cfg'
            And p.name = 'AddSSISApplication')
 begin
  print 'Dropping cfg.AddSSISApplication stored procedure'
  Drop Procedure cfg.AddSSISApplication 
  print 'Cfg.AddSSISApplication stored procedure dropped'
 end
print 'Creating cfg.AddSSISApplication stored procedure'
print ''
go

Create Procedure cfg.AddSSISApplication
  @ApplicationName varchar(255)
 ,@AppID int output
As

  Set NoCount On

  declare @tbl table (AppID int)
  
  If Not Exists(Select ApplicationName
                From cfg.Applications
                Where ApplicationName = @ApplicationName)
   begin
    Insert Into cfg.Applications
    (ApplicationName)
    Output inserted.ApplicationID into @tbl
    Values (@ApplicationName)
   end
  Else
   insert into @tbl
   (AppID)
   (Select ApplicationID
    From cfg.Applications
    Where ApplicationName = @ApplicationName)

  Select @AppID = AppID from @tbl
go
print 'Cfg.AddSSISApplication stored procedure created.'
print ''


/* cfg.AppPackages table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
              Join sys.schemas s
                On s.schema_id = t.schema_id
              Where s.name = 'cfg'
                And t.name = 'AppPackages')
 begin
  print 'Creating cfg.AppPackages table'
  Create Table cfg.AppPackages
  (
    AppPackageID int identity(1,1)
     Constraint PK_AppPackages
      Primary Key Clustered
   ,ApplicationID int Not Null
	 Constraint FK_cfgAppPackages_cfgApplications_ApplicationID
	  Foreign Key References cfg.Applications(ApplicationID)
   ,PackageID int Not Null
	 Constraint FK_cfgAppPackages_cfgPackages_PackageID
	  Foreign Key References cfg.Packages(PackageID)
   ,ExecutionOrder int Null
  )
  print 'Cfg.AppPackages created'
 end
Else
 print 'Cfg.AppPackages table already exists.'
print ''

/* cfg.AddSSISApplicationPackage stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'cfg'
            And p.name = 'AddSSISApplicationPackage')
 begin
  print 'Dropping cfg.AddSSISApplicationPackage stored procedure'
  Drop Procedure cfg.AddSSISApplicationPackage 
  print 'Cfg.AddSSISApplicationPackage stored procedure dropped'
 end
print 'Creating cfg.AddSSISApplicationPackage stored procedure'
go


Create Procedure cfg.AddSSISApplicationPackage
  @ApplicationID int
 ,@PackageID int
 ,@ExecutionOrder int = 10
As

  Set NoCount On

  If Not Exists(Select AppPackageID
                From cfg.AppPackages
                Where ApplicationID = @ApplicationID
                  And PackageID = @PackageID)
   begin
    Insert Into cfg.AppPackages
    (ApplicationID
    ,PackageID
    ,ExecutionOrder)
    Values (@ApplicationID, @PackageID, @ExecutionOrder)
   end
go
print 'Cfg.AddSSISApplicationPackage stored procedure created.'
print ''

/* cfg.GetSSISApplication stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'cfg'
            And p.name = 'GetSSISApplication')
 begin
  print 'Dropping cfg.GetSSISApplication stored procedure'
  Drop Procedure cfg.GetSSISApplication 
  print 'Cfg.GetSSISApplication stored procedure dropped'
 end
print 'Creating cfg.GetSSISApplication stored procedure'
go

/*
 (c) 2011,2012 Linchpin People, LLC
*/
Create Procedure cfg.GetSSISApplication
 @ApplicationName varchar(255)
As 

Select p.PackageFolder + p.PackageName As PackagePath
    , ap.ExecutionOrder
    , p.PackageName
    , p.PackageFolder
    , ap.AppPackageID
From cfg.AppPackages ap
Inner Join cfg.Packages p on p.PackageID = ap.PackageID
Inner Join cfg.Applications a on a.ApplicationID = ap.ApplicationID
Where ApplicationName = @ApplicationName
Order By ap.ExecutionOrder
go
print 'Cfg.GetSSISApplication stored procedure created.'
print ''

/* log schema */
If Not Exists(Select name
              From sys.schemas
              Where name = 'log')
 begin
  print 'Creating log schema'
  declare @sql varchar(100) = 'Create Schema [log]'
  exec(@sql)
  print 'Log schema created'
 end
Else
 print 'Log schema already exists.'
print ''


/* log.SSISAppInstance table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
              Join sys.schemas s
                On s.schema_id = t.schema_id
              Where s.name = 'log'
                And t.name = 'SSISAppInstance')
 begin
  print 'Creating log.SSISAppInstance table'
  Create Table [log].SSISAppInstance
  (
    AppInstanceID int identity(1,1)
     Constraint PK_SSISAppInstance
      Primary Key Clustered
   ,ApplicationID int Not Null
	 Constraint FK_logSSISAppInstance_cfgApplication_ApplicationID
	  Foreign Key References cfg.Applications(ApplicationID)
   ,StartDateTime datetime Not Null
     Constraint DF_cfgSSISAppInstance_StartDateTime
      Default(GetDate())
   ,EndDateTime datetime Null
   ,[Status] varchar(12) Null
  )
  print 'Log.SSISAppInstance created'
 end
Else
 print 'Log.SSISAppInstance table already exists.'
print ''

/* log.LogStartOfApplication stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogStartOfApplication')
 begin
  print 'Dropping log.LogStartOfApplication stored procedure'
  Drop Procedure [log].LogStartOfApplication 
  print 'Log.LogStartOfApplication stored procedure dropped'
 end
print 'Creating log.LogStartOfApplication stored procedure'
go

Create Procedure [log].LogStartOfApplication
 @ApplicationName varchar(255)
As

declare @ErrMsg varchar(255)
declare @AppID int = (Select ApplicationID
                      From cfg.Applications
                      Where ApplicationName = @ApplicationName)

If (@AppID Is Null)
 begin
  set @ErrMsg = 'Cannot find ApplicationName ' + Coalesce(@ApplicationName, '<NULL>')
  raiserror(@ErrMsg,16,1)
  return-1
 end

Insert Into [log].SSISAppInstance
 (ApplicationID, StartDateTime, Status)
 Output inserted.AppInstanceID
 Values
 (@AppID, GetDate(), 'Running')
go
print 'Log.LogStartOfApplication stored procedure created.'
print ''



/* log.LogApplicationSuccess stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogApplicationSuccess')
 begin
  print 'Dropping log.LogApplicationSuccess stored procedure'
  Drop Procedure [log].LogApplicationSuccess 
  print 'Log.LogApplicationSuccess stored procedure dropped'
 end
print 'Creating log.LogApplicationSuccess stored procedure'
go

Create Procedure [log].LogApplicationSuccess
 @AppInstanceID int
As

 update log.SSISAppInstance
 set EndDateTime = GetDate()
   , Status = 'Success'
 where AppInstanceID = @AppInstanceID
go
print 'Log.LogApplicationSuccess stored procedure created.'
print ''


/* log.LogApplicationFailure stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogApplicationFailure')
 begin
  print 'Dropping log.LogApplicationFailure stored procedure'
  Drop Procedure [log].LogApplicationFailure 
  print 'Log.LogApplicationFailure stored procedure dropped'
 end
print 'Creating log.LogApplicationFailure stored procedure'
go

Create Procedure [log].LogApplicationFailure
 @AppInstanceID int
As

 update log.SSISAppInstance
 set EndDateTime = GetDate()
   , Status = 'Failed'
 where AppInstanceID = @AppInstanceID
go
print 'Log.LogApplicationFailure stored procedure created.'


/* log.SSISPkgInstance table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
              Join sys.schemas s
                On s.schema_id = t.schema_id
              Where s.name = 'log'
                And t.name = 'SSISPkgInstance')
 begin
  print 'Creating log.SSISPkgInstance table'
  Create Table [log].SSISPkgInstance
  (
    PkgInstanceID int identity(1,1)
     Constraint PK_SSISPkgInstance Primary Key Clustered
   ,AppInstanceID int Not Null
	 Constraint FK_logSSISPkgInstance_logSSISAppInstance_AppInstanceID
	  Foreign Key References [log].SSISAppInstance(AppInstanceID)
   ,AppPackageID int Not Null
	 Constraint FK_logSSISPkgInstance_cfgAppPackages_AppPackageID
	  Foreign Key References cfg.AppPackages(AppPackageID)
   ,StartDateTime datetime Not Null
     Constraint DF_cfgSSISPkgInstance_StartDateTime
      Default(GetDate())
   ,EndDateTime datetime Null
   ,[Status] varchar(12) Null
  )
  print 'Log.SSISPkgInstance created'
 end
Else
 print 'Log.SSISPkgInstance table already exists.'
print ''

/* log.LogStartOfPackage stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogStartOfPackage')
 begin
  print 'Dropping log.LogStartOfPackage stored procedure'
  Drop Procedure [log].LogStartOfPackage 
  print 'Log.LogStartOfPackage stored procedure dropped'
 end
print 'Creating log.LogStartOfPackage stored procedure'
go

Create Procedure [log].LogStartOfPackage
 @AppInstanceID int
,@AppPackageID int
As

declare @ErrMsg varchar(255)

Insert Into log.SSISPkgInstance
 (AppInstanceID, AppPackageID, StartDateTime, Status)
 Output inserted.PkgInstanceID
 Values
 (@AppInstanceID, @AppPackageID, GetDate(), 'Running')
go
print 'Log.SSISPkgInstance stored procedure created.'
print ''

/* log.LogPackageSuccess stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogPackageSuccess')
 begin
  print 'Dropping log.LogPackageSuccess stored procedure'
  Drop Procedure [log].LogPackageSuccess 
  print 'Log.LogPackageSuccess stored procedure dropped'
 end
print 'Creating log.LogPackageSuccess stored procedure'
go

Create Procedure [log].LogPackageSuccess
 @PkgInstanceID int
As

 update log.SSISPkgInstance
 set EndDateTime = GetDate()
   , Status = 'Success'
 where PkgInstanceID = @PkgInstanceID
go
print 'Log.LogPackageSuccess stored procedure created.'
print ''


/* log.LogPackageFailure stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogPackageFailure')
 begin
  print 'Dropping log.LogPackageFailure stored procedure'
  Drop Procedure [log].LogPackageFailure 
  print 'Log.LogPackageFailure stored procedure dropped'
 end
print 'Creating log.LogPackageFailure stored procedure'
go

Create Procedure [log].LogPackageFailure
 @PkgInstanceID int
As

 update log.SSISPkgInstance
 set EndDateTime = GetDate()
   , Status = 'Failed'
 where PkgInstanceID = @PkgInstanceID
go
print 'Log.LogPackageFailure stored procedure created.'
print ''
print ''





GO





Use SSISConfig
go

/* Variable Declaration */
declare @PackageFolder varchar(255) = 'F:\SSIS 2012 Design Patterns\SSISConfig2012\SSISConfig2012\'
declare @PackageName varchar(255) = 'Child1.dtsx'
declare @PackageID int
declare @ExecutionOrder int = 10


 declare @ApplicationName varchar(255) = 'SSISApp1'
 declare @ApplicationID int

/* Add the SSIS First Application */
If Not Exists(Select ApplicationName
              From cfg.Applications
              Where ApplicationName = @ApplicationName)
 begin
  print 'Adding ' + @ApplicationName
  exec cfg.AddSSISApplication @ApplicationName, @ApplicationID output
  print @ApplicationName + ' added.'
 end
Else
 begin
  Select @ApplicationID = ApplicationID
  From cfg.Applications
  Where ApplicationName = @ApplicationName
  print @ApplicationName + ' already exists in the Framework.'
 end
print ''

/* Add the Child1.dtsx SSIS Package*/
If Not Exists(Select PackageFolder + PackageName
              From cfg.Packages
              Where PackageFolder = @PackageFolder
                And PackageName = @PackageName)
 begin
  print 'Adding ' + @PackageFolder + @PackageName
  exec cfg.AddSSISPackage @PackageName, @PackageFolder, @PackageID output
 end
Else
 begin
  Select @PackageID = PackageID
  From cfg.Packages
  Where PackageFolder = @PackageFolder
    And PackageName = @PackageName
  print @PackageFolder + @PackageName + ' already exists in the Framework.'
 end

 If Not Exists(Select AppPackageID
              From cfg.AppPackages
              Where ApplicationID = @ApplicationID
                And PackageID = @PackageID
                And ExecutionOrder = @ExecutionOrder)
 begin
  print 'Adding ' + @ApplicationName + '.' + @PackageName + ' to Framework with ExecutionOrder ' + convert(varchar, @ExecutionOrder)
  exec cfg.AddSSISApplicationPackage @ApplicationID, @PackageID, @ExecutionOrder
  print @PackageName + ' added and wired to ' + @ApplicationName
 end
Else
 print @ApplicationName + '.' + @PackageName + ' already exists in the Framework with ExecutionOrder ' + convert(varchar, @ExecutionOrder)


/*Child2.dtsx */
set @PackageName = 'Child2.dtsx'
set @ExecutionOrder = 20

If Not Exists(Select PackageFolder + PackageName
              From cfg.Packages
              Where PackageFolder = @PackageFolder
                And PackageName = @PackageName)
 begin
  print 'Adding ' + @PackageFolder + @PackageName
  exec cfg.AddSSISPackage @PackageName, @PackageFolder, @PackageID output
 end
Else
 begin
  Select @PackageID = PackageID
  From cfg.Packages
  Where PackageFolder = @PackageFolder
    And PackageName = @PackageName
  print @PackageFolder + @PackageName + ' already exists in the Framework.'
 end

If Not Exists(Select AppPackageID
              From cfg.AppPackages
              Where ApplicationID = @ApplicationID
                And PackageID = @PackageID
                And ExecutionOrder = @ExecutionOrder)
 begin
  print 'Adding ' + @ApplicationName + '.' + @PackageName + ' to Framework with ExecutionOrder ' + convert(varchar, @ExecutionOrder)
  exec cfg.AddSSISApplicationPackage @ApplicationID, @PackageID, @ExecutionOrder
  print @PackageName + ' added and wired to ' + @ApplicationName
 end
Else
 print @ApplicationName + '.' + @PackageName + ' already exists in the Framework with ExecutionOrder ' + convert(varchar, @ExecutionOrder)
print ''

/*ErrorTest.dtsx */
set @PackageName = 'ErrorTest.dtsx'
set @ExecutionOrder = 30

If Not Exists(Select PackageFolder + PackageName
              From cfg.Packages
              Where PackageFolder = @PackageFolder
                And PackageName = @PackageName)
 begin
  print 'Adding ' + @PackageFolder + @PackageName
  exec cfg.AddSSISPackage @PackageName, @PackageFolder, @PackageID output
 end
Else
 begin
  Select @PackageID = PackageID
  From cfg.Packages
  Where PackageFolder = @PackageFolder
    And PackageName = @PackageName
  print @PackageFolder + @PackageName + ' already exists in the Framework.'
 end

If Not Exists(Select AppPackageID
              From cfg.AppPackages
              Where ApplicationID = @ApplicationID
                And PackageID = @PackageID
                And ExecutionOrder = @ExecutionOrder)
 begin
  print 'Adding ' + @ApplicationName + '.' + @PackageName + ' to Framework with ExecutionOrder ' + convert(varchar, @ExecutionOrder)
  exec cfg.AddSSISApplicationPackage @ApplicationID, @PackageID, @ExecutionOrder
  print @PackageName + ' added and wired to ' + @ApplicationName
 end
Else
 print @ApplicationName + '.' + @PackageName + ' already exists in the Framework with ExecutionOrder ' + convert(varchar, @ExecutionOrder)







exec cfg.GetSSISApplication 'SSISApp1'
