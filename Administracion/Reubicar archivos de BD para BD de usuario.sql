Procedimiento de reubicación planeada



===========================
=OPCION CON ALTER DATABASE=
===========================

Para mover un archivo de datos o de registros como parte de una reubicación planeada, siga estos pasos:

   1. Ejecute la instrucción siguiente:

      ALTER DATABASE database_name SET OFFLINE

   2. Mueva el archivo o los archivos a la nueva ubicación.
   3. Con cada archivo que mueva, ejecute la instrucción siguiente:

      ALTER DATABASE database_name MODIFY FILE ( NAME = logical_name, FILENAME = 'new_path\os_file_name' )

   4. Ejecute la instrucción siguiente:

      ALTER DATABASE database_name SET ONLINE

   5. Compruebe el cambio de archivo ejecutando la consulta siguiente:

      SELECT name, physical_name AS CurrentLocation, state_desc
      FROM sys.master_files
      WHERE database_id = DB_ID(N'<database_name>');


	  
	  
	  
	  
	  
===========================
=OPCION CON DETTACH/ATTACH=
===========================

	1. Desconectar todas las conexiones actuales

	2. Ejecutar un Detach de la BD
		EXEC sp_detach_db N'AdventureWorks'
	
	3. Mover los archivos .MDF, .NDF y .LOG en el SO a sus nuevas ubicaciones
	
	4. Ejecutar un Attach de la BD apuntando a las nuevas ubicaciones de cada archivo

		EXEC sp_attach_db N'AdventureWorks',
		'c:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\AdventureWorks_Data.mdf',
		'c:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\AdventureWorks_Log.LDF'
		
	5. Comprobar el cambio de archivos con la instrucción
	
		USE DBNAME
		GO
	
		EXEC SP_HELPFILE