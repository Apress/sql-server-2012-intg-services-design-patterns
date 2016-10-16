/*

   SSISConfig 
   9 Sep 2011
   Andy Leonard
   v0.1 - Initial Release
   
*/

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

Create Procedure cfg.GetSSISApplication
 @ApplicationName varchar(255)
As 

Select p.PackageFolder + p.PackageName As PackagePath
    , ap.ExecutionOrder
    , p.PackageName
    , p.PackageFolder
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
   ,PackageID int Not Null
	 Constraint FK_logSSISPkgInstance_cfgPackages_PackageID
	  Foreign Key References cfg.Packages(PackageID)
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


/* log.SSISErrors table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
              Join sys.schemas s
                On s.schema_id = t.schema_id
              Where s.name = 'log'
                And t.name = 'SSISErrors')
 begin
  print 'Creating log.SSISErrors table'
  Create Table [log].SSISErrors
  (
    ID int identity(1,1)
     Constraint PK_SSISErrors Primary Key Clustered
   ,AppInstanceID int Not Null
	 Constraint FK_logSSISErrors_logSSISAppInstance_AppInstanceID
	  Foreign Key References [log].SSISAppInstance(AppInstanceID)
   ,PkgInstanceID int Not Null
	 Constraint FK_logSSISErrors_logPkgInstance_PkgInstanceID
	  Foreign Key References [log].SSISPkgInstance(PkgInstanceID)
   ,ErrorDateTime datetime Not Null
     Constraint DF_logSSISErrors_ErrorDateTime
      Default(GetDate())
   ,ErrorDescription varchar(max) Null
   ,SourceName varchar(255) Null
  )
  print 'Log.SSISErrors created'
 end
Else
 print 'Log.SSISErrors table already exists.'
print ''


/* log.SSISEvents table */
If Not Exists(Select s.name + '.' + t.name
              From sys.tables t
              Join sys.schemas s
                On s.schema_id = t.schema_id
              Where s.name = 'log'
                And t.name = 'SSISEvents')
 begin
  print 'Creating log.SSISEvents table'
  Create Table [log].SSISEvents
  (
    ID int identity(1,1)
     Constraint PK_SSISEvents Primary Key Clustered
   ,AppInstanceID int Not Null
	 Constraint FK_logSSISEvents_logSSISAppInstance_AppInstanceID
	  Foreign Key References [log].SSISAppInstance(AppInstanceID)
   ,PkgInstanceID int Not Null
	 Constraint FK_logSSISEvents_logPkgInstance_PkgInstanceID
	  Foreign Key References [log].SSISPkgInstance(PkgInstanceID)
   ,EventDateTime datetime Not Null
     Constraint DF_logSSISEvents_ErrorDateTime
      Default(GetDate())
   ,EventDescription varchar(max) Null
   ,SourceName varchar(255) Null
  )
  print 'Log.SSISEvents created'
 end
Else
 print 'Log.SSISEvents table already exists.'
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


/* log.LogEvent stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogEvent')
 begin
  print 'Dropping log.LogEvent stored procedure'
  Drop Procedure [log].LogEvent 
  print 'Log.LogEvent stored procedure dropped'
 end
print 'Creating log.LogEvent stored procedure'
go

Create Procedure [log].LogEvent
 @AppInstanceID int
,@PkgInstanceID int
,@SourceName varchar(255)
,@EventDescription varchar(max)
As

 insert into [log].SSISEvents
 (AppInstanceID, PkgInstanceID, SourceName, EventDescription)
 Values
 (@AppInstanceID 
,@PkgInstanceID 
,@SourceName 
,@EventDescription)
go
print 'Log.LogEvent stored procedure created.'
print ''

/* log.LogError stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'log'
            And p.name = 'LogError')
 begin
  print 'Dropping log.LogError stored procedure'
  Drop Procedure [log].LogError 
  print 'Log.LogError stored procedure dropped'
 end
print 'Creating log.LogError stored procedure'
go

Create Procedure [log].LogError
 @AppInstanceID int
,@PkgInstanceID int
,@SourceName varchar(255)
,@ErrorDescription varchar(max)
As

 insert into log.SSISErrors
 (AppInstanceID, PkgInstanceID, SourceName, ErrorDescription)
 Values
 (@AppInstanceID 
,@PkgInstanceID 
,@SourceName 
,@ErrorDescription)
go
print 'Log.LogError stored procedure created.'
print ''


/*

   SSISConfig 
   06 Mar 2012
   Andy Leonard
   v0.2 - Adding rpt support
   
*/

Use SSISConfig
go

/* Adding 0 rows */
print 'Add Zero Rows'
print ' - cfg.Applications'

If Not Exists(Select ApplicationID
              From cfg.Applications
              Where ApplicationID = 0)
 begin
  print ' -- Inserting 0 row into cfg.Applications'
  Set Identity_Insert cfg.Applications ON
  Insert Into cfg.Applications
  (ApplicationID, ApplicationName)
  Values
  (0,'')
  print ' -- 0 row added to cfg.Applications'
  Set Identity_Insert cfg.Applications OFF
 end
Else
 print ' -- 0 row already exists in cfg.Applications.'
print ''

print ' - cfg.Packages'

If Not Exists(Select PackageID
              From cfg.Packages
              Where PackageID = 0)
 begin
  print ' -- Inserting 0 row into cfg.Packages'
  Set Identity_Insert cfg.Packages ON
  Insert Into cfg.Packages
  (PackageID, PackageFolder, PackageName)
  Values
  (0,'','')
  print ' -- 0 row added to cfg.Packages'
  Set Identity_Insert cfg.Packages OFF
 end
Else
 print ' -- 0 row already exists in cfg.Packages.'
print ''

print ' - log.SSISAppInstance'

If Not Exists(Select AppInstanceID
              From log.SSISAppInstance
              Where AppInstanceID = 0)
 begin
  print ' -- Inserting 0 row into log.SSISAppInstance'
  Set Identity_Insert log.SSISAppInstance ON
  Insert Into log.SSISAppInstance
  (AppInstanceID, ApplicationID, StartDateTime, EndDateTime, Status)
  Values
  (0,0,'1/1/1900','1/1/1900',NULL)
  print ' -- 0 row added to log.SSISAppInstance'
  Set Identity_Insert log.SSISAppInstance OFF
 end
Else
 print ' -- 0 row already exists in log.SSISAppInstance.'
print ''

print ' - log.SSISPkgInstance'

If Not Exists(Select PkgInstanceID
              From log.SSISPkgInstance
              Where PkgInstanceID = 0)
 begin
  print ' -- Inserting 0 row into log.SSISPkgInstance'
  Set Identity_Insert log.SSISPkgInstance ON
  Insert Into log.SSISPkgInstance
 (PkgInstanceID, AppInstanceID, AppPackageID, StartDateTime, EndDateTime, Status)
  Values
  (0,0,0,'1/1/1900','1/1/1900',NULL)
  print ' -- 0 row added to log.SSISPkgInstance'
  Set Identity_Insert log.SSISPkgInstance OFF
 end
Else
 print ' -- 0 row already exists in log.SSISPkgInstance.'
print ''


/* rpt schema */
If Not Exists(Select name
              From sys.schemas
              Where name = 'rpt')
 begin
  print 'Creating rpt schema'
  declare @sql varchar(100) = 'Create Schema rpt'
  exec(@sql)
  print 'Rpt schema created'
 end
Else
 print 'Rpt schema already exists.'
print ''


/* rpt.ReturnAppInstanceHeader stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnAppInstanceHeader')
 begin
  print 'Dropping rpt.ReturnAppInstanceHeader stored procedure'
  Drop Procedure rpt.ReturnAppInstanceHeader
  print 'Rpt.ReturnAppInstanceHeader stored procedure dropped'
 end
print 'Creating rpt.ReturnAppInstanceHeader stored procedure'
go

Create Procedure rpt.ReturnAppInstanceHeader
 @ApplicationName varchar(255) = NULL
As

  Select a.ApplicationID 
       ,ap.AppInstanceID
       ,a.ApplicationName
       ,ap.StartDateTime
       ,DateDiff(ss,ap.StartDateTime,Coalesce(ap.EndDateTime,GetDate())) As RunSeconds
       ,ap.Status
  From log.SSISAppInstance ap
  Join cfg.Applications a
    On ap.ApplicationID = a.ApplicationID
  Where a.ApplicationName = Coalesce(@ApplicationName,a.ApplicationName)
  Order by AppInstanceID desc

go
print 'Rpt.ReturnAppInstanceHeader stored procedure created.'
print ''


/* rpt.ReturnAppInstanceDetails stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnAppInstanceDetails')
 begin
  print 'Dropping rpt.ReturnAppInstanceDetails stored procedure'
  Drop Procedure rpt.ReturnAppInstanceDetails
  print 'Rpt.ReturnAppInstanceDetails stored procedure dropped'
 end
print 'Creating rpt.ReturnAppInstanceDetails stored procedure'
go

Create Procedure rpt.ReturnAppInstanceDetails
 @AppName varchar(255)
As

 Select
   ap.AppInstanceID
  ,a.ApplicationName
  ,ap.StartDateTime
  ,DateDiff(ss,ap.StartDateTime,Coalesce(ap.EndDateTime, GetDate())) As RunSeconds
  ,ap.Status
 From log.SSISAppInstance ap
 Join cfg.Applications a
   On ap.ApplicationID = a.ApplicationID
 Where a.ApplicationName = @AppName
 order by AppInstanceID desc
go
print 'Rpt.ReturnAppInstanceDetails stored procedure created.'
print ''


/* rpt.ReturnAppInstanceApps stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnAppInstanceApps')
 begin
  print 'Dropping rpt.ReturnAppInstanceApps stored procedure'
  Drop Procedure rpt.ReturnAppInstanceApps
  print 'Rpt.ReturnAppInstanceApps stored procedure dropped'
 end
print 'Creating rpt.ReturnAppInstanceApps stored procedure'
go

Create Procedure rpt.ReturnAppInstanceApps
As

 Select
   distinct a.ApplicationName
 from cfg.Applications a
 order by ApplicationName
go
print 'Rpt.ReturnAppInstanceApps stored procedure created.'
print ''



/* rpt.ReturnPkgInstanceHeader stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnPkgInstanceHeader')
 begin
  print 'Dropping rpt.ReturnPkgInstanceHeader stored procedure'
  Drop Procedure rpt.ReturnPkgInstanceHeader
  print 'Rpt.ReturnPkgInstanceHeader stored procedure dropped'
 end
print 'Creating rpt.ReturnPkgInstanceHeader stored procedure'
go

Create Procedure rpt.ReturnPkgInstanceHeader
 @AppInstanceID int
As

		SELECT a.ApplicationName
			  ,p.PackageFolder + p.PackageName As PackagePath
			  ,cp.StartDateTime
			  ,DateDiff(ss,cp.StartDateTime,Coalesce(cp.EndDateTime,GetDate())) As RunSeconds
			  ,cp.Status
			  ,ai.AppInstanceID
			  ,cp.PkgInstanceID
			  ,p.PackageID
			  ,p.PackageName
		  FROM log.SSISPkgInstance cp
		  Join cfg.AppPackages ap 
			on ap.PackageID = cp.AppPackageID
		  Join cfg.Packages p 
			on p.PackageID = ap.AppPackageID
		  Join log.SSISAppInstance ai
			on ai.AppInstanceID = cp.AppInstanceID
		  Join cfg.Applications a
			on a.ApplicationID = ap.ApplicationID
		 WHERE ai.AppInstanceID = Coalesce(@AppInstanceID,ai.AppInstanceID)
		  And a.ApplicationID > 0
		 Order By cp.PkgInstanceID desc
go
print 'Rpt.ReturnPkgInstanceHeader stored procedure created.'
print ''





/* rpt.ReturnPkgInstanceDetails stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnPkgInstanceDetails')
 begin
  print 'Dropping rpt.ReturnPkgInstanceDetails stored procedure'
  Drop Procedure rpt.ReturnPkgInstanceDetails
  print 'Rpt.ReturnPkgInstanceDetails stored procedure dropped'
 end
print 'Creating rpt.ReturnPkgInstanceDetails stored procedure'
go

Create Procedure rpt.ReturnPkgInstanceDetails
 @PackageID int
As
 Select
   a.ApplicationName
  ,p.PackageFolder + p.PackageName As PackagePath
  ,cp.StartDateTime
  ,DateDiff(ss,cp.StartDateTime,Coalesce(cp.EndDateTime,GetDate())) As RunSeconds
  ,cp.Status
  ,ai.AppInstanceID
  ,cp.PkgInstanceID
  ,p.PackageID
  ,a.ApplicationID
  ,p.PackageName
 FROM log.SSISPkgInstance cp
		  Join cfg.AppPackages ap 
			on ap.PackageID = cp.AppPackageID
		  Join cfg.Packages p 
			on p.PackageID = ap.AppPackageID
		  Join log.SSISAppInstance ai
			on ai.AppInstanceID = cp.AppInstanceID
		  Join cfg.Applications a
			on a.ApplicationID = ap.ApplicationID
 Where p.PackageID = Coalesce(@PackageID,p.PackageID)
		  And a.ApplicationID > 0
 Order By cp.PkgInstanceID Desc
go
print 'Rpt.ReturnPkgInstanceDetails stored procedure created.'
print ''



/* rpt.ReturnEvents stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnEvents')
 begin
  print 'Dropping rpt.ReturnEvents stored procedure'
  Drop Procedure rpt.ReturnEvents
  print 'Rpt.ReturnEvents stored procedure dropped'
 end
print 'Creating rpt.ReturnEvents stored procedure'
go

Create Procedure rpt.ReturnEvents
  @AppInstanceID int
 ,@PkgInstanceID int = NULL
As

  Select
    a.ApplicationName
   ,p.PackageName
   ,ev.SourceName
   ,ev.EventDateTime
   ,ev.EventDescription
  From log.SSISEvents ev
  Join log.SSISAppInstance ai
    On ai.AppInstanceID = ev.AppInstanceID
  Join cfg.Applications a
    On a.ApplicationID = ai.ApplicationID
  Join log.SSISPkgInstance cp
    On cp.PkgInstanceID = ev.PkgInstanceID
	And cp.AppInstanceID = ev.AppInstanceID
  Join cfg.AppPackages ap
    On ap.AppPackageID = cp.AppPackageID
  Join cfg.Packages p
    On p.PackageID = ap.PackageID
  Where ev.AppInstanceID = Coalesce(@AppInstanceID, ev.AppInstanceID)
    And ev.PkgInstanceID = Coalesce(@PkgInstanceID, ev.PkgInstanceID)
  Order By EventDateTime Desc
go
print 'Rpt.ReturnEvents stored procedure created.'
print ''





/* rpt.ReturnErrors stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnErrors')
 begin
  print 'Dropping rpt.ReturnErrors stored procedure'
  Drop Procedure rpt.ReturnErrors
  print 'Rpt.ReturnErrors stored procedure dropped'
 end
print 'Creating rpt.ReturnErrors stored procedure'
go

Create Procedure rpt.ReturnErrors
  @AppInstanceID int
 ,@PkgInstanceID int = NULL
As

  Select
    a.ApplicationName
   ,p.PackageName
   ,er.SourceName
   ,er.ErrorDateTime
   ,er.ErrorDescription
  From log.SSISErrors er
  Join log.SSISAppInstance ai
    On ai.AppInstanceID = er.AppInstanceID
  Join cfg.Applications a
    On a.ApplicationID = ai.ApplicationID
  Join log.SSISPkgInstance cp
    On cp.PkgInstanceID = er.PkgInstanceID
	And cp.AppInstanceID = er.AppInstanceID
  Join cfg.AppPackages ap
    On ap.AppPackageID = cp.AppPackageID
  Join cfg.Packages p
    On p.PackageID = ap.PackageID
  Where er.AppInstanceID = Coalesce(@AppInstanceID, er.AppInstanceID)
    And er.PkgInstanceID = Coalesce(@PkgInstanceID, er.PkgInstanceID)
  Order By ErrorDateTime Desc
go
print 'Rpt.ReturnErrors stored procedure created.'
print ''





/* rpt.ReturnApplicationList stored procedure */
If Exists(Select s.name + '.' + p.name
          From sys.procedures p
          Join sys.schemas s
            On s.schema_id = p.schema_id
          Where s.name = 'rpt'
            And p.name = 'ReturnApplicationList')
 begin
  print 'Dropping rpt.ReturnApplicationList stored procedure'
  Drop Procedure rpt.ReturnApplicationList
  print 'Rpt.ReturnApplicationList stored procedure dropped'
 end
print 'Creating rpt.ReturnApplicationList stored procedure'
go

Create Procedure rpt.ReturnApplicationList
  @ApplicationID int = NULL
 ,@PackageID int = NULL
As

  Select
        a.ApplicationName 
      , a.ApplicationID
      , p.PackageID
      , p.PackageFolder + p.PackageName As PackagePath
      , ap.ExecutionOrder
      , p.PackageName
      , p.PackageFolder
  From cfg.AppPackages ap
  Join cfg.Packages p
    On p.PackageID = ap.PackageID
  Join cfg.Applications a 
    On a.ApplicationID = ap.ApplicationID
  Where a.ApplicationID = Coalesce(@ApplicationID, a.ApplicationID)
    And p.PackageID = Coalesce(@PackageID, p.PackageID)
  Order By a.ApplicationName, ap.ExecutionOrder
go
print 'Rpt.ReturnApplicationList stored procedure created.'
print ''

