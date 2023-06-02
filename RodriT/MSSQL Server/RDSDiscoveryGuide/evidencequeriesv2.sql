declare @isEEFeature char(1)
declare @islinkedserver char(1)
declare @issysadmin char(1)
declare @isextendedproc char(1)
declare @isFilestream char(1)
declare @isResouceGov char(1)
declare @issqlTLShipping char(1)
declare @issqlServiceBroker char(1)
declare @issqlTranRepl char(1)
declare @DBCount char(1)
declare @usedSpaceGB decimal(6,2)
declare @istsqlendpoint char(1)
declare @ispolybase char(1)
--declare @ismemoptimized char(1)
declare @isfiletable Char(1)
declare @isbufferpoolextension char(1)
Declare @isstretchDB char(1)
declare @istrustworthy char(1)
declare @Isservertrigger char(1)
declare @isRMachineLearning Char(1)
declare @ISPolicyBased char(1)
declare @ISDQS char(1)
declare @isCLREnabled char(1)



select  @islinkedserver= case when count(*)=0 then 'N' else 'Y' end   from sys.servers where is_linked=1 and product<>'SQL Server'
--if  @@rowcount>0 
 --set @islinedserver='Y'
--select @islinedserver 
SELECT   @issysadmin=case when count(*)=0 then 'N' else 'Y' end FROM sys.databases d
                 INNER JOIN sys.server_principals sp ON d.owner_sid = sp.sid
                    WHERE sp.name  in (select  name
                        FROM     master.sys.server_principals
                            WHERE    IS_SRVROLEMEMBER ('sysadmin',name) = 1 and type_desc='SQL_LOGIN') and database_id>4

IF OBJECT_ID('tempdb.dbo.##enterprise_features') IS NOT NULL
                                   DROP TABLE ##enterprise_features
                                 CREATE TABLE ##enterprise_features
                                       (dbname       SYSNAME,feature_name VARCHAR(100),feature_id   INT )
                                        EXEC sp_msforeachdb N'USE [?] 
                                   IF (SELECT COUNT(*) FROM sys.dm_db_persisted_sku_features) >0 
                                           BEGIN 
                                               INSERT INTO ##enterprise_features 
                                                   SELECT dbname=DB_NAME(),feature_name,feature_id   FROM sys.dm_db_persisted_sku_features 
                                            END '
                                   SELECT  @isEEFeature=CASE WHEN COUNT(*)=0 THEN'n' ELSE 'Y' EnD  FROM   ##enterprise_features

--extended Procedure
SELECT @isextendedproc= case when count(*)=0 then 'N' else 'Y' end FROM master.sys.extended_procedures
-- Filestream
select  @isFilestream= case when value_in_use=0 then 'N'
          else  'Y' end  from sys.configurations where name like 'Filestream%'

--Resource Governor
select @isResouceGov= case when classifier_function_id=0 then 'N' else 'Y'end from sys.dm_resource_governor_configuration
--Log Shipping 
select @issqlTLShipping = case when count(*)=0 then 'N' else 'Y' end  from msdb.dbo.log_shipping_primary_databases
--Service Broker 
select @issqlServiceBroker= case when count(*)=0 then 'N' else 'Y' end  from sys.service_broker_endpoints
--Transaction replication 
select  @issqlTranRepl =case when sum (  case when is_published=1 or is_subscribed=1 or is_merge_published=1 or is_distributor =1  then 1 
else 0 end )=0 then 'N' else 'Y' end  from sys.databases where database_id>4
select @dbcount= case when count(*) > 100 then 'Y' else 'N' end  from sys.databases where database_id>4
--extendedProc
DECLARE @xplist AS TABLE
(
xp_name sysname,
source_dll nvarchar(255)
)
INSERT INTO @xplist
EXEC sp_helpextendedproc
--DB Size
SELECT @UsedSpaceGB=CONVERT(DECIMAL(10,2),(SUM(size * 8.00) / 1024.00 / 1024.00))
FROM master.sys.master_files
--endpoints
SELECT 
    @istsqlendpoint=case when count(*)= 0 then 'N' else 'Y' end 
                    FROM  sys.routes 
                    WHERE address != 'LOCAL'
--polybase
SELECT 
    @ispolybase=case when count(*)= 0 then 'N' else 'Y' end 
                    FROM           sys.external_data_sources
----memory optimized
-- SELECT 
--  @ismemoptimized=case when count(*)= 0 then 'N' else 'Y' end 
--                    FROM           sys.tables t                        
--                    WHERE        is_memory_optimized = 1
 --filetables
 SELECT 
   @isfiletable=case when count(*)= 0 then 'N' else 'Y' end 
                   FROM           sys.filetables ft
                   JOIN   sys.objects o on ft.object_id = o.object_id
                   WHERE        is_enabled = 1
-- buffer pool extension
SELECT 
@isbufferpoolextension=case when count(*)= 0 then 'N' else 'Y' end            
                   FROM           sys.dm_os_buffer_pool_extension_configuration
				   WHERE	[state] != 0

select @isstretchDB =case when value =0 then 'N' else 'Y' end from sys.configurations where name like 'remote data archive'
--trustworthy
SELECT @istrustworthy= CASE WHEN COUNT(*)=0 THEN 'N' else 'Y' end FROM sys.databases WHERE DATABASE_ID>4 AND is_trustworthy_on >1
--server Trigger
select @Isservertrigger=case when count(*)=0 then 'N' else 'Y' end  from sys.server_triggers
--R and Machine Learning 
select @isRMachineLearning =case when value =0 then 'N' else 'Y' end  from sys.configurations where name like 'external scripts enabled'
--Data Quality Service
select @ISDQS= case when  count(0)=0  then 'N' else 'Y' end from sys.databases where name like 'DQS%'
--policy Based management
select @ISPolicyBased = case when  count(0)=0  then 'N' else 'Y' end from msdb.dbo.syspolicy_policy_execution_history_details
--TransactionLog shipping
select @issqlTLShipping = case when count(*)=0 then 'N' else 'Y' end  from msdb.dbo.log_shipping_primary_databases

SELECT @isextendedProc = case when count(*)=0 then 'N' else 'Y' end  FROM @xplist X JOIN sys.all_objects O ON X.xp_name = O.name WHERE O.is_ms_shipped = 0 

select  @isCLREnabled= case when value_in_use=0 then 'N'
          else  'Y' end  from sys.configurations where name like 'clr enabled%'



select @isEEFeature as isEEFeature,@isextendedproc as isextendedproc,@isFilestream AS isFilestream,@islinkedserver AS islinkedserver,@isResouceGov AS isResouceGov,
		@issqlServiceBroker AS issqlServiceBroker ,@issqlTLShipping AS issqlTLShipping,@issqlTranRepl AS issqlTranRepl ,@issysadmin AS issysadmin,@dbcount as dbcount, @istsqlendpoint as istsqlendpoint,@ispolybase as ispolybase,
@isfiletable as isfiletable,@isbufferpoolextension as isbufferpoolextension,@isstretchDB as isstretchDB,@istrustworthy as istrustworthy,@Isservertrigger as Isservertrigger,@isRMachineLearning as isRMachineLearning,
 @ISDQS as ISDQS, @ISPolicyBased  as ISPolicyBased ,  @isCLREnabled as isCLREnabled

  if( @isextendedproc='Y' or
	@isFilestream='Y' or
	@islinkedserver ='Y' or
	@isResouceGov ='Y' or
	@issqlServiceBroker ='Y' or
	@issqlTLShipping ='Y' or
	@issqlTranRepl ='Y' or
	@issysadmin ='Y' or
	@dbcount ='Y' or
	@istsqlendpoint ='Y' or
	@ispolybase='Y' or
   	@isfiletable ='Y' or
	@isbufferpoolextension ='Y' or
	@isstretchDB ='Y' or
	@istrustworthy ='Y' or
	@Isservertrigger ='Y' or
	@isRMachineLearning ='Y' or
    @ISDQS='Y' or
	@ISPolicyBased  ='Y' or
	@isCLREnabled='Y' )
	select  'Server is not compatible with RDS'

