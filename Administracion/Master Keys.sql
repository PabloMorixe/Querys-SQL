--Backup a archivo de la MASTER KEY de una BD
USE BD
GO

BACKUP MASTER KEY TO FILE = 'C:\path\archivo' 
    ENCRYPTION BY PASSWORD = 'password'


--Restore desde archivo de la MASTER KEY de una BD	
USE BD
GO
	
RESTORE MASTER KEY 
    FROM FILE = 'C:\path\archivo'
    DECRYPTION BY PASSWORD = 'password' 
    ENCRYPTION BY PASSWORD = 'password';
GO


--Ejecutar luego de mover una BD con CERTIFICADO Y MASTER KEY en otro servidor
OPEN MASTE KEY DECRYPTION BY PASSWORD = 'password'
ALTER MASTER KEY ADD ENCRYPTION BY SERVICE MASTER KEY

