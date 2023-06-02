USE [SqlToProd]
GO

UPDATE [dbo].[SqlServer]
   SET [Servidor] = 'SSLSG-01 (discontinuado)'
      ,[Ambiente] = 'DISCO - PRODUCCION'
      ,[MON_habilitado] = 0
      
 WHERE servidor = 'SSLSG-01'
GO
