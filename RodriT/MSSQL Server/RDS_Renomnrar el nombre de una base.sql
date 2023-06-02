/*
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.CommonDBATasks.RenamingDB.html
*/

EXEC rdsadmin.dbo.rds_modify_db_name N'MOO', N'ZAR'
GO