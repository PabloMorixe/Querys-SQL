/*Te paso el procedimiento final si los rebuild de los indices no funcionan.*/



--Use master;
--ALTER DATABASE LexorSECPrendarios SET EMERGENCY;
-- DBCC checkdb(LexorSECPrendarios);
--ALTER DATABASE LexorSECPrendarios SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--DBCC CheckDB (LexorSECPrendarios, REPAIR_ALLOW_DATA_LOSS)  WITH NO_INFOMSGS;
--ALTER DATABASE LexorSECPrendarios SET MULTI_USER;



--chequeo de service pack de sql server
SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition') 
