--Esto te pasa el acumulado de backup de log agrupado por dia


use msdb

select 
	database_name,
	cast(backup_start_date as date) As fecha ,
	sum(backup_size)/1000000000 as tamaño,
	sum(compressed_backup_size)/1000000000 as comprimido, 
	100*(sum(compressed_backup_size)/sum(backup_size)) as porcentaje_de_compresion 
from 
	backupset 
where 
	type='L' 
and database_name='soa'
group by 
	database_name,
	cast(backup_start_date as date)	
order by 
	fecha
