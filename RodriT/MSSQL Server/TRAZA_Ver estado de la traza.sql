/* CONSULTAR LAS TRAZAS CORRIENDO EN EL SERVIDOR*/
/*===============================================*/

USE [master]
SELECT T.id,
CASE T.status WHEN 0 THEN 'stopped' ELSE 'running' END AS [Status],
T.path,
CASE T.is_shutdown WHEN 0 THEN N'disabled' ELSE N'enabled' END AS [Is Shutdown?],
T.start_time,
T.stop_time
FROM sys.traces as T
WHERE T.is_default <> 1
GO

/* DETENER UNA TRAZA*/
/*===============================================*/


EXEC sp_trace_setstatus 1, 0 

EXEC sp_trace_setstatus 1, 2
