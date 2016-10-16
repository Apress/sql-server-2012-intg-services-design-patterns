USE [master];
GO

/* Check to see if the database already exists; if it does exist, do nothing */
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'PDW_Source_Example')
BEGIN
    /* Create a database to experiment with */
    CREATE DATABASE [PDW_Source_Example] 
        ON PRIMARY 
        (
            NAME = N'PDW_Source_Example'
          , FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\PDW_Source_Example.mdf' 
          , SIZE = 1024MB 
          , MAXSIZE = UNLIMITED
          , FILEGROWTH = 1024MB
        )
        LOG ON 
        ( 
            NAME = N'PDW_Source_Example_log'
          , FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\PDW_Source_Example_log.ldf' 
          , SIZE = 256MB
          , MAXSIZE = UNLIMITED
          , FILEGROWTH = 256MB
        );
END
GO
