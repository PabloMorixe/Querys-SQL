/*
***********************************************************************************************************************************	
	CREADOR: Rodrigo Tissera
	FECHA: 01/2022
	FUNCIONALIDAD:	El SP pretende correr localmente en cada uno de los sevidores de base de datos SQL Server ocn la funiconalidad
					de dar de alta en el inventario el servidor con sus datos, o bien actualizarlo si es que existe
***********************************************************************************************************************************
*/

--Relevamento de datos de la instancia de SQL Server
--**************************************************

DECLARE @ServerName VARCHAR(20); 
DECLARE @local_net_address VARCHAR(15);
DECLARE @NombreInstancia VARCHAR(20);
DECLARE @MajorVersion VARCHAR(40);
DECLARE @ProductLevel VARCHAR(20);
DECLARE @Edition VARCHAR(50);
DECLARE @ProductUpdateLevel VARCHAR(20);
DECLARE @ProductVersion VARCHAR(20);
DECLARE @ProductUpdateReference as VARCHAR(15);
DECLARE @Collation as VARCHAR(50);
DECLARE @AlwaysOn as VARCHAR(10);
DECLARE @HostingSite as VARCHAR(2);
DECLARE @HostingType as VARCHAR(2);
DECLARE @Ambiente as VARCHAR(2);

/*
PARAMETROS A COMPLETAR:
HostingSite:
************
	1 - Azure
	2 - AWS
	3 - Onpremise
	4 - IBM

HstingType
**********
	1 - RDS
	2 - Instancia
	3 - VMWare

Ambiente:
************
	1 - Desarrollo
	2 - Testing
	3 - Produccion

*/
SELECT @HostingSite = '1';
SELECT @HostingType = '1';
SELECT @Ambiente = '1';


select @ServerName = cast(SERVERPROPERTY('ServerName') as VARCHAR(20))
select @local_net_address = cast(CONNECTIONPROPERTY('local_net_address') AS VARCHAR(15))
select @NombreInstancia = cast(SERVERPROPERTY('InstanceName') as VARCHAR(20))

if @NombreInstancia is Null --si el nombre de instancia da null ponemos el nombre del servidor
	select @NombreInstancia=cast(SERVERPROPERTY('ServerName') as VARCHAR(20))

select @MajorVersion =     cast (CASE 
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '8%' THEN 'Microsoft SQL Server 2000'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '9%' THEN 'Microsoft SQL Server 2005'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.0%' THEN 'Microsoft SQL Server 2008'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.5%' THEN 'Microsoft SQL Server 2008 R2'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '11%' THEN 'Microsoft SQL Server 2012'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '12%' THEN 'Microsoft SQL Server 2014'
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '13%' THEN 'Microsoft SQL Server 2016'     
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '14%' THEN 'Microsoft SQL Server 2017' 
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '15%' THEN 'Microsoft SQL Server 2019' 
     ELSE 'unknown' 
  END as VARCHAR(40))
select @ProductLevel = cast(SERVERPROPERTY('ProductLevel') as VARCHAR(20))
select @Edition = cast(SERVERPROPERTY('Edition') as VARCHAR(50))
select @ProductUpdateLevel = cast(SERVERPROPERTY('ProductUpdateLevel') as VARCHAR(20))

if @ProductUpdateLevel is null -- Su el product Update level es null le pone C00
	select @ProductUpdateLevel = 'C00'

select @ProductVersion = cast(SERVERPROPERTY('ProductVersion') as VARCHAR(20))
select @ProductUpdateReference = cast(SERVERPROPERTY('ProductUpdateReference') as VARCHAR(20))

if @ProductUpdateReference is null -- Si @ProductUpdatereference es null, le seteo una KB0000000 inicial para revisar
	select @ProductUpdateReference = 'KB0000000'

select @Collation = cast(SERVERPROPERTY('Collation') as VARCHAR(50))
select @AlwaysOn = cast(  CASE 
     WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('IsHadrEnabled')) = 0 THEN 'Disabled'
	 WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('IsHadrEnabled')) = 1 THEN 'Enabled'
	 WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('IsHadrEnabled')) = NULL THEN 'N/A'
	 ELSE 'unknown'
		END as VARCHAR(10))



select @ServerName as ServerName, @local_net_address as local_net_address, @NombreInstancia as NombreInstancia,@HostingSite as HostingSite, @HostingType as HostingType, @MajorVersion as MajorVersion,
	@ProductLevel as ProductLevel,@Ambiente as Ambiente,@Edition as Edition, @ProductUpdateLevel as ProductUpdateLevel, @ProductVersion as ProductVersion,
	@ProductUpdateReference as ProductUpdateReference, @Collation as Collation, @AlwaysOn as AlwaysOn

/*
Llamada a la API con los valores del servidor SQL server
========================================================
*/


DECLARE @URL NVARCHAR(MAX) = 'http://192.168.85.105:8000/InventoryDBA/inventario/';
DECLARE @Object AS INT;
DECLARE @ResponseText AS VARCHAR(8000);
DECLARE @Body AS VARCHAR(8000) =
'{
   "ServerName": "'+@ServerName+'",
   "local_net_address": "'+@local_net_address+'",
   "NombreInstancia": "'+@NombreInstancia+'",
   "hostingSite": '+@HostingSite+',
   "hostingType": '+@HostingType+',
   "MajorVersion": "'+@MajorVersion+'",
   "ProductLevel": "'+@ProductLevel+'",
   "ambiente": '+@Ambiente+',
   "Edition": "'+@Edition+'",
   "ProductUpdateLevel": "'+@ProductUpdateLevel+'",
   "ProductVersion": "'+@ProductVersion+'",
   "ProductUpdateReference": "'+@ProductUpdateReference+'",
   "Collation": "'+@Collation+'",
   "AlwaysOn": "'+@AlwaysOn+'"
}'
EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'post',
                 @URL,
                 'false'
EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
EXEC sp_OAMethod @Object, 'send', null, @body
EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
IF CHARINDEX('false',(SELECT @ResponseText)) > 0
BEGIN
 SELECT @ResponseText As 'Message'
END
ELSE
BEGIN
 SELECT @ResponseText As 'AltaInventario'
END
EXEC sp_OADestroy @Object
