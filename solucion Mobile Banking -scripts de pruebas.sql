--como manejar tablas sin pk ascendente --https://techcommunity.microsoft.com/t5/sql-server-support-blog/dealing-with-unique-columns-when-using-table-partitioning/ba-p/333995
----------------------------------------------------------------------------
--Dropeo funcion y schema de particionamiento
----------------------------------------------------------------------------
drop table [audit_bff]
drop PARTITION SCHEME PS_audit_bff
drop PARTITION FUNCTION PF_audit_bff

----------------------------------------------------------------------------
--crear funcion de particionado por el tipo de dato del campo a particionar
----------------------------------------------------------------------------
CREATE PARTITION FUNCTION PF_audit_bff (bigint) 
AS RANGE RIGHT FOR VALUES 
() 
GO
----------------------------------------------------------------------------
--crear schema de particiones
----------------------------------------------------------------------------
CREATE PARTITION SCHEME PS_audit_bff
AS PARTITION PF_audit_bff
ALL TO ([PRIMARY])
GO 
-----------------------------------------------------------------------------
--creacion de tabla a particionar
----------------------------------------------------------------------------
--drop table [audit_bff]
--TRUNCATE TAble audit_bff
create TABLE [dbo].[audit_bff](
	[id_persona] [varchar](30) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[x_usuario] [varchar](50) NULL,
	[x_canal] [varchar](50) NULL,
	[http_metodo] [varchar](30) NULL,
	[uri] [varchar](255) NULL,
	[id_sesion] [varchar](30) NULL,
	[estado] [varchar](20) NULL,
	[id_dispositivo] [int] NULL,
	[observaciones] [varchar](max) NULL,
	[error_origen] [varchar](100) NULL,
	[error_codigo] [varchar](100) NULL,
	[error_detalle] [varchar](max) NULL,
	[ip_local] [varchar](25) NULL,
	[ip_remota] [varchar](25) NULL,
	[ip] [varchar](25) NULL,
	[x_real_ip] [varchar](25) NULL,
	[x_original_forwarded_for] [varchar](255) NULL,
	[ID] bigint IDENTITY(1,1) NOT NULL,
	[respuesta] [varchar](max) NULL,
	[version_app] [varchar](10) NULL,
	[sistema_operativo] [varchar](50) NULL,
	[duracion] [varchar](10) NULL,
	[duracion_milisegundos] [bigint] NULL,
	index cix_audit_bff clustered columnstore 
) ON PS_audit_bff (id)
GO


--crear PK original. sobre campo ID NONCLUSTERED
 ALTER TABLE [dbo].[audit_bff] ADD PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,  IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, 
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON PS_audit_bff(id)
GO


ALTER TABLE [dbo].[audit_bff]  WITH CHECK ADD  CONSTRAINT [FK_audit_bff_Dispositivo_tp] FOREIGN KEY([id_dispositivo])
REFERENCES [dbo].[dispositivo] ([id])
GO

ALTER TABLE [dbo].[audit_bff] CHECK CONSTRAINT [FK_audit_bff_Dispositivo_tp]
GO




exec Split_audit_bff 100
go 5



--set nocount on 
--USE [bff-mobile-individuos]
--GO
--INSERT [dbo].[audit_bff] ([id_persona], [fecha], [x_usuario], [x_canal], [http_metodo], [uri], [id_sesion], 
--[estado], [id_dispositivo], [observaciones], [error_origen], [error_codigo], [error_detalle], [ip_local], [ip_remota],
--[ip], [x_real_ip], [x_original_forwarded_for],  [respuesta], [version_app], [sistema_operativo], [duracion],
--[duracion_milisegundos]) 
--VALUES (N'123', CAST(N'2022-10-14T00:00:00.000' AS DateTime), N'asasasas', N'asd', N'Metodo', N'uri', N'session', N'estado',
--1, N'observ', N'err orig', N'error cod', N'error_detalle', N'ip_local, ', N'<ip_remota', N'<ip, ', N'<x_real_ip, (25),>',
--N'<x_original_forwarded_for', N'<respuesta>', N'version>', N'<sistema_operativo', N'duracion', 2345)
--GO 120


--set nocount on 
--USE [bff-mobile-individuos]
--GO
--INSERT [dbo].[audit_bff] ([id_persona], [fecha], [x_usuario], [x_canal], [http_metodo], [uri], [id_sesion], 
--[estado], [id_dispositivo], [observaciones], [error_origen], [error_codigo], [error_detalle], [ip_local], [ip_remota],
--[ip], [x_real_ip], [x_original_forwarded_for],  [respuesta], [version_app], [sistema_operativo], [duracion],
--[duracion_milisegundos]) 
--VALUES (N'123', CAST(N'2022-10-15T00:00:00.000' AS DateTime), N'asasasas', N'asd', N'Metodo', N'uri', N'session', N'estado',
--1, N'observ', N'err orig', N'error cod', N'error_detalle', N'ip_local, ', N'<ip_remota', N'<ip, ', N'<x_real_ip, (25),>',
--N'<x_original_forwarded_for', N'<respuesta>', N'version>', N'<sistema_operativo', N'duracion', 2345)
--GO 100



--set nocount on 
--USE [bff-mobile-individuos]
--GO
--INSERT [dbo].[audit_bff] ([id_persona], [fecha], [x_usuario], [x_canal], [http_metodo], [uri], [id_sesion], 
--[estado], [id_dispositivo], [observaciones], [error_origen], [error_codigo], [error_detalle], [ip_local], [ip_remota],
--[ip], [x_real_ip], [x_original_forwarded_for],  [respuesta], [version_app], [sistema_operativo], [duracion],
--[duracion_milisegundos]) 
--VALUES (N'123', CAST(N'2022-10-16T00:00:00.000' AS DateTime), N'asasasas', N'asd', N'Metodo', N'uri', N'session', N'estado',
--1, N'observ', N'err orig', N'error cod', N'error_detalle', N'ip_local, ', N'<ip_remota', N'<ip, ', N'<x_real_ip, (25),>',
--N'<x_original_forwarded_for', N'<respuesta>', N'version>', N'<sistema_operativo', N'duracion', 2345)
--GO 100


set nocount on 
USE [bff-mobile-individuos]
GO
INSERT [dbo].[audit_bff] ([id_persona], [fecha], [x_usuario], [x_canal], [http_metodo], [uri], [id_sesion], 
[estado], [id_dispositivo], [observaciones], [error_origen], [error_codigo], [error_detalle], [ip_local], [ip_remota],
[ip], [x_real_ip], [x_original_forwarded_for],  [respuesta], [version_app], [sistema_operativo], [duracion],
[duracion_milisegundos]) 
VALUES (N'123', CAST(N'2022-11-04T00:00:00.000' AS DateTime), N'asasasas', N'asd', N'Metodo', N'uri', N'session', N'estado',
1, N'observ', N'err orig', N'error cod', N'error_detalle', N'ip_local, ', N'<ip_remota', N'<ip, ', N'<x_real_ip, (25),>',
N'<x_original_forwarded_for', N'<respuesta>', N'version>', N'<sistema_operativo', N'duracion', 2345)
GO 200


set nocount on 
USE [bff-mobile-individuos]
GO
INSERT [dbo].[audit_bff] ([id_persona], [fecha], [x_usuario], [x_canal], [http_metodo], [uri], [id_sesion], 
[estado], [id_dispositivo], [observaciones], [error_origen], [error_codigo], [error_detalle], [ip_local], [ip_remota],
[ip], [x_real_ip], [x_original_forwarded_for],  [respuesta], [version_app], [sistema_operativo], [duracion],
[duracion_milisegundos]) 
VALUES (N'123', CAST(N'2022-10-18T00:00:00.000' AS DateTime), N'asasasas', N'asd', N'Metodo', N'uri', N'session', N'estado',
1, N'observ', N'err orig', N'error cod', N'error_detalle', N'ip_local, ', N'<ip_remota', N'<ip, ', N'<x_real_ip, (25),>',
N'<x_original_forwarded_for', N'<respuesta>', N'version>', N'<sistema_operativo', N'duracion', 2345)
GO 100

set nocount on 
USE [bff-mobile-individuos]
GO
INSERT [dbo].[audit_bff] ([id_persona], [fecha], [x_usuario], [x_canal], [http_metodo], [uri], [id_sesion], 
[estado], [id_dispositivo], [observaciones], [error_origen], [error_codigo], [error_detalle], [ip_local], [ip_remota],
[ip], [x_real_ip], [x_original_forwarded_for],  [respuesta], [version_app], [sistema_operativo], [duracion],
[duracion_milisegundos]) 
VALUES (N'123', CAST(N'2022-10-19T00:00:00.000' AS DateTime), N'asasasas', N'asd', N'Metodo', N'uri', N'session', N'estado',
1, N'observ', N'err orig', N'error cod', N'error_detalle', N'ip_local, ', N'<ip_remota', N'<ip, ', N'<x_real_ip, (25),>',
N'<x_original_forwarded_for', N'<respuesta>', N'version>', N'<sistema_operativo', N'duracion', 2345)
GO 100


set nocount on 
USE [bff-mobile-individuos]
GO
INSERT [dbo].[audit_bff] ([id_persona], [fecha], [x_usuario], [x_canal], [http_metodo], [uri], [id_sesion], 
[estado], [id_dispositivo], [observaciones], [error_origen], [error_codigo], [error_detalle], [ip_local], [ip_remota],
[ip], [x_real_ip], [x_original_forwarded_for],  [respuesta], [version_app], [sistema_operativo], [duracion],
[duracion_milisegundos]) 
VALUES (N'123', CAST(N'2022-10-20T00:00:00.000' AS DateTime), N'asasasas', N'asd', N'Metodo', N'uri', N'session', N'estado',
1, N'observ', N'err orig', N'error cod', N'error_detalle', N'ip_local, ', N'<ip_remota', N'<ip, ', N'<x_real_ip, (25),>',
N'<x_original_forwarded_for', N'<respuesta>', N'version>', N'<sistema_operativo', N'duracion', 2345)
GO 100


exec Split_audit_bff