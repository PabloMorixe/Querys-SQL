SELECT DB_NAME(database_id) DatabaseName,
OBJECT_NAME(object_id) ProcedureName,
cached_time, last_execution_time, execution_count,
total_elapsed_time/execution_count AS avg_elapsed_time,
type_desc
FROM sys.dm_exec_procedure_stats
ORDER BY avg_elapsed_time;