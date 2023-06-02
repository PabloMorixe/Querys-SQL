use  master
go
-- DROP PROCEDURE DBO.P_VIEW_JOB_SCHEDULED
-- GO
CREATE PROCEDURE DBO.P_VIEW_JOB_SCHEDULED
(@fecha smalldatetime = NULL
)
AS

CREATE TABLE #Job_Activity(
[Server] [nvarchar](128) NOT NULL CONSTRAINT [DF_Job_Activity_Server] DEFAULT (@@servername),
[session_id] [int] NOT NULL,
[job_id] [uniqueidentifier] NOT NULL,
[job_name] [sysname] NOT NULL,
[run_requested_date] [datetime] NULL,
[run_requested_source] [sysname] NULL,
[queued_date] [datetime] NULL,
[start_execution_date] [datetime] NULL,
[last_executed_step_id] [int] NULL,
[last_exectued_step_date] [datetime] NULL,
[stop_execution_date] [datetime] NULL,
[next_scheduled_run_date] [datetime] NULL,
[job_history_id] [int] NULL,
[message] [nvarchar](1024) NULL,
[run_status] [int] NULL,
[operator_id_emailed] [int] NULL,
[operator_id_netsent] [int] NULL,
[operator_id_paged] [int] NULL,
[Row_inserted_date] [datetime] NOT NULL CONSTRAINT [DF_Row_inserted_date] DEFAULT (getdate())
) ON [PRIMARY]

INSERT INTO #Job_Activity
(
[session_id]
,[job_id]
,[job_name]
,[run_requested_date]
,[run_requested_source]
,[queued_date]
,[start_execution_date]
,[last_executed_step_id]
,[last_exectued_step_date]
,[stop_execution_date]
,[next_scheduled_run_date]
,[job_history_id]
,[message]
,[run_status]
,[operator_id_emailed]
,[operator_id_netsent]
,[operator_id_paged]
)
EXECUTE [msdb].[dbo].[sp_help_jobactivity] 

IF @fecha IS NULL
BEGIN
SELECT * 
FROM #Job_Activity
WHERE next_scheduled_run_date IS NOT NULL
END
ELSE
BEGIN
SELECT * 
FROM #Job_Activity
WHERE next_scheduled_run_date >= @fecha
AND next_scheduled_run_date < DATEADD(dd,1,@fecha)
END
GO
_____________________________________________________________

--MUESTRA LOS JOBS DE UNA FECHA
EXECUTE DBO.P_VIEW_JOB_SCHEDULED @fecha = '20110129'
_____________________________________________________________

--MUESTRA TODOS LOS JOBS PLANIFICADOS (TIENE NEXT_RUN_DATE)
EXECUTE DBO.P_VIEW_JOB_SCHEDULED
_____________________________________________________________