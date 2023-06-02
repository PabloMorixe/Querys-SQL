--https://www.sqlskills.com/blogs/erin/trending-database-growth-from-backups/

/*Muestra los registros correspondientes al crecimiento de backups en el tiempo para poder estimar el crecimiento de la
base de datos. Cuando la base hace backup resguarda datos puros sin tener en cuenta el tamaño de indices, por eso el backup es mas chico
que la base misma. Luego calcula la diferencia de los datos puros que resguardo y eso es lo que refleja en el crecimiento de datos del backup */

-- Transact-SQL script to analyse the database size growth using backup history. 
DECLARE @endDate datetime, @months smallint; 
declare @database varchar(100)
SET @endDate = GetDate();  -- Include in the statistic all backups from today 
SET @months = 12;           -- back to the last 6 months. 
Set @database='Tableros'
 
;WITH HIST AS 
   (SELECT BS.database_name AS DatabaseName 
          ,YEAR(BS.backup_start_date) * 100 
           + MONTH(BS.backup_start_date) AS YearMonth 
          ,CONVERT(numeric(10, 1), MIN(BF.file_size / 1048576.0)) AS MinSizeMB 
          ,CONVERT(numeric(10, 1), MAX(BF.file_size / 1048576.0)) AS MaxSizeMB 
          ,CONVERT(numeric(10, 1), AVG(BF.file_size / 1048576.0)) AS AvgSizeMB 
    FROM msdb.dbo.backupset as BS 
         INNER JOIN 
         msdb.dbo.backupfile AS BF 
             ON BS.backup_set_id = BF.backup_set_id 
    WHERE NOT BS.database_name IN 
              ('master', 'msdb', 'model', 'tempdb') 
          AND BF.file_type = 'D' 
          AND BS.backup_start_date BETWEEN DATEADD(mm, - @months, @endDate) AND @endDate 
		  AND bs.database_name = @database
    GROUP BY BS.database_name 
            ,YEAR(BS.backup_start_date) 
            ,MONTH(BS.backup_start_date)) 
SELECT MAIN.DatabaseName 
      ,MAIN.YearMonth 
      ,MAIN.MinSizeMB 
      ,MAIN.MaxSizeMB 
      ,MAIN.AvgSizeMB 
      ,MAIN.AvgSizeMB  
       - (SELECT TOP 1 SUB.AvgSizeMB 
          FROM HIST AS SUB 
          WHERE SUB.DatabaseName = MAIN.DatabaseName 
                AND SUB.YearMonth < MAIN.YearMonth 
          ORDER BY SUB.YearMonth DESC) AS GrowthMB 
FROM HIST AS MAIN 
ORDER BY MAIN.DatabaseName 
        ,MAIN.YearMonth