/****************************************************/
/* Created by: SQL Server vNext CTP1.0 Profiler          */
/* Date: 17/08/2022  09:57:39         */
/****************************************************/


-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 5 

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

exec @rc = sp_trace_create @TraceID output, 0, N'InsertFileNameHere', @maxfilesize, NULL 
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 148, 1, @on
exec sp_trace_setevent @TraceID, 148, 41, @on
exec sp_trace_setevent @TraceID, 148, 4, @on
exec sp_trace_setevent @TraceID, 148, 12, @on
exec sp_trace_setevent @TraceID, 148, 11, @on
exec sp_trace_setevent @TraceID, 148, 51, @on
exec sp_trace_setevent @TraceID, 148, 14, @on
exec sp_trace_setevent @TraceID, 148, 26, @on
exec sp_trace_setevent @TraceID, 148, 60, @on
exec sp_trace_setevent @TraceID, 148, 64, @on
exec sp_trace_setevent @TraceID, 25, 1, @on
exec sp_trace_setevent @TraceID, 25, 9, @on
exec sp_trace_setevent @TraceID, 25, 2, @on
exec sp_trace_setevent @TraceID, 25, 66, @on
exec sp_trace_setevent @TraceID, 25, 10, @on
exec sp_trace_setevent @TraceID, 25, 3, @on
exec sp_trace_setevent @TraceID, 25, 4, @on
exec sp_trace_setevent @TraceID, 25, 6, @on
exec sp_trace_setevent @TraceID, 25, 7, @on
exec sp_trace_setevent @TraceID, 25, 8, @on
exec sp_trace_setevent @TraceID, 25, 11, @on
exec sp_trace_setevent @TraceID, 25, 12, @on
exec sp_trace_setevent @TraceID, 25, 13, @on
exec sp_trace_setevent @TraceID, 25, 14, @on
exec sp_trace_setevent @TraceID, 25, 15, @on
exec sp_trace_setevent @TraceID, 25, 22, @on
exec sp_trace_setevent @TraceID, 25, 25, @on
exec sp_trace_setevent @TraceID, 25, 26, @on
exec sp_trace_setevent @TraceID, 25, 32, @on
exec sp_trace_setevent @TraceID, 25, 35, @on
exec sp_trace_setevent @TraceID, 25, 41, @on
exec sp_trace_setevent @TraceID, 25, 49, @on
exec sp_trace_setevent @TraceID, 25, 51, @on
exec sp_trace_setevent @TraceID, 25, 52, @on
exec sp_trace_setevent @TraceID, 25, 55, @on
exec sp_trace_setevent @TraceID, 25, 56, @on
exec sp_trace_setevent @TraceID, 25, 57, @on
exec sp_trace_setevent @TraceID, 25, 58, @on
exec sp_trace_setevent @TraceID, 25, 60, @on
exec sp_trace_setevent @TraceID, 25, 64, @on
exec sp_trace_setevent @TraceID, 189, 1, @on
exec sp_trace_setevent @TraceID, 189, 9, @on
exec sp_trace_setevent @TraceID, 189, 2, @on
exec sp_trace_setevent @TraceID, 189, 66, @on
exec sp_trace_setevent @TraceID, 189, 10, @on
exec sp_trace_setevent @TraceID, 189, 3, @on
exec sp_trace_setevent @TraceID, 189, 4, @on
exec sp_trace_setevent @TraceID, 189, 6, @on
exec sp_trace_setevent @TraceID, 189, 7, @on
exec sp_trace_setevent @TraceID, 189, 8, @on
exec sp_trace_setevent @TraceID, 189, 11, @on
exec sp_trace_setevent @TraceID, 189, 12, @on
exec sp_trace_setevent @TraceID, 189, 13, @on
exec sp_trace_setevent @TraceID, 189, 14, @on
exec sp_trace_setevent @TraceID, 189, 15, @on
exec sp_trace_setevent @TraceID, 189, 22, @on
exec sp_trace_setevent @TraceID, 189, 26, @on
exec sp_trace_setevent @TraceID, 189, 32, @on
exec sp_trace_setevent @TraceID, 189, 35, @on
exec sp_trace_setevent @TraceID, 189, 41, @on
exec sp_trace_setevent @TraceID, 189, 49, @on
exec sp_trace_setevent @TraceID, 189, 51, @on
exec sp_trace_setevent @TraceID, 189, 52, @on
exec sp_trace_setevent @TraceID, 189, 55, @on
exec sp_trace_setevent @TraceID, 189, 56, @on
exec sp_trace_setevent @TraceID, 189, 57, @on
exec sp_trace_setevent @TraceID, 189, 58, @on
exec sp_trace_setevent @TraceID, 189, 60, @on
exec sp_trace_setevent @TraceID, 189, 64, @on
exec sp_trace_setevent @TraceID, 14, 1, @on
exec sp_trace_setevent @TraceID, 14, 9, @on
exec sp_trace_setevent @TraceID, 14, 2, @on
exec sp_trace_setevent @TraceID, 14, 66, @on
exec sp_trace_setevent @TraceID, 14, 10, @on
exec sp_trace_setevent @TraceID, 14, 3, @on
exec sp_trace_setevent @TraceID, 14, 11, @on
exec sp_trace_setevent @TraceID, 14, 6, @on
exec sp_trace_setevent @TraceID, 14, 7, @on
exec sp_trace_setevent @TraceID, 14, 8, @on
exec sp_trace_setevent @TraceID, 14, 12, @on
exec sp_trace_setevent @TraceID, 14, 14, @on
exec sp_trace_setevent @TraceID, 14, 21, @on
exec sp_trace_setevent @TraceID, 14, 23, @on
exec sp_trace_setevent @TraceID, 14, 25, @on
exec sp_trace_setevent @TraceID, 14, 26, @on
exec sp_trace_setevent @TraceID, 14, 35, @on
exec sp_trace_setevent @TraceID, 14, 41, @on
exec sp_trace_setevent @TraceID, 14, 49, @on
exec sp_trace_setevent @TraceID, 14, 51, @on
exec sp_trace_setevent @TraceID, 14, 57, @on
exec sp_trace_setevent @TraceID, 14, 60, @on
exec sp_trace_setevent @TraceID, 14, 64, @on
exec sp_trace_setevent @TraceID, 17, 1, @on
exec sp_trace_setevent @TraceID, 17, 9, @on
exec sp_trace_setevent @TraceID, 17, 2, @on
exec sp_trace_setevent @TraceID, 17, 66, @on
exec sp_trace_setevent @TraceID, 17, 10, @on
exec sp_trace_setevent @TraceID, 17, 3, @on
exec sp_trace_setevent @TraceID, 17, 11, @on
exec sp_trace_setevent @TraceID, 17, 6, @on
exec sp_trace_setevent @TraceID, 17, 7, @on
exec sp_trace_setevent @TraceID, 17, 8, @on
exec sp_trace_setevent @TraceID, 17, 12, @on
exec sp_trace_setevent @TraceID, 17, 13, @on
exec sp_trace_setevent @TraceID, 17, 14, @on
exec sp_trace_setevent @TraceID, 17, 15, @on
exec sp_trace_setevent @TraceID, 17, 25, @on
exec sp_trace_setevent @TraceID, 17, 26, @on
exec sp_trace_setevent @TraceID, 17, 35, @on
exec sp_trace_setevent @TraceID, 17, 41, @on
exec sp_trace_setevent @TraceID, 17, 49, @on
exec sp_trace_setevent @TraceID, 17, 51, @on
exec sp_trace_setevent @TraceID, 17, 55, @on
exec sp_trace_setevent @TraceID, 17, 57, @on
exec sp_trace_setevent @TraceID, 17, 60, @on
exec sp_trace_setevent @TraceID, 17, 64, @on
exec sp_trace_setevent @TraceID, 10, 1, @on
exec sp_trace_setevent @TraceID, 10, 9, @on
exec sp_trace_setevent @TraceID, 10, 2, @on
exec sp_trace_setevent @TraceID, 10, 66, @on
exec sp_trace_setevent @TraceID, 10, 10, @on
exec sp_trace_setevent @TraceID, 10, 3, @on
exec sp_trace_setevent @TraceID, 10, 4, @on
exec sp_trace_setevent @TraceID, 10, 6, @on
exec sp_trace_setevent @TraceID, 10, 7, @on
exec sp_trace_setevent @TraceID, 10, 8, @on
exec sp_trace_setevent @TraceID, 10, 11, @on
exec sp_trace_setevent @TraceID, 10, 12, @on
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 10, 14, @on
exec sp_trace_setevent @TraceID, 10, 15, @on
exec sp_trace_setevent @TraceID, 10, 16, @on
exec sp_trace_setevent @TraceID, 10, 17, @on
exec sp_trace_setevent @TraceID, 10, 18, @on
exec sp_trace_setevent @TraceID, 10, 25, @on
exec sp_trace_setevent @TraceID, 10, 26, @on
exec sp_trace_setevent @TraceID, 10, 31, @on
exec sp_trace_setevent @TraceID, 10, 34, @on
exec sp_trace_setevent @TraceID, 10, 35, @on
exec sp_trace_setevent @TraceID, 10, 41, @on
exec sp_trace_setevent @TraceID, 10, 48, @on
exec sp_trace_setevent @TraceID, 10, 49, @on
exec sp_trace_setevent @TraceID, 10, 50, @on
exec sp_trace_setevent @TraceID, 10, 51, @on
exec sp_trace_setevent @TraceID, 10, 60, @on
exec sp_trace_setevent @TraceID, 10, 64, @on
exec sp_trace_setevent @TraceID, 43, 1, @on
exec sp_trace_setevent @TraceID, 43, 9, @on
exec sp_trace_setevent @TraceID, 43, 2, @on
exec sp_trace_setevent @TraceID, 43, 66, @on
exec sp_trace_setevent @TraceID, 43, 3, @on
exec sp_trace_setevent @TraceID, 43, 4, @on
exec sp_trace_setevent @TraceID, 43, 5, @on
exec sp_trace_setevent @TraceID, 43, 6, @on
exec sp_trace_setevent @TraceID, 43, 7, @on
exec sp_trace_setevent @TraceID, 43, 8, @on
exec sp_trace_setevent @TraceID, 43, 10, @on
exec sp_trace_setevent @TraceID, 43, 11, @on
exec sp_trace_setevent @TraceID, 43, 12, @on
exec sp_trace_setevent @TraceID, 43, 13, @on
exec sp_trace_setevent @TraceID, 43, 14, @on
exec sp_trace_setevent @TraceID, 43, 15, @on
exec sp_trace_setevent @TraceID, 43, 22, @on
exec sp_trace_setevent @TraceID, 43, 26, @on
exec sp_trace_setevent @TraceID, 43, 28, @on
exec sp_trace_setevent @TraceID, 43, 29, @on
exec sp_trace_setevent @TraceID, 43, 34, @on
exec sp_trace_setevent @TraceID, 43, 35, @on
exec sp_trace_setevent @TraceID, 43, 41, @on
exec sp_trace_setevent @TraceID, 43, 48, @on
exec sp_trace_setevent @TraceID, 43, 49, @on
exec sp_trace_setevent @TraceID, 43, 50, @on
exec sp_trace_setevent @TraceID, 43, 51, @on
exec sp_trace_setevent @TraceID, 43, 60, @on
exec sp_trace_setevent @TraceID, 43, 62, @on
exec sp_trace_setevent @TraceID, 43, 64, @on
exec sp_trace_setevent @TraceID, 45, 1, @on
exec sp_trace_setevent @TraceID, 45, 9, @on
exec sp_trace_setevent @TraceID, 45, 3, @on
exec sp_trace_setevent @TraceID, 45, 4, @on
exec sp_trace_setevent @TraceID, 45, 5, @on
exec sp_trace_setevent @TraceID, 45, 6, @on
exec sp_trace_setevent @TraceID, 45, 7, @on
exec sp_trace_setevent @TraceID, 45, 8, @on
exec sp_trace_setevent @TraceID, 45, 10, @on
exec sp_trace_setevent @TraceID, 45, 11, @on
exec sp_trace_setevent @TraceID, 45, 12, @on
exec sp_trace_setevent @TraceID, 45, 13, @on
exec sp_trace_setevent @TraceID, 45, 14, @on
exec sp_trace_setevent @TraceID, 45, 15, @on
exec sp_trace_setevent @TraceID, 45, 16, @on
exec sp_trace_setevent @TraceID, 45, 17, @on
exec sp_trace_setevent @TraceID, 45, 18, @on
exec sp_trace_setevent @TraceID, 45, 22, @on
exec sp_trace_setevent @TraceID, 45, 25, @on
exec sp_trace_setevent @TraceID, 45, 26, @on
exec sp_trace_setevent @TraceID, 45, 28, @on
exec sp_trace_setevent @TraceID, 45, 29, @on
exec sp_trace_setevent @TraceID, 45, 34, @on
exec sp_trace_setevent @TraceID, 45, 35, @on
exec sp_trace_setevent @TraceID, 45, 41, @on
exec sp_trace_setevent @TraceID, 45, 48, @on
exec sp_trace_setevent @TraceID, 45, 49, @on
exec sp_trace_setevent @TraceID, 45, 50, @on
exec sp_trace_setevent @TraceID, 45, 51, @on
exec sp_trace_setevent @TraceID, 45, 55, @on
exec sp_trace_setevent @TraceID, 45, 60, @on
exec sp_trace_setevent @TraceID, 45, 61, @on
exec sp_trace_setevent @TraceID, 45, 62, @on
exec sp_trace_setevent @TraceID, 45, 64, @on
exec sp_trace_setevent @TraceID, 45, 66, @on
exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 9, @on
exec sp_trace_setevent @TraceID, 12, 3, @on
exec sp_trace_setevent @TraceID, 12, 11, @on
exec sp_trace_setevent @TraceID, 12, 4, @on
exec sp_trace_setevent @TraceID, 12, 6, @on
exec sp_trace_setevent @TraceID, 12, 7, @on
exec sp_trace_setevent @TraceID, 12, 8, @on
exec sp_trace_setevent @TraceID, 12, 10, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on
exec sp_trace_setevent @TraceID, 12, 14, @on
exec sp_trace_setevent @TraceID, 12, 15, @on
exec sp_trace_setevent @TraceID, 12, 16, @on
exec sp_trace_setevent @TraceID, 12, 17, @on
exec sp_trace_setevent @TraceID, 12, 18, @on
exec sp_trace_setevent @TraceID, 12, 26, @on
exec sp_trace_setevent @TraceID, 12, 31, @on
exec sp_trace_setevent @TraceID, 12, 35, @on
exec sp_trace_setevent @TraceID, 12, 41, @on
exec sp_trace_setevent @TraceID, 12, 48, @on
exec sp_trace_setevent @TraceID, 12, 49, @on
exec sp_trace_setevent @TraceID, 12, 50, @on
exec sp_trace_setevent @TraceID, 12, 51, @on
exec sp_trace_setevent @TraceID, 12, 60, @on
exec sp_trace_setevent @TraceID, 12, 64, @on
exec sp_trace_setevent @TraceID, 12, 66, @on
exec sp_trace_setevent @TraceID, 41, 1, @on
exec sp_trace_setevent @TraceID, 41, 9, @on
exec sp_trace_setevent @TraceID, 41, 3, @on
exec sp_trace_setevent @TraceID, 41, 4, @on
exec sp_trace_setevent @TraceID, 41, 5, @on
exec sp_trace_setevent @TraceID, 41, 6, @on
exec sp_trace_setevent @TraceID, 41, 7, @on
exec sp_trace_setevent @TraceID, 41, 8, @on
exec sp_trace_setevent @TraceID, 41, 10, @on
exec sp_trace_setevent @TraceID, 41, 11, @on
exec sp_trace_setevent @TraceID, 41, 12, @on
exec sp_trace_setevent @TraceID, 41, 13, @on
exec sp_trace_setevent @TraceID, 41, 14, @on
exec sp_trace_setevent @TraceID, 41, 15, @on
exec sp_trace_setevent @TraceID, 41, 16, @on
exec sp_trace_setevent @TraceID, 41, 17, @on
exec sp_trace_setevent @TraceID, 41, 18, @on
exec sp_trace_setevent @TraceID, 41, 25, @on
exec sp_trace_setevent @TraceID, 41, 26, @on
exec sp_trace_setevent @TraceID, 41, 29, @on
exec sp_trace_setevent @TraceID, 41, 35, @on
exec sp_trace_setevent @TraceID, 41, 41, @on
exec sp_trace_setevent @TraceID, 41, 48, @on
exec sp_trace_setevent @TraceID, 41, 49, @on
exec sp_trace_setevent @TraceID, 41, 50, @on
exec sp_trace_setevent @TraceID, 41, 51, @on
exec sp_trace_setevent @TraceID, 41, 55, @on
exec sp_trace_setevent @TraceID, 41, 60, @on
exec sp_trace_setevent @TraceID, 41, 61, @on
exec sp_trace_setevent @TraceID, 41, 64, @on
exec sp_trace_setevent @TraceID, 41, 66, @on


-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler - f0c2b91a-385d-4d08-8667-f50c09f7add2'
-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
go
