SELECT spid,
sp.[status],
loginame [Login],
hostname,
blocked BlkBy,
sd.name DBName,
cmd Command,
cpu CPUTime,
physical_io DiskIO,
last_batch LastBatch,
[program_name] ProgramName,
(select text from sys.dm_exec_sql_text(sp.sql_handle)) as command,
r.wait_time, r.wait_type,r.last_wait_type,r.total_elapsed_time--,r.dop
FROM master.dbo.sysprocesses sp
JOIN master.dbo.sysdatabases sd ON sp.dbid = sd.dbid
left join sys.dm_exec_requests AS r
on r.session_id =spid
--WHERE blocked >0
where sp.[status]='sleeping' and loginame='usrsoa'

order by cpu desc