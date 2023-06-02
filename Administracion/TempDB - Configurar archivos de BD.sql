USE tempdb
GO

--Crear un nuevo archivo de datos en TEMPDB
ALTER DATABASE tempdb
ADD FILE 
(
	NAME = tempdev1,
	FILENAME = 'V:\Data\tempdb1.ndf',
	SIZE = 5GB,
	MAXSIZE = 5GB,
	FILEGROWTH = 0
);
GO


--Configurar un archivo de datos en TEMPDB
ALTER DATABASE tempdb 
MODIFY FILE
(
	NAME = tempdev,
	SIZE = 5GB,
	MAXSIZE = 5GB,
	FILEGROWTH = 0
)

