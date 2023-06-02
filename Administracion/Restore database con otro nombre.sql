-- Lista el conjunto de archivos desde el backup
RESTORE FILELISTONLY
   FROM DISK = '\\FSHARE05\BACKUP\SQL05\BKP_Salc.BAK'


-- Restaura el backup a una BD con un nuevo nombre y nuevos nombres de archivos físicos
RESTORE DATABASE SALC_TEST
   FROM DISK = '\\FSHARE05\BACKUP\SQL05\BKP_Salc.BAK'
   WITH RECOVERY,
   MOVE 'SALC_Data' TO 'V:\Program Files\Microsoft SQL Server\MSSQL\data\SALC_TEST_Data.MDF', 
   MOVE 'SALC_Log' TO 'L:\SALC_TEST_Log.LDF'
GO
