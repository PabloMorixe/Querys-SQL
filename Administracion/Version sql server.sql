Identificar la versi�n de SQL Server 2000 y 2005 en ejecuci�n
-------------------------------------------------------------

SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')




Identificar la versi�n de SQL Server 2000 en ejecuci�n
------------------------------------------------------
SELECT  SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')




Identificar la versi�n de SQL Server 6.5 y 7 en ejecuci�n
---------------------------------------------------------
SELECT @@VERSION