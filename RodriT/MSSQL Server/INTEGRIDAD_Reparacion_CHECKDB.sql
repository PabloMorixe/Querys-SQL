
/*Se realiza Backup de la base*/
BACKUP DATABASE [SICC] TO  DISK = N'\\dqgdt-01\Backups\Rodri\SICC - Chequeo Integridad\20210304_SICC-PREVIA REPARACION PRD.bak' 
WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'SICC-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO


/*Ponemos la DB en EMERGENCIA*/
ALTER DATABASE [SICC] SET EMERGENCY WITH ROLLBACK IMMEDIATE;

------------------------------------------------------------------------------
/*Ponemos la DB en SINGLE USER para que nadie se conecte*/

ALTER DATABASE [SICC] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
use SICC
go

/*Corremos el proceso que va a detallar los errores*/

DBCC CHECKDB ('SICC') WITH ALL_ERRORMSGS, NO_INFOMSGS, DATA_PURITY,MAXDOP  = 8;

sp_spaceused 'saldos' 

/*Corremos el proceso que va a detallar los errores pero con reparacion*/
DBCC CHECKDB ('SICC', REPAIR_ALLOW_DATA_LOSS) WITH ALL_ERRORMSGS; 
GO

sp_spaceused 'saldos' 

/*Corremos el chequeo nuevamente para corroborar que no hay errores*/
DBCC CHECKDB ('SICC') WITH ALL_ERRORMSGS, NO_INFOMSGS, DATA_PURITY,MAXDOP  = 8;

/*Ponemos la base en Linea nuevamente*/

ALTER DATABASE [SICC] SET MULTI_USER

ALTER DATABASE [SICC] SET ONLINE