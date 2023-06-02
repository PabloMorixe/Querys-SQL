-------------------------------------------------------------
-- Activa el seguimiento de bloqueos
-------------------------------------------------------------

--Make sure you don't have any pending changes
SELECT *
FROM sys.configurations
WHERE value <> value_in_use;
GO

exec sp_configure 'show advanced options', 1;
GO
RECONFIGURE
GO

exec sp_configure 'blocked process threshold (s)', 30;
GO
RECONFIGURE
GO


-------------------------------------------------------------
-- Crea la traza de seguimiento (corre por 5 minutos)
--
-- **********************************************************
-- **********************************************************
-- **********************************************************
-- *****
-- *****     IMPORTANTE: Corregir el path del archivo !!!!!
-- *****
-- **********************************************************
-- **********************************************************
-- **********************************************************
--
-------------------------------------------------------------

-- Created by: SQL Server 2012  Profiler
-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
declare @DateTime datetime

---------Added a function here:
set @DateTime = DATEADD(mi,5,getdate());  /* ------------- Run for five minutes --------------*/
set @maxfilesize = 5

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

-----------Set my filename here:
exec @rc = sp_trace_create @TraceID output, 0, N'c:\_Basura\BlockedProcessReportDemo', @maxfilesize, @Datetime
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 137, 1, @on
exec sp_trace_setevent @TraceID, 137, 12, @on

-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error:
select ErrorCode=@rc

finish:
go





/*
------------------------------------------------------
-- Esto es por si hace falta pararlo a mano
------------------------------------------------------

SELECT * from sys.traces;
GO

--Plug in the correct traceid from the query above
EXEC sp_trace_setstatus @traceid =2, @status = 0;
GO
EXEC sp_trace_setstatus @traceid =2, @status = 2;
GO

*/



-------------------------------------------------------------
-- Desactiva el seguimiento de bloqueos
-------------------------------------------------------------


--Make sure your trace is gone
SELECT * from sys.traces;
GO

 
--Turn off the blocked process report when you're not using it.
--Make sure you don't have any pending changes
SELECT *
FROM sys.configurations
WHERE value <> value_in_use;
GO
 
exec sp_configure 'blocked process threshold (s)', 0;
GO
RECONFIGURE
GO
 
exec sp_configure 'blocked process threshold (s)';
GO
