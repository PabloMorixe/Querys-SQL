--LINKEDS NECESARIOS PARA LA APLICACION WINCAMPO BIZNAGA
--------------------------------------------------------
--FEEDLOT_BIZNAGA_2_INTERFASE_BIZNAGA
--FEEDLOT_BIZNAGA_2_FEEDLOT_CENTELLA


--EJEMPLO FEEDLOT_BIZNAGA_2_INTERFASE_BIZNAGA



--1) ALTA DEL NUEVO LINKED SERVER
EXEC master.dbo.sp_addlinkedserver 
@server = N'FEEDLOT_BIZNAGA_2_INTERFASE_BIZNAGA',  --Nombre del Linked Server, con nomenclatura [NOMBREBDORIGEN]_2_[NOMBREBDDESTINO]
@srvproduct=N'SQL',                                --Nombre sólo descriptivo
@provider=N'SQLNCLI',				   --Driver para establecer la conexión
@datasrc=N'ACNT01TST',				   --Nombre del servidor de la BD Remota (Mismo server si ambas BD residen en la misma instancia)
@catalog=N'INTERFASE_BIZNAGA'			   --Nombre de la BD Remota


--2) CONFIGURACION DE OPCION DE SEGURIDAD PARA CONEXIONES SIN LOGIN MAPEADO EXPLICITAMENTE
--Se respeta la misma configuración para todos los linked servers
EXEC master.dbo.sp_addlinkedsrvlogin 
@rmtsrvname=N'FEEDLOT_BIZNAGA_2_INTERFASE_BIZNAGA',
@useself=N'True',
@locallogin=NULL,
@rmtuser=NULL,
@rmtpassword=NULL


--3) CONFIGURACIÓN DEL MAPEO DE LOGINS LOCAL Y REMOTO
EXEC master.dbo.sp_addlinkedsrvlogin 
@rmtsrvname=N'FEEDLOT_BIZNAGA_2_INTERFASE_BIZNAGA',		--Nombre del Linkd Server
@useself=N'False',										
@locallogin=N'LEDESMA_FEEDLOT_CENTELLA',			--Login de la BD de origen
@rmtuser=N'LNK_FEEDLOT_BIZNAGA_2_INTERFASE_BIZNAGA',	        --Login de la BD remota (El conjunto de permisos de este login definen el nivel de accesos del Linked Server hacia la BD Remota
@rmtpassword='password'						--Contraseña del login de la BD remota

GO

--4) Opciones de configuración del Linked Server
--Mantener los mismos valores de configuración salvo requerimientos particulares
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'rpc', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'rpc out', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'BIRCOS_2_LOGISTICA_BIZNAGA', @optname=N'remote proc transaction promotion', @optvalue=N'true'
