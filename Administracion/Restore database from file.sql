--Retrive the Logical file name of the database from backup
RESTORE FILELISTONLY
FROM DISK = 'D:BackUpYourBaackUpFile.bak'
GO


----Make Database to single user Mode
ALTER DATABASE YourDB
SET SINGLE_USER WITH
ROLLBACK IMMEDIATE --ojo!!!


----Restore Database
RESTORE DATABASE YourDB
FROM DISK = 'D:BackUpYourBaackUpFile.bak'
WITH MOVE 'YourMDFLogicalName' TO 'D:DataYourMDFFile.mdf',
MOVE 'YourLDFLogicalName' TO 'D:DataYourLDFFile.mdf'




/*If there is no error in statement before database will be in multiuser
mode.
If error occurs please execute following command it will convert
database in multi user.*/
ALTER DATABASE YourDB SET MULTI_USER
GO
