Identificar la versión de SQL Server 2000 y 2005 en ejecución
-------------------------------------------------------------

SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')




Identificar la versión de SQL Server 2000 en ejecución
------------------------------------------------------
SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')




Identificar la versión de SQL Server 6.5 y 7 en ejecución
---------------------------------------------------------
SELECT @@VERSION