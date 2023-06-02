--detalle de espacio ocupado Particion, Registros por Pagina, Espacio ocupado por cada lote de paginas
SELECT partition_number, row_count,used_page_count, (used_page_count)*8/1024 as 'space_used (GB)' FROM sys.dm_db_partition_stats
where row_count>0 and partition_number <> 1
order by 1


--Espacio ocupado por cada particion
SELECT partition_number, sum((used_page_count)*8/1024) as 'space_used (MB)' FROM sys.dm_db_partition_stats
where row_count>0 and partition_number <> 1
group by partition_number
order by 1


--numero total de paginas, numero total de registros de todas las particiones
USE SOA;  
GO  
SELECT SUM(used_page_count) AS total_number_of_used_pages,   
    SUM (row_count) AS total_number_of_rows   
FROM sys.dm_db_partition_stats  
WHERE object_id=OBJECT_ID('monitoring.T_AUDIT')    AND (index_id=0 or index_id=1);  
GO  