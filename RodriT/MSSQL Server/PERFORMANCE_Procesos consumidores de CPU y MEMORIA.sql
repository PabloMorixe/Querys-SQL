/*QUERYS QUE CONSUMEN MUCHO CPUY MEMORIA*/

SELECT TOP 100 
            total_worker_time/execution_count AS [Avg CPU Time],
            (
                        SELECT SUBSTRING(text,statement_start_offset/2,(CASE WHEN statement_end_offset = -1 then LEN(CONVERT(nvarchar(max), text)) * 2 ELSE statement_end_offset end -statement_start_offset)/2) 
                        FROM sys.dm_exec_sql_text(sql_handle)
            ) AS query_text 
            ,*
FROM 
                        sys.dm_exec_query_stats 
ORDER BY 
                        total_elapsed_time DESC


SELECT TOP 100 
            total_worker_time/execution_count AS [Avg CPU Time],
            (
                        SELECT SUBSTRING(text,statement_start_offset/2,(CASE WHEN statement_end_offset = -1 then LEN(CONVERT(nvarchar(max), text)) * 2 ELSE statement_end_offset end -statement_start_offset)/2) 
                        FROM sys.dm_exec_sql_text(sql_handle)
            ) AS query_text 
,*
FROM 
                        sys.dm_exec_query_stats 
ORDER BY 
                        total_worker_time DESC



SELECT TOP 100 
total_worker_time/execution_count AS [Avg CPU Time],
(
            SELECT 
                        SUBSTRING(
                                   text,
                                   statement_start_offset/2,
                                   (CASE 
                                               WHEN statement_end_offset = -1 
                                                           then LEN(CONVERT(nvarchar(max), text)) * 2 
                                               ELSE statement_end_offset 
                                   end -statement_start_offset)/2
                        ) 
            FROM sys.dm_exec_sql_text(sql_handle)) AS query_text 
,*
FROM 
                        sys.dm_exec_query_stats 
order by 
                        total_physical_reads desc


SELECT TOP 100 
total_worker_time/execution_count AS [Avg CPU Time],
(
            SELECT SUBSTRING(text,statement_start_offset/2,(CASE WHEN statement_end_offset = -1 then LEN(CONVERT(nvarchar(max), text)) * 2 ELSE statement_end_offset end -statement_start_offset)/2) 
            FROM sys.dm_exec_sql_text(sql_handle)) AS query_text 
,*
FROM sys.dm_exec_query_stats 
order by total_logical_reads desc
