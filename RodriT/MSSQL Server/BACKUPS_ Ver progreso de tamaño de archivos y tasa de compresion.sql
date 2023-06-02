--select file_size, backup_size,* from dbo.backupfile

select database_name,
backup_start_date,backup_size/1000000000 as tamaño,
compressed_backup_size/1000000000 as comprimido
100*(compressed_backup_size/backup_size) as porcentaje_de_compresion 
from backupset where type='d' and database_name='eclearing_his'
 order by database_creation_date 