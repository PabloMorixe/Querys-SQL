	select 
    d.name as 'database',
    mdf.physical_name as 'mdf_file', mdf.size as 'size',
    ldf.physical_name as 'log_file', ldf.size as 'size'
from sys.databases d
inner join sys.master_files mdf on 
    d.database_id = mdf.database_id and mdf.[type] = 0
inner join sys.master_files ldf on 
    d.database_id = ldf.database_id and ldf.[type] = 1