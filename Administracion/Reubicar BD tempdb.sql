--SENTENCIAS
------------

USE tempdb
GO


ALTER DATABASE tempdb
MODIFY FILE ( NAME = tempdev , FILENAME = [l:\sqldata\tempdb.mdf] )
GO
ALTER DATABASE tempdb
MODIFY FILE ( NAME = templog , FILENAME = [c:\sqldata\templog.ldf] )
GO


/*
METODO
------

Procedimiento de reubicación planeada para mantenimiento de disco programado

Para mover un archivo de registro o datos de bases de datos del sistema como parte de una operación de reubicación planeada o de mantenimiento programado,
siga estos pasos. Este procedimiento se aplica a todas las bases de datos del sistema, excepto las bases de datos master y Resource.

   1. Para cada archivo que se va a mover, ejecute la siguiente instrucción.

      ALTER DATABASE database_name MODIFY FILE ( NAME = logical_name , FILENAME = 'new_path\os_file_name' )

   2. Detenga la instancia de SQL Server o cierre el sistema para realizar el mantenimiento. Para obtener más información, vea Detener servicios.
   3. Mueva el archivo o los archivos a la nueva ubicación.
   4. Reinicie la instancia de SQL Server o el servidor. Para obtener más información, vea Iniciar y reiniciar servicios.
   5. Compruebe el cambio de los archivos ejecutando la siguiente consulta.

      SELECT name, physical_name AS CurrentLocation, state_desc
      FROM sys.master_files
      WHERE database_id = DB_ID(N'<database_name>');


*/