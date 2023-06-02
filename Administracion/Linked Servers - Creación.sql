/*
sp_addlinkedserver [ @server= ] 'server' [ , [ @srvproduct= ] 'product_name' ] 
     [ , [ @provider= ] 'provider_name' ]
     [ , [ @datasrc= ] 'data_source' ] 
     [ , [ @location= ] 'location' ] 
     [ , [ @provstr= ] 'provider_string' ] 
     [ , [ @catalog= ] 'catalog' ] 

sp_addlinkedsrvlogin [ @rmtsrvname= ] 'rmtsrvname' 
     [ , [ @useself= ] 'TRUE' | 'FALSE' | NULL ] 
     [ , [ @locallogin= ] 'locallogin' ] 
     [ , [ @rmtuser= ] 'rmtuser' ] 
     [ , [ @rmtpassword= ] 'rmtpassword' ] 

	 
HELP: http://msdn.microsoft.com/es-es/library/ms190479.aspx
	 
*/



--EJEMPLO

--PASO 1
EXEC sp_addlinkedserver 'CLSQL05', '', 'SQLNCLI', 'CLSQL05', NULL, NULL, NULL

--PASO 2
EXEC sp_addlinkedsrvlogin 'CLSQL05', False, NULL, 'LEDESMA_SEGURIDAD', 'seguridad_ledesma'






--PARA ELIMINAR UN LINKED SERVER CON SUS LOGINS ASOCIADOS
EXEC sp_dropserver 'CLSQL05', 'droplogins'