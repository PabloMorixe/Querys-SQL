


===========================
ALTA DE EQUIPO EN TOTMON
===========================
USE [SqlToProd]
GO
INSERT INTO [dbo].[SqlServer]
           ([Servidor]
           ,[IP]
          -- ,[Respuesta]
           ,[Version]
           ,[Ambiente]
           ,[Habilitado]
           ,[DTS_habilitado]
           ,[MON_habilitado]
          -- ,[Img]
          -- ,[Discos_internos]
           ,[Virtual]
           ,[Collation]
           ,[Cluster]
         --  ,[Otros]
           ,[Compartido]
       --    ,[SRM]
        --   ,[SDH_habilitado]
           ,[desde]
           ,[hasta]
           ,[dias]
		 )
     VALUES
           ('SSPR17SMO-01'
           ,'10.241.169.75'
 --          ,<Respuesta, nvarchar(50),>
           ,'Microsoft SQL Server 2017 (RTM-CU12) (KB4464082)'
           ,'PRODUCCION'
           ,'1'
           ,'0'
           ,'1'
           --,<Img, nvarchar(50),>
--           ,<Discos_internos, bit,>
           ,'1'
           ,'SQL_Latin1_General_CP1_CI_AS'
           ,'1'
          -- ,<Otros, nvarchar(2000),>
           ,'0')
           --,<SRM, bit,>
           --,<SDH_habilitado, bit,>
           ,'00:00'
           ,'23:59'
           ,'123456')
GO




===========================
BAJA DE EQUIPO EN TOTMON
===========================
USE [SqlToProd]
GO

UPDATE [dbo].[SqlServer]
   SET [Servidor] = 'TQMCS-01 (discontinuado)'

      ,[Ambiente] = 'DISCO - TESTING'
      ,[Habilitado] = '0'
      ,[MON_habilitado] = '0'
  where servidor like 'TQMCS-01'
GO

===========================
Select  de cada inventario:
===========================

use SqlToProd
go

SELECT *,
[Servidor], 
ambiente, 
SUBSTRING (version, 1, 26) 
FROM [SqlToProd].[dbo].[SqlServer] 
where MON_habilitado = 1 
AND AMBIENTE  IN ('PRODUCCION','testing','TESTING - DMZ','PRODUCCION - DMZ')
ORDER BY 6

use SQLDashboard
go
select * from [dbo].[Servers] where  HABILITADO = 1 
AND AMBIENTE  IN ('PRODUCCION','testing','TESTING - DMZ','PRODUCCION - DMZ')


AND
Ambiente like 'PRODUCCION'
or ambiente like 'TESTING'
ORDER BY 5
===========================




