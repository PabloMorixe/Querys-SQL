Execute the following Microsoft SQL Server T-SQL example scripts in Management Studio Query Editor to lists the last backup date, backup size, duration and physical device name.

-- Microsoft SQL Server database backup information from msdb system database
-- T-SQL latest backup date - latest database backup
-- MSSQL stored procedure create
-- SQL select from select - left outer join - left join

CREATE PROCEDURE spLastDBBackupStatistics
AS
  SELECT   DatabaseName = b.database_name,
           LastBackupDate = a.backup_date,
           PhysicalDeviceName = physical_device_name,
           BackupSizeMB = convert(INT,backup_size),
           DurationMinutes = duration
  FROM     (SELECT   sd.name                    AS database_name,
                     MAX(bs.backup_finish_date) AS backup_date
            FROM     MASTER.dbo.sysdatabases sd
                     LEFT OUTER JOIN msdb.dbo.backupset bs
                       ON sd.name = bs.database_name
                     LEFT OUTER JOIN (
                     SELECT   sd.name                                AS database_name,
                              MAX(bs.backup_finish_date)             AS backup_date,
                              bm.physical_device_name,
                              bs.backup_size / 1024 / 1024           AS backup_size,
             DATEDIFF(mi,bs.backup_start_date,bs.backup_finish_date) AS duration
                     FROM     MASTER.dbo.sysdatabases sd
                              LEFT OUTER JOIN msdb.dbo.backupset bs
                                ON sd.name = bs.database_name
                              LEFT OUTER JOIN msdb.dbo.backupmediafamily bm
                                ON bm.media_set_id = bs.media_set_id
                     GROUP BY sd.name,
                              bm.physical_device_name,
                              bs.backup_size / 1024 / 1024,
            DATEDIFF(mi,bs.backup_start_date,bs.backup_finish_date)) Summary
                       ON Summary.database_name = sd.name
                          AND Summary.backup_date = bs.backup_finish_date
            GROUP BY sd.name) a,
           (SELECT   sd.name                    AS database_name,
                     MAX(bs.backup_finish_date) AS backup_date,
                     Summary.physical_device_name,
                     Summary.backup_size,
                     Summary.duration
            FROM     MASTER.dbo.sysdatabases sd
                     LEFT OUTER JOIN msdb.dbo.backupset bs
                       ON sd.name = bs.database_name
                     LEFT OUTER JOIN (
                     SELECT   sd.name                               AS database_name,
                              MAX(bs.backup_finish_date)            AS backup_date,
                              bm.physical_device_name,
                              bs.backup_size / 1024 / 1024          AS backup_size,
            DATEDIFF(mi,bs.backup_start_date,bs.backup_finish_date) AS duration
                     FROM     MASTER.dbo.sysdatabases sd
                              LEFT OUTER JOIN msdb.dbo.backupset bs
                                ON sd.name = bs.database_name
                              LEFT OUTER JOIN msdb.dbo.backupmediafamily bm
                                ON bm.media_set_id = bs.media_set_id
                     GROUP BY sd.name,
                              bm.physical_device_name,
                              bs.backup_size / 1024 / 1024,
            DATEDIFF(mi,bs.backup_start_date,bs.backup_finish_date)) Summary
                       ON Summary.database_name = sd.name
                          AND Summary.backup_date = bs.backup_finish_date
            GROUP BY sd.name,
                     bs.backup_finish_date,
                     Summary.physical_device_name,
                     Summary.backup_size,
                     Summary.duration) b
  WHERE    a.database_name = b.database_name
           AND a.backup_date = b.Backup_date
  ORDER BY DatabaseName
GO


-- T-SQL test stored procedure - exec stored procedure - execute sproc
EXEC spLastDBBackupStatistics 
GO

 

/* Partial results


DatabaseName            LastBackupDate          PhysicalDeviceName
AdventureWorks          2016-02-12 16:37:18.000 F:\sample\backup\AW.bak
AdventureWorks2008      2016-03-11 14:21:09.000 F:\sample\backup\AW8.bak
AdventureWorksDW        2016-02-12 16:41:24.000 F:\sample\backup\AWDW.bak