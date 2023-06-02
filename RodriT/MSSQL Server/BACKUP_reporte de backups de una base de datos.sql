DECLARE @DBName AS VARCHAR(100) = 'ebook'

 

SELECT 

  b.machine_name,

  b.server_name,

  b.database_name as DBName,

  b.backup_start_date,

  b.backup_finish_date,

  CASE 

    WHEN b.[type] = 'D' THEN 'Database'

    WHEN b.[type] = 'I' THEN 'Differential database'

    WHEN b.[type] = 'L' THEN 'Log'

    WHEN b.[type] = 'F' THEN 'File or filegroup'

    WHEN b.[type] = 'G' THEN 'Differential file'

    WHEN b.[type] = 'P' THEN 'Partial'

    WHEN b.[type] = 'Q' THEN 'Differential partial'

    ELSE b.[type]

  END Backup_Type,

  b.expiration_date,

  b.[user_name],

  DATEDIFF(MINUTE,b.backup_start_date ,b.backup_finish_date) as Total_Time_in_Minute,

  b.recovery_model,

  b.backup_size/(1024 * 1024 * 1024) as Total_Size_GB,

  bf.physical_device_name as Location

FROM 

  msdb.dbo.backupset AS b

INNER JOIN msdb.dbo.backupmediafamily AS bf

  ON b.media_set_id=bf.media_set_id

WHERE

  b.database_name = @DBName  

ORDER BY 

  b.backup_start_date DESC

GO