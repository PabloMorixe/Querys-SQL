SELECT DB_NAME (f.database_id) AS database_name, f.database_id, f.name AS logical_file_name, f.[file_id], f.type_desc,
 
CAST (CASE WHEN LEFT (LTRIM (f.physical_name), 2) = '\\' THEN LEFT (LTRIM (f.physical_name), CHARINDEX ('\', LTRIM (f.physical_name), CHARINDEX ('\', LTRIM (f.physical_name), 3) + 1) - 1)
 
WHEN CHARINDEX ('\', LTRIM(f.physical_name), 3) > 0 THEN UPPER (LEFT (LTRIM (f.physical_name), CHARINDEX ('\', LTRIM (f.physical_name), 3) - 1))
 
ELSE f.physical_name END AS nvarchar(255)) AS logical_disk,
 
fs.num_of_reads, fs.io_stall_read_ms, fs.num_of_writes, fs.io_stall_write_ms, fs.io_stall_read_ms / fs.num_of_reads AS CONTENCION_READ, fs.io_stall_write_ms / (fs.num_of_writes + 1) AS CONTENCION_WRITE
 
FROM sys.dm_io_virtual_file_stats (default, default) AS fs
 
INNER JOIN sys.master_files AS f ON fs.database_id = f.database_id AND fs.[file_id] = f.[file_id]

ORDER BY CONTENCION_WRITE DESC