Use SSISDB
Go

Set NoCount On

Declare @ApplicationName nvarchar(256)
Declare @ApplicationDescription nvarchar(512)
Declare @ApplicationID int
Declare @FolderName nvarchar(256)
Declare @ProjectName nvarchar(256)
Declare @PackageName nvarchar(256)
Declare @PackageDescription nvarchar(512)
Declare @PackageID int
Declare @ExecutionOrder int
Declare @ApplicationPackageEnabled bit
Declare @ApplicationTbl table(ApplicationID int)
Declare @PackageTbl table(PackageID int)

begin tran

 -- Build Application --
Select @ApplicationName = 'TestSSISApp'
      ,@ApplicationDescription = 'A test SSIS application'

Insert Into @ApplicationTbl
Exec custom.AddApplication
  @ApplicationName
 ,@ApplicationDescription

 Select @ApplicationID = ApplicationID 
 From @ApplicationTbl


 -- Build Package --
Select @FolderName = 'Chapter2'
      ,@ProjectName = 'Chapter 2'
      ,@PackageName = 'Chapter2.dtsx'
      ,@PackageDescription = 'A test SSIS package'

Insert Into @PackageTbl
Exec custom.AddPackage
  @FolderName
 ,@ProjectName
 ,@PackageName
 ,@PackageDescription

 Select @PackageID = PackageID 
 From @PackageTbl


  -- Build ApplicationPackage --
Select @ExecutionOrder = 10
       ,@ApplicationPackageEnabled = 1

 Exec custom.AddApplicationPackage
   @ApplicationID
  ,@PackageID
  ,@ExecutionOrder
  ,@ApplicationPackageEnabled

 Delete @PackageTbl


 -- Build Package --
Select @FolderName = 'Chapter2'
      ,@ProjectName = 'Chapter 2'
      ,@PackageName = 'Chapter2.dtsx'
      ,@PackageDescription = 'Another test SSIS package'

Insert Into @PackageTbl
Exec custom.AddPackage
  @FolderName
 ,@ProjectName
 ,@PackageName
 ,@PackageDescription

 Select @PackageID = PackageID 
 From @PackageTbl


  -- Build ApplicationPackage --
Select @ExecutionOrder = 20
       ,@ApplicationPackageEnabled = 1

 Exec custom.AddApplicationPackage
   @ApplicationID
  ,@PackageID
  ,@ExecutionOrder
  ,@ApplicationPackageEnabled

 Delete @PackageTbl

Commit
