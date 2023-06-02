with VT AS (SELECT db_name(s.database_id) as DB_NAME,s.login_time,s.last_request_start_time,s.status,s.session_id,s.program_name,s.login_name, s.host_name, s.host_process_id,s.total_elapsed_time, (select text from sys.dm_exec_sql_text(r.sql_handle)) as command
FROM sys.dm_exec_sessions AS s
left join sys.dm_exec_requests AS r
on r.session_id = s.session_id
--where s.status ='running'
)
SELECT DB_NAME,COMMAND,COUNT(*)
FROM VT
WHERE DB_NAME<> 'master'
GROUP BY command,DB_NAME
