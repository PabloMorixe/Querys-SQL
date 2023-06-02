select * from sys.dm_hadr_availability_replica_states


--https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-hadr-availability---replica-states-transact-sql

SELECT 
r.replica_server_name, 
       d.database_name, 
       h.redo_rate, 
       h.redo_queue_size, 
       h.filestream_send_rate, 
       h.end_of_log_lsn, 
       h.last_sent_lsn, 
       h.last_hardened_lsn, 
       h.last_redone_lsn, 
       h.last_received_lsn, 
       h.last_commit_lsn, 
       h.last_commit_time, 
       (h.redo_queue_size/h.redo_rate)*100 as [Advance %] 
FROM   sys.dm_hadr_database_replica_states h 
       INNER JOIN sys.availability_databases_cluster d 
               ON h.group_id = d.group_id 
              
       INNER JOIN sys.availability_replicas r 
               ON  r.group_id = d.group_id 
WHERE  d.database_name = 'emerix'
------------------------------------------------------------

SELECT d.database_name, 
       r.replica_server_name, 
       h.synchronization_state_desc, 
       h.synchronization_health_desc 
FROM   sys.dm_hadr_database_replica_states h 
       INNER JOIN sys.availability_databases_cluster d 
               ON h.group_id = d.group_id 
                  AND h.group_database_id = d.group_database_id 
       INNER JOIN sys.availability_replicas r 
               ON  r.group_id = d.group_id 
WHERE  d.database_name = 'emerix' 
       AND r.replica_server_name = 'sspr17emx-01';
