DECLARE @NOMBRE VARCHAR(255)
DECLARE @STSQL VARCHAR(1000)
DECLARE @USUARIOIIS VARCHAR(255)
SELECT @USUARIOIIS='[DOMINIO\USUARIO]'
DECLARE SPS SCROLL CURSOR FOR
SELECT name NOMBRE FROM sysobjects WHERE xtype='P'
OPEN SPS
FETCH FIRST FROM SPS INTO @NOMBRE
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @STSQL='GRANT EXEC ON ' + @NOMBRE + ' TO ' + @USUARIOIIS
EXEC (@STSQL)
PRINT (@STSQL)
FETCH NEXT FROM SPS INTO @NOMBRE
END
CLOSE SPS
DEALLOCATE SPS
GO