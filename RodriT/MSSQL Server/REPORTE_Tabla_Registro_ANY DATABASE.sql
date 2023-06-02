select o.name Tabla,SUM(row_count) as Registros,s.object_id
from sys.dm_db_partition_stats s join sys.objects o on s.object_id=o.object_id
where s.index_id in (0,1)and o.type='u'
group by s.object_id,s.index_id,o.name