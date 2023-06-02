/*Genera el script para activar el Query Store en una instancia, solo las bases de Usuario y excluye a la Sqlmant*/


DECLARE @command varchar(1000) 

SELECT @command = 'IF ''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'', ''sqlmant'') 
                   BEGIN USE ? 
                         EXEC(''alter database ? SET QUERY_STORE = ON'')
                         EXEC(''alter database ? SET QUERY_STORE (OPERATION_MODE = READ_WRITE, MAX_STORAGE_SIZE_MB = 1024)'')
                   END'

EXEC sp_MSforeachdb @command
