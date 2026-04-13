

------ A- Rename BETransactionLogs


EXEC sp_rename 'dbo.BETransactionLogs', 'BETransactionLogs_old';
EXEC sp_rename 'PK_BETransactionLogs', 'PK_BETransactionLogs_old';



------ B- RENAME de Indices ---------------------


EXEC sp_rename N'BETransactionLogs_old.IXFK_BETransactionLogs_BETransactions', N'IXFK_BETransactionLogs_BETransactionsOLD', N'INDEX';   
GO

EXEC sp_rename N'BETransactionLogs_old.IXFK_BETransactionLogs_BETransactionsStatus', N'IXFK_BETransactionLogs_BETransactionsStatusOLD', N'INDEX';   
GO

EXEC sp_rename N'BETransactionLogs_old.IXFK_BETransactionLogs_Users', N'IXFK_BETransactionLogs_UsersOLD', N'INDEX';   
GO

EXEC sp_rename N'BETransactionLogs_old.IXQ_BETransactionLogs_RequestDate', N'IXQ_BETransactionLogs_RequestDateOLD', N'INDEX';   
GO




----------------------------------------------------------------------------
-- 1- Crear funcion de particionado por el tipo de dato del campo a particionar
----------------------------------------------------------------------------
CREATE PARTITION FUNCTION PF_BETransactionLogs (bigint) 
AS RANGE RIGHT FOR VALUES 
() 
GO
----------------------------------------------------------------------------
-- 2- Crear schema de particiones
----------------------------------------------------------------------------
CREATE PARTITION SCHEME PS_BETransactionLogs
AS PARTITION PF_BETransactionLogs
--ALL TO ([AuditFilegroup]) --PRIMARY
ALL TO ([PRIMARY])
GO 


-----------------------------------------------------------------------------
-- 3- Creacion de tabla a particionar -- T1, original.
----------------------------------------------------------------------------

CREATE TABLE [dbo].[BETransactionLogs](
	[BETransactionLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[ResponseDate] [datetime] NULL,
	[UserId] [int] NOT NULL,
	[BETransactionStatusId] [int] NOT NULL,
	[MessegeRequest] [xml] NOT NULL,
	[MessageResponse] [xml] NULL,
	[BETransactionId] [int] NOT NULL,
 CONSTRAINT [PK_BETransactionLogs] PRIMARY KEY  NONCLUSTERED 
(
	[BETransactionLogId] ASC
)
) ON [PS_BETransactionLogs] (BETransactionLogId)
GO


---use [AR_Supervielle_Individuos_ICHB]
/*
CREATE NONCLUSTERED INDEX IXFK_BETransactionLogs_BETransactions
ON dbo.BETransactionLogs (BETransactionLogId)
WITH (DROP_EXISTING = ON)
ON [PS_BETransactionLogs] (BETransactionLogId);
*/


CREATE NONCLUSTERED INDEX [IXFK_BETransactionLogs_BETransactions] ON [dbo].[BETransactionLogs]
(
	[BETransactionId] ASC
)ON [PS_BETransactionLogs] (BETransactionLogId)
GO




CREATE NONCLUSTERED INDEX [IXFK_BETransactionLogs_BETransactionsStatus] ON [dbo].[BETransactionLogs]
(
	[BETransactionStatusId] ASC
)ON [PS_BETransactionLogs] (BETransactionLogId)
GO

CREATE NONCLUSTERED INDEX [IXFK_BETransactionLogs_Users] ON [dbo].[BETransactionLogs]
(
	[UserId] ASC
)ON [PS_BETransactionLogs] (BETransactionLogId)
GO

CREATE NONCLUSTERED INDEX [IXQ_BETransactionLogs_RequestDate] ON [dbo].[BETransactionLogs]
(
	[RequestDate] ASC
)
INCLUDE([BETransactionId]) 
ON [PS_BETransactionLogs] (BETransactionLogId)
GO

ALTER TABLE [dbo].[BETransactionLogs]  WITH CHECK ADD  CONSTRAINT [FK_BETransactionLogs_BETransactions] FOREIGN KEY([BETransactionId])
REFERENCES [dbo].[BETransactions] ([BETransactionId])
GO

ALTER TABLE [dbo].[BETransactionLogs] CHECK CONSTRAINT [FK_BETransactionLogs_BETransactions]
GO

ALTER TABLE [dbo].[BETransactionLogs]  WITH CHECK ADD  CONSTRAINT [FK_BETransactionLogs_BETransactionsStatus] FOREIGN KEY([BETransactionStatusId])
REFERENCES [dbo].[BETransactionsStatus] ([BETransactionsStatusId])
GO

ALTER TABLE [dbo].[BETransactionLogs] CHECK CONSTRAINT [FK_BETransactionLogs_BETransactionsStatus]
GO

ALTER TABLE [dbo].[BETransactionLogs]  WITH CHECK ADD  CONSTRAINT [FK_BETransactionLogs_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[BETransactionLogs] CHECK CONSTRAINT [FK_BETransactionLogs_Users]
GO




----------------------------------------------------------------------------------------------------------
-- Crea particionamiento inicial
--------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------
----------------------------------------------------------------------------
------------------------------------------------------------
-- 4- --Look at how this is mapped out now
------------------------------------------------------------
 --  VISTA -- select * from FileGroupDetail
   
CREATE VIEW FileGroupDetail
AS
SELECT  pf.name AS pf_name ,
        ps.name AS partition_scheme_name ,
        p.partition_number ,
        ds.name AS partition_filegroup ,	
        pf.type_desc AS pf_type_desc ,
        pf.fanout AS pf_fanout ,
        pf.boundary_value_on_right ,
        OBJECT_NAME(si.object_id) AS object_name ,
        rv.value AS range_value ,
        SUM(CASE WHEN si.index_id IN ( 1, 0 ) THEN p.rows
                    ELSE 0
            END) AS num_rows ,
        SUM(dbps.reserved_page_count) * 8 / 1024. AS reserved_mb_all_indexes ,
        SUM(CASE ISNULL(si.index_id, 0)
                WHEN 0 THEN 0
                ELSE 1
            END) AS num_indexes
FROM    sys.destination_data_spaces AS dds
        JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
        JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
        JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
        LEFT JOIN sys.partition_range_values AS rv ON pf.function_id = rv.function_id
                                                        AND dds.destination_id = CASE pf.boundary_value_on_right
                                                                                    WHEN 0 THEN rv.boundary_id
                                                                                    ELSE rv.boundary_id + 1
                                                                                END
        LEFT JOIN sys.indexes AS si ON dds.partition_scheme_id = si.data_space_id
        LEFT JOIN sys.partitions AS p ON si.object_id = p.object_id
                                            AND si.index_id = p.index_id
                                            AND dds.destination_id = p.partition_number
        LEFT JOIN sys.dm_db_partition_stats AS dbps ON p.object_id = dbps.object_id
                                                        AND p.partition_id = dbps.partition_id
GROUP BY ds.name ,
        p.partition_number ,
        pf.name ,
        pf.type_desc ,
        pf.fanout ,
        pf.boundary_value_on_right ,
        ps.name ,
        si.object_id ,
        rv.value;
GO

-- select * from sys.partition_range_values


------------------------------------------------------------------------------------------------------
-- 5- Agregar particion de 5kk de registros.
------------------------------------------------------------------------------------------------------
--drop procedure Split_BETransactionLogs
--parametrizar eL TAMAÑO DE LAS PARTICIONES 
--declare @cantregpart int 
--set @cantregpart = 100 

CREATE procedure Split_BETransactionLogs @cantregpart int
AS

BEGIN
	Declare @CurrentSplitValue bigint; 
	set @CurrentSplitValue = (SELECT cast(coalesce(max(range_value),0) as bigint) FROM FileGroupDetail where pf_name = 'PF_BETransactionLogs' ) + @cantregpart
	ALTER PARTITION SCHEME   PS_BETransactionLogs   NEXT USED [primary];
	ALTER PARTITION FUNCTION PF_BETransactionLogs() SPLIT RANGE(@CurrentSplitValue);
END
GO


/*
----------------------------------------------------------------------------
----------------------------------------------------------------------------
--Look at how this is mapped out now
SELECT *
FROM FileGroupDetail
where pf_name = 'PF_BETransactionLogs';
GO
----------------------------------------------------------------------------
----------------------------------------------------------------------------
SELECT name,type_desc, fanout, boundary_value_on_right, create_date 
FROM sys.partition_functions;
GO


*/
----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-- 6- Crear tabla de switch partition            ---- T2, tabla intermedia de switch. Identica a la original T1, pero con CCI
--    Crear tabla switch con mismo CCI e indices. 
-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[BETransactionLogs_switch](
	[BETransactionLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[ResponseDate] [datetime] NULL,
	[UserId] [int] NOT NULL,
	[BETransactionStatusId] [int] NOT NULL,
	[MessegeRequest] [xml] NOT NULL,
	[MessageResponse] [xml] NULL,
	[BETransactionId] [int] NOT NULL,
 CONSTRAINT [PK_BETransactionLogs_switch] PRIMARY KEY NONCLUSTERED 
(
	[BETransactionLogId] ASC
)
) ON [PRIMARY] 
GO



-----------------------
-- 7- JOB generacion de particiones diariamente abajo esta el SP:_ execute [dbo].[generapart] 50, 500
-----------------------
--select * from FileGroupDetail
--exec generapart 50
--go
	
-----------------------------------------------------------------------------------------------------
	 
--	 execute [dbo].[generapart] 10, 50
	 
   Create procedure generapart @cantPart int ,@cantregpart int   
   AS  
  
   BEGIN  
  
    declare @Maxid bigint  
    declare @crearpart int    
  
    select @Maxid  = max(BETransactionLogId) from [BETransactionLogs]   
    SELECT @crearpart =  @cantPart-count(*)  
    FROM FileGroupDetail   
    where range_value > @Maxid  
    print @crearpart  
  
    while (@crearpart > 0)  
     begin  
      PRINT @crearpart  
      set @crearpart -=1  
      exec Split_BETransactionLogs @cantregpart                               
     end  
   end
	 
	 
-----  JOB de switcheo--- 

-- execute [dbo].[switchoff] 35

Create procedure [dbo].[switchoff] @daystoretain int
			as
			begin 
			DECLARE @partNumbmax INT 
			declare @Maxid bigint
			select  @Maxid =  max(BETransactionLogId) from [BETransactionLogs] where RequestDate < getdate() - @daystoretain 
					print @maxid
					--SELECT * FROM FileGroupDetail
			select @partNumbmax = max(partition_number) from FileGroupDetail where range_value < (@Maxid) and pf_name = 'PF_BETransactionLogs'   
			--select * from audit_bff
			print @partNumbmax
			SELECT * FROM FileGroupDetail

			declare @mergeRange bigint 

			WHILE ( @partNumbmax > 0)
			BEGIN
				--print 'begin'
				--print @partNumbmax
				-- limpio switch table
				truncate table BETransactionLogs_switch
				--switcheo
				ALTER TABLE BETransactionLogs SWITCH PARTITION @partNumbmax TO BETransactionLogs_switch
				--mergeo

				select top 1 @mergeRange = cast(range_value as bigint) FROM FileGroupDetail where pf_name = 'PF_BETransactionLogs' and partition_number = @partNumbmax
				--print @mergeRange
				ALTER PARTITION FUNCTION PF_BETransactionLogs() MERGE RANGE (@mergeRange) 

				SET @partNumbmax=(select max(partition_number) from FileGroupDetail where range_value < @Maxid  and pf_name = 'PF_BETransactionLogs')
	    

			END
			end
GO



-------------------------------------------------------------------------------------
-- 8- Creacion de tabla Final con campo nvarchar(max), particionada y CCI.  -- T3 Final
-------------------------------------------------------------------------------------
--drop table [BETransactionLogs_CCI]
--TRUNCATE TAble BETransactionLogs_CCI

CREATE TABLE [dbo].[BETransactionLogs_CCI](
	[BETransactionLogId] [bigint]  NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[ResponseDate] [datetime] NULL,
	[UserId] [int] NOT NULL,
	[BETransactionStatusId] [int] NOT NULL,
	[MessegeRequest]  nvarchar(max) NOT NULL,
	[MessageResponse]  nvarchar(max) NULL,
	[BETransactionId] [int] NOT NULL,

) ON [PS_BETransactionLogs] (BETransactionLogId)
GO



CREATE CLUSTERED COLUMNSTORE INDEX [cix_BETransactionLogs_CCI] ON [dbo].[BETransactionLogs_CCI] 
WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [PS_BETransactionLogs](BETransactionLogId)
GO

