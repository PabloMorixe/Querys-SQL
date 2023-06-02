SELECT  --spid,
        --sp.[status],
       -- loginame [Login],
        --hostname,
        --blocked BlkBy,
        sd.name DB_Name,
        cmd Command,
       -- cpu CPUTime,
       -- physical_io DiskIO,
       -- last_batch LastBatch,
       -- [program_name] ProgramName
       count(*) as cant
FROM master.dbo.sysprocesses sp
JOIN master.dbo.sysdatabases sd ON sp.dbid = sd.dbid
--WHERE blocked >0
WHERE db_id(sd.name) >4
GROUP BY cmd,sd.name
order by 2 desc