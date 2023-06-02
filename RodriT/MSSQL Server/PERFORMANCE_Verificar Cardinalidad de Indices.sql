--Arroja la estadistica de todos los indices  (temporales y creados) de la Tabla deseada

EXEC sp_helpstats 'Sales.SalesOrderDetail', 'ALL';
GO

 


---------------------------------------------------------------------------------
-- muestra las estadisticas de un indice, cardinalidad, etc.

 

DBCC SHOW_STATISTICS ("Sales.SalesOrderDetail", IX_SalesOrderDetail_ProductID);