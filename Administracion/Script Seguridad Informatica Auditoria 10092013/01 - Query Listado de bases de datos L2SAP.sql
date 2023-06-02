SELECT name FROM SYS.databases
WHERE name NOT IN ('tempdb', 'model')
AND source_database_id IS  NULL
AND state_desc = 'ONLINE'