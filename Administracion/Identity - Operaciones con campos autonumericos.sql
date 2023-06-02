--Allows explicit values to be inserted into the identity column of a table.
SET IDENTITY_INSERT [ database_name . [ schema_name ] . ] table { ON | OFF }

--VALOR DEL IDENTITY ACTUAL
DBCC CHECKIDENT ('Tabla', NORESEED)

--RESETEO DEL IDENTITY AL VALOR DADO POR EL TERCER PARAMETRO
DBCC CHECKIDENT ('Tabla', RESEED, 0)

--DESHABILITAR IDENTITY
SET IDENTITY_INSERT [Tabla] 