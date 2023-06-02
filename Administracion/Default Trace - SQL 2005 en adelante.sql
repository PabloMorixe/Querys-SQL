--DEFAULT TRACE


--MAS INFO: http://www.sqlservercentral.com/articles/SQL+Server+2005/64547/




--Averiguar si Default Trace está habilitado en el servidor
SELECT * FROM sys.configurations WHERE configuration_id = 1568



--Reconfigurar las opciones del servidor para habilitar Default Trace
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'default trace enabled', 1;
GORECONFIGURE;
GO




--Ver propiedades de la traza
SELECT * FROM ::fn_trace_getinfo(0)



--Consultar la traza desde el archivo
SELECT *
FROM ::fn_trace_gettable('C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\LOG\log.trc',0)
INNER JOIN sys.trace_events e          ON eventclass = trace_event_id     
INNER JOIN sys.trace_categories AS cat          ON e.category_id = cat.category_id





--=================================
--REFERENCIA SOBRE TRAZAS
--=================================

--list of events
SELECT *FROM sys.trace_events

--list of categories
SELECT *
FROM sys.trace_categories

--list of subclass values
SELECT *
FROM sys.trace_subclass_values

--Get trace Event Columns
SELECT      t.EventID,     t.ColumnID,     e.name AS Event_Descr,     c.name AS Column_Descr
FROM ::fn_trace_geteventinfo(1) t     
INNER JOIN sys.trace_events e           ON t.eventID = e.trace_event_id     
INNER JOIN sys.trace_columns c           ON t.columnid = c.trace_column_id


