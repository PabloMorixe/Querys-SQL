/*CONSULTA CUANDO DUE EL ULTIMO REINICIO DE UN SERVER*/
select sqlserver_start_time From sys.dm_os_sys_info  



/*tamaño de bases - parametro bases*/
sp_helpdb

/*ver procesos y estados*/
sp_who2

/*mata procedo por ID*/
kill 76


/*Para ver lockeos de tablas y procesos*/
select db_name(dbid),* from master..sysprocesses where spid>50
and waittime>0

/*consulta ejecutada por proceso (spid)*/
dbcc inputbuffer(76)


/*Luego de Backup y Restores debemos correr los comandos:*/

/*Asociamos el Owner*/
sp_changedbowner 'thubandbo'

/*asociar el login con el user*/
sp_change_users_login 'update_one','usrthuban','usrthuban'




/*PARA VER LOS PROCESOS BLOQUEADORES*/

Declare @spid int, @cuantos int
declare @sql varchar(100) 
-- Primero mostramos la información de los bloqueadores.
Select * from master.dbo.sysprocesses where blocked<>0 order by waittime
-- Después vamos a hacer un DBCC InputBuffer para ver que hacen..
Declare cr Cursor for select blocked,count(*) from master.dbo.sysprocesses where blocked<>0 group by blocked
open cr
fetch next from cr into @spid,@cuantos
while @@fetch_status=0
 begin
   -- Muestro la información de sysprocesses, que puede servir para ver quien es
   select 'Rol'='Bloqueador', * from  master.dbo.sysprocesses where spid=@spid
   -- Escribo alguna información para que se pueda perseguir..
   print 'Buffer de ' + cast(@spid as varchar) +' está bloqueando a '+ cast(@cuantos as varchar) +' procesos..'
   set @sql='Dbcc InputBuffer('+ cast(@spid as varchar) +')'
   exec(@sql)
   --Siguiente bloqueador..
   fetch next from cr into @spid,@cuantos
 end
close cr
deallocate cr

SELECT req_spid AS 'spid', 
DB_NAME(rsc_dbid) AS 'Database', 
OBJECT_NAME(rsc_objid) AS 'Name', 
rsc_indid AS 'Index', 
rsc_text AS 'Description', 
ResourceType = CASE WHEN rsc_type = 1 THEN 'NULL Resource'
WHEN rsc_type = 2 THEN 'Database' 
WHEN rsc_type = 3 THEN 'File'
WHEN rsc_type = 4 THEN 'Index' 
WHEN rsc_type = 5 THEN 'Table' 
WHEN rsc_type = 6 THEN 'Page'
WHEN rsc_type = 7 THEN 'Key'
WHEN rsc_type = 8 THEN 'Extent'
WHEN rsc_type = 9 THEN 'RID (Row ID)'
WHEN rsc_type = 10 THEN 'Application'
ELSE 'Unknown'
END, 
Status = CASE WHEN req_status = 1 THEN 'Granted' 
WHEN req_status = 2 THEN 'Converting' 
WHEN req_status = 3 THEN 'Waiting' 
ELSE 'Unknown' 
END, 
OwnerType = 
CASE WHEN req_ownertype = 1 THEN 'Transaction' 
WHEN req_ownertype = 2 THEN 'Cursor' 
WHEN req_ownertype = 3 THEN 'Session' 
WHEN req_ownertype = 4 THEN 'ExSession' 
ELSE 'Unknown' 
END, 
LockRequestMode = 
CASE WHEN req_mode = 0 THEN 'No access ' 
WHEN req_mode = 1 THEN 'Sch-S (Schema stability)' 
WHEN req_mode = 2 THEN 'Sch-M (Schema modification)'
WHEN req_mode = 3 THEN 'S (Shared)' 
WHEN req_mode = 4 THEN 'U (Update)' 
WHEN req_mode = 5 THEN 'X (Exclusive)' 
WHEN req_mode = 6 THEN 'IS (Intent Shared)' 
WHEN req_mode = 7 THEN 'IU (Intent Update)' 
WHEN req_mode = 8 THEN 'IX (Intent Exclusive)' 
WHEN req_mode = 9 THEN 'SIU (Shared Intent Update)'
WHEN req_mode = 10 THEN 'SIX (Shared Intent Exclusive)'
WHEN req_mode = 11 THEN 'UIX (Update Intent Exclusive)' 
WHEN req_mode = 12 THEN 'BU. (Bulk operations)' 
WHEN req_mode = 13 THEN 'RangeS_S' 
WHEN req_mode = 14 THEN 'RangeS_U' 
WHEN req_mode = 15 THEN 'RangeI_N' 
WHEN req_mode = 16 THEN 'RangeI_S' 
WHEN req_mode = 17 THEN 'RangeI_U' 
WHEN req_mode = 18 THEN 'RangeI_X' 
WHEN req_mode = 19 THEN 'RangeX_S' 
WHEN req_mode = 20 THEN 'RangeX_U' 
WHEN req_mode = 21 THEN 'RangeX_X' 
ELSE 'Unknown' 
END 
FROM master.dbo.syslockinfo 
WHERE rsc_type = 5
GO


--sp_who2 

SELECT COUNT(*) Cantidad, "Database", Name, ResourceType, LockRequestMode from 
(SELECT req_spid AS 'spid', 
DB_NAME(rsc_dbid) AS 'Database', 
OBJECT_NAME(rsc_objid) AS 'Name', 
rsc_indid AS 'Index', 
rsc_text AS 'Description', 
ResourceType = CASE WHEN rsc_type = 1 THEN 'NULL Resource'
WHEN rsc_type = 2 THEN 'Database' 
WHEN rsc_type = 3 THEN 'File'
WHEN rsc_type = 4 THEN 'Index' 
WHEN rsc_type = 5 THEN 'Table' 
WHEN rsc_type = 6 THEN 'Page'
WHEN rsc_type = 7 THEN 'Key'
WHEN rsc_type = 8 THEN 'Extent'
WHEN rsc_type = 9 THEN 'RID (Row ID)'
WHEN rsc_type = 10 THEN 'Application'
ELSE 'Unknown'
END, 
Status = CASE WHEN req_status = 1 THEN 'Granted' 
WHEN req_status = 2 THEN 'Converting' 
WHEN req_status = 3 THEN 'Waiting' 
ELSE 'Unknown' 
END, 
OwnerType = 
CASE WHEN req_ownertype = 1 THEN 'Transaction' 
WHEN req_ownertype = 2 THEN 'Cursor' 
WHEN req_ownertype = 3 THEN 'Session' 
WHEN req_ownertype = 4 THEN 'ExSession' 
ELSE 'Unknown' 
END, 
LockRequestMode = 
CASE WHEN req_mode = 0 THEN 'No access ' 
WHEN req_mode = 1 THEN 'Sch-S (Schema stability)' 
WHEN req_mode = 2 THEN 'Sch-M (Schema modification)'
WHEN req_mode = 3 THEN 'S (Shared)' 
WHEN req_mode = 4 THEN 'U (Update)' 
WHEN req_mode = 5 THEN 'X (Exclusive)' 
WHEN req_mode = 6 THEN 'IS (Intent Shared)' 
WHEN req_mode = 7 THEN 'IU (Intent Update)' 
WHEN req_mode = 8 THEN 'IX (Intent Exclusive)' 
WHEN req_mode = 9 THEN 'SIU (Shared Intent Update)'
WHEN req_mode = 10 THEN 'SIX (Shared Intent Exclusive)'
WHEN req_mode = 11 THEN 'UIX (Update Intent Exclusive)' 
WHEN req_mode = 12 THEN 'BU. (Bulk operations)' 
WHEN req_mode = 13 THEN 'RangeS_S' 
WHEN req_mode = 14 THEN 'RangeS_U' 
WHEN req_mode = 15 THEN 'RangeI_N' 
WHEN req_mode = 16 THEN 'RangeI_S' 
WHEN req_mode = 17 THEN 'RangeI_U' 
WHEN req_mode = 18 THEN 'RangeI_X' 
WHEN req_mode = 19 THEN 'RangeX_S' 
WHEN req_mode = 20 THEN 'RangeX_U' 
WHEN req_mode = 21 THEN 'RangeX_X' 
ELSE 'Unknown' 
END 
FROM master.dbo.syslockinfo 
) x
group by "Database", Name, ResourceType, LockRequestMode



/*VER EL ORIGEN DE LOS BLOQUEOS - HEAD - PROCESO QUE ORIGINA QUE EL RESTO SE BLOQUEE*/
SELECT db_name(er.database_id),

er.session_id,

es.original_login_name,

es.client_interface_name,

er.start_time,

er.status,

er.wait_type,

er.wait_resource,

SUBSTRING(st.text, (er.statement_start_offset/2)+1,

((CASE er.statement_end_offset

WHEN -1 THEN DATALENGTH(st.text)

ELSE er.statement_end_offset

END - er.statement_start_offset)/2) + 1) AS statement_text,

er.*

FROM SYS.dm_exec_requests er

join sys.dm_exec_sessions es on (er.session_id = es.session_id)

CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st

where er.session_id in

(SELECT distinct(blocking_session_id) FROM SYS.dm_exec_requests WHERE blocking_session_id > 0)

and blocking_session_id = 0

/*Reporte Bloqueos MARIANO ALVAREZ EN DESARROLLO*/
WITH head_blocker_requests AS
(
---------------------------------------------------------
--   Encuentro los Head Blockers
---------------------------------------------------------
	select 
			er.session_id as head_blocker_session_id,
			'Head' as Header
	FROM 
			SYS.dm_exec_requests er
	where
			-- * * * es un bloqueador * * * 
			er.session_id in
				(
					SELECT distinct(blocking_session_id) 
					FROM SYS.dm_exec_requests 
					WHERE blocking_session_id > 0
				)
			-- * * * no esta bloqueado por otro * * *
	and		er.blocking_session_id = 0   
)
SELECT 
		WT.session_ID as SPID,	-- SPID de la sesion que está esperando
		ES.host_name,			-- Name of the client workstation that is specific to a session. The value is NULL for internal sessions. Is nullable. (POCO CONFIABLE)
		ES.login_name,			-- El de contexto de esta sesion actualmente (recordar EXECUTE AS)
		ES.original_login_name,  -- El que uso para ingresar al SQL 
		ES.program_name,		-- Name of client program that initiated the session. The value is NULL for internal sessions. 
		WT.blocking_session_id AS BlkBy, --ID of the session that is blocking the request. If this column is NULL, the request is not blocked, or the session information of the blocking session is not available (or cannot be identified).
					---2 = The blocking resource is owned by an orphaned distributed transaction.
					---3 = The blocking resource is owned by a deferred recovery transaction.
					---4 = Session ID of the blocking latch owner could not be determined due to internal latch state transitions.
		ESB.login_name			 AS BlockingUserSessionLogin,
		ESB.original_login_name	 AS BlockingSessionConnectionLogin,
		UPPER(ESB.status)		 AS BlockingSessionStatus,
		ESB.program_name		 AS BlockingSessionProgramName,
		ESB.host_name 			AS BlockingHost,		
		hbr.Header,  
		DB_NAME(ER.database_id) DbName, -- Name of the database the request is executing against. 
		WT.wait_duration_ms, --Total wait time for this wait type, in milliseconds. This time is inclusive of signal_wait_time.
		WT.wait_type,
		ES.last_request_start_time, --Timee at which the last request on the session began. This includes the currently executing request. 
		ES.last_request_end_time, --Time of the last completion of a request on the session. 
		-- CPU
		ER.cpu_time as RequestCpu, -- CPU time in milliseconds that is used by the request
		ES.cpu_time AS SessionCpu, --PU time, in milliseconds, that was used by this session. 
		-- Memory
		ES.memory_usage * 0.008 AS MemUsageMb, -- MB of memory used by this session
		-- READS
		ER.logical_reads As RequestLogicalReads, --Number of logical reads that have been performed by this request.
		ER.reads RequestPhisicalReads,	--Number of reads performed by this request.
		ES.logical_reads AS SessionLogicalReads, --Number of logical reads that have been performed on the session.
		ES.reads AS SessionLogicalReads,	--Number of reads performed, by requests in this session, during this session.
		--Writes
		ER.writes As RequestWrites, --Number of writes performed, by requests in this session, during this session. 
		ES.writes AS SessionWrites, --Number of writes performed, by requests in this session, during this session. 
		-- Elapsed
		ES.total_elapsed_time * .001 AS SessionElapsedTimeSeg, --Time, in seconds, since the session was established.
		ES.total_scheduled_time * .001 AS SSessionScheduledTimeSeg,  -- Total time, in seconds, for which the session (requests within) were scheduled for execution.
		-- Rowcount
		ER.row_count As RequestRowcount, --Number of rows returned on the session up to this point
		ES.row_count As SessionRowcount, --Number of rows returned on the session up to this point		
		dm_t.TEXT AS TSQLBloqueado, -- Sentencia SQL
		Sql2.TEXT AS TSQLQueBloquea, -- Sentencia SQL		
		WT.exec_context_id ,		
		--ot.scheduler_id,
		WT.resource_description, --Description of the resource that is being consumed See https://msdn.microsoft.com/en-us/library/ms188743.aspx
		CASE WT.wait_type
			WHEN N'CXPACKET' THEN
				RIGHT (
					WT.resource_description,
					CHARINDEX (N'=', REVERSE (WT.resource_description)) - 1
				)
			ELSE NULL
		END AS [Node ID],
		ES.status as SessionStatus, --Status of the session. Possible values:
					 --Running - Currently running one or more requests
					 --Sleeping - Currently running no requests
					 --Dormant – Session has been reset because of connection pooling and is now in prelogin state.
					 --Preconnect - Session is in the Resource Governor classifier.
		ER.status AS RequestStatus, -- Status of the request
		dm_qp.query_plan, 
		ER.wait_resource, --If the request is currently blocked, this column returns the resource for which the request is currently waiting.
		ER.start_time AS RequestStartTime, -- Timestamp when the request arrived
		ER.command As CmdType, --Identifies the current type of command that is being processed. 
		ER.wait_type, --If the request is currently blocked, this column returns the type of wait.
		ER.last_wait_type, --If this request has previously been blocked, this column returns the type of the last wait.
		ER.open_transaction_count, --Number of transactions that are open for this request.
		case ES.transaction_isolation_level 
			when 0 then 'Unspecified'
			when 1 then 'ReadUncomitted'
			when 2 then 'ReadCommitted'
			when 3 then 'Repeatable'
			when 4 then 'Serializable'
			when 5 then 'Snapshot'
			else
				'ERROR'
		end AS TrnIsolationLevel,
		ER.estimated_completion_time	/ 1000.0 AS estimated_completion_time_Seg,
		ER.total_elapsed_time	/ 1000.0 AS total_elapsed_time_Seg,
		ER.context_info, --CONTEXT_INFO value of the session.
	   ER.prev_error,    --Last error that occurred during the execution of the request. Is not nullable.
	   ER.nest_level     --Current nesting level of code that is executing on the request. I

		 
FROM 
			
			sys.dm_os_waiting_tasks WT											--sys.dm_os_waiting_tasks - Returns information about blocked and blocking processes.			
JOIN 		sys.dm_exec_sessions ES		   ON ES.session_id = WT.session_id			--sys.dm_exec_sessions - Returns information about authenticated sessions on SQL Server.
JOIN 		sys.dm_exec_requests ER		   ON ER.session_id  = WT.session_id			--sys.dm_exec_requests - Returns the detailed information about the requests currently executing on SQL Server.
LEFT OUTER JOIN head_blocker_requests hbr	   ON hbr.head_blocker_session_id = ER.session_id	--
OUTER APPLY	sys.dm_exec_sql_text(  ER.sql_handle) dm_t								--sys.dm_exec_sql_text - Returns the text of T-SQL batch.
OUTER APPLY	sys.dm_exec_query_plan(ER.plan_handle) dm_qp								--sys.dm_exec_query_plan - Returns the showplan for the query in XML format.			
LEFT OUTER JOIN sys.dm_exec_sessions ESB 	  ON ESB.session_id  = WT.blocking_session_id   -- Datos Session Bloqueante
LEFT OUTER JOIN sys.dm_exec_requests ERB		   ON ERB.session_id  = WT.blocking_session_id			
OUTER APPLY	sys.dm_exec_sql_text(ERB.sql_handle) Sql2		
						--sys.dm_exec_sql_text - Returns the text of T-SQL batch.
--OUTER APPLY	sys.dm_exec_query_plan(ERB.plan_handle) dm_qp								--sys.dm_exec_query_plan - Returns the showplan for the query in XML format.			

-- Revisar si vale la pena agregar esta DMV y la condicion adicional del WHERE

-- JOIN	 sys.dm_tran_locks TL		 ON TL.request_session_id = WT.session_id			    --Returns the information about the current locks and the processes blocking them.

WHERE 
		ES.is_user_process = 1

/*
AND	    TL.request_status IN (
		 --'GRANTED' 
		 --'CONVERT' 
		 'WAIT' 
		 --'LOW_PRIORITY_CONVERT'
		 ,'LOW_PRIORITY_WAIT'
		 --,'ABORT_BLOCKERS'.
	   ) 
*/

ORDER BY
--BlkBy, 
    WT.session_ID,
	total_elapsed_time_Seg,
    --WT.session_id,
    WT.exec_context_id;



/*BLOQUEOS IMPLEMENTADOS EN SQL DASHBOARD*/
SELECT 
   DB_Name(procesos.dbid) as Base,
   procesos.loginame as Usuario, 
   bloqueante.session_id as SesionBloqueante,
   bloqueante.client_net_address as HostBloqueante,
   bloqueada.session_id as SesionBloqueada,
   TSQLBloqueante.text as SentenciaBloqueante,    
   TSQLBloqueada.text as SentenciaBloqueada,
   wait_duration_ms/1000 as wait_seconds
FROM 
	    sys.dm_exec_connections AS bloqueante
   JOIN  sys.dm_exec_requests	 AS bloqueada ON bloqueante.session_id = bloqueada.blocking_session_id
   JOIN  sys.dm_os_waiting_tasks AS waitstats	 ON waitstats.session_id = bloqueada.session_id
   JOIN  sys.sysprocesses 		AS procesos			 ON bloqueante.session_id = procesos.spid
   CROSS APPLY sys.dm_exec_sql_text(bloqueante.most_recent_sql_handle) AS TSQLBloqueante
   CROSS APPLY sys.dm_exec_sql_text(bloqueada.sql_handle) AS TSQLBloqueada
WHERE wait_duration_ms/1000 > 120   --ValorToleranciaSegundos
ORDER BY wait_duration_ms desc

