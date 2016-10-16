USE [master];
GO

/* Check to see if the database already exists; if it does exist, do nothing */
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'dbaCentralLogging')
BEGIN
    /* Create a database to store our Chapter 1 examples */
    CREATE DATABASE [dbaCentralLogging] 
        ON PRIMARY 
        (
            NAME = N'dbaCentralLogging'
          , FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\dbaCentralLogging.mdf' 
          , SIZE = 1024MB 
          , MAXSIZE = UNLIMITED
          , FILEGROWTH = 1024MB
        )
        LOG ON 
        ( 
            NAME = N'dbaCentralLogging_log'
          , FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\dbaCentralLogging_log.ldf' 
          , SIZE = 256MB
          , MAXSIZE = UNLIMITED
          , FILEGROWTH = 256MB
        );
END
GO
