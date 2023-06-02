--******************************************************
--ejecucion 
--exec DBA_BackupFull 'F:\DataBase\BackUp'
--******************************************************

USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[DBA_BackupFull]    Script Date: 12/14/2020 2:10:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<prodriguez>
-- Create date: <21-oct-2019>
-- Description:	<Backup full all Databases>
-- =============================================

------------------------------------------
-- CAMBIAR EL PATH POR EL CORRESPONDIENTE
------------------------------------------

CREATE PROCEDURE [dbo].[DBA_BackupFull](@BackupPath as VARCHAR(250))
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @path VARCHAR(250)

	SELECT @path = @BackupPath+'\'
 
	CREATE TABLE #bases
		(Base VARCHAR (150),
		 ESTADO INT)

	INSERT #bases 
	SELECT [name],0 FROM master.sys.databases
	WHERE name not in ('tempdb','model')
	AND state_desc = 'ONLINE'
	ORDER BY name

	DECLARE 
		@BaseAct VARCHAR(150),
		@command VARCHAR (800),
		@indexCMD VARCHAR (800),
		@Indice	VARCHAR(150),
		@Tabla	VARCHAR(150),
		@Base	VARCHAR(150)

	WHILE EXISTS (SELECT * FROM #BASES WHERE ESTADO = 0)
	BEGIN
	SELECT @BaseAct = base FROM #Bases WHERE ESTADO = 0 ORDER BY Base
	SELECT @command= 'BACKUP DATABASE ['+ @BaseAct +']'+ CHAR(13)+ 'TO DISK ='''+@Path + @BaseAct + convert(varchar(500),GetDate(),112) + '.bak''
	WITH FORMAT, STATS = 10'
	IF SUBSTRING(@@version,1,25)<> 'Microsoft SQL Server 2005'
		SELECT @command = @command + ',COMPRESSION'
	
	PRINT @command
	EXEC (@command)

	UPDATE #Bases SET estado = 1 WHERE @BaseAct= Base
	END

	DROP TABLE #BASES

END

GO


