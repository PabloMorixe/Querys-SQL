
--descripcion de los eventos del extended events

/*
SELECT xp.name AS PackageName,xo.name AS EventName, xo.description --, xo.capabilities_desc
	FROM sys.dm_xe_objects xo
		INNER JOIN sys.dm_xe_packages xp
			ON xo.package_guid = xp.guid
	WHERE xo.name = 'login'
		OR xo.name = 'logout';
*/

--SUCCESSFULL LOGIN

/*
USE master;
GO
-- Create the Event Session
IF EXISTS
	(
		SELECT
				  *
			FROM  sys.server_event_sessions
			WHERE name = 'SVRLoginAudit'
	)
	DROP EVENT SESSION SVRLoginAudit ON SERVER;
GO
EXECUTE xp_create_subdir 'C:DatabaseXE';
GO
CREATE EVENT SESSION SVRLoginAudit
	ON SERVER
	ADD EVENT sqlserver.login
		(SET
			 collect_database_name = (1)
		   , collect_options_text = (1)
		 ACTION
			 (
				 sqlserver.sql_text
			   , sqlserver.nt_username
			   , sqlserver.server_principal_name
			   , sqlserver.client_hostname
			   , package0.collect_system_time
			   , package0.event_sequence
			   , sqlserver.database_id
			   , sqlserver.database_name
			   , sqlserver.username
			   , sqlserver.session_nt_username
			   , sqlserver.client_app_name
			   , sqlserver.session_id
			   , sqlserver.context_info
			   , sqlserver.client_connection_id
			 )
		)
	ADD TARGET package0.event_file
		(SET filename = N'C:DatabaseXESVRLoginAudit.xel', max_file_size = (5120), max_rollover_files = (4))
	WITH
		(
			STARTUP_STATE = OFF
		  , TRACK_CAUSALITY = ON
		);
/* start the session */
ALTER EVENT SESSION SVRLoginAudit ON SERVER STATE = START;
GO
*/

--LOGIN FAILED

/*
USE master;
GO
-- Create the Event Session
IF EXISTS ( SELECT *
				FROM sys.server_event_sessions
				WHERE name = 'Audit_FailedLogon' )
	DROP EVENT SESSION Audit_FailedLogon 
    ON SERVER;
GO
EXECUTE xp_create_subdir 'C:DatabaseXE';
GO
CREATE EVENT SESSION [Audit_FailedLogon] ON SERVER
	ADD EVENT sqlserver.error_reported (
		
		ACTION ( 
				package0.event_sequence
				, sqlserver.client_app_name
				, sqlserver.client_hostname
				, sqlserver.client_pid
				, sqlserver.nt_username
				, sqlserver.server_principal_name
				, sqlserver.session_nt_username
				, sqlserver.transaction_sequence
				, sqlserver.username
				
			)
		WHERE ([severity]=(14) AND [error_number]=(18456) AND [state]>(1)) )
ADD TARGET package0.event_file
			(SET filename = N'C:DatabaseXEAudit_FailedLogon.xel'
						 )
WITH ( MAX_MEMORY = 4096 KB
		,EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS
		, MAX_DISPATCH_LATENCY = 3 SECONDS
		, MAX_EVENT_SIZE = 0 KB
		, MEMORY_PARTITION_MODE = NONE
		, TRACK_CAUSALITY = ON
		, STARTUP_STATE = ON
*/

--LOGOFF AUDIT
/*
USE master;
GO
-- Create the Event Session
IF EXISTS
	(
		SELECT
				  *
			FROM  sys.server_event_sessions
			WHERE name = 'SVRLoginOutAudit'
	)
	DROP EVENT SESSION SVRLoginOutAudit ON SERVER;
GO
EXECUTE xp_create_subdir 'C:DatabaseXE';
GO
CREATE EVENT SESSION SVRLoginOutAudit
	ON SERVER
	ADD EVENT sqlserver.login
		(SET
			 collect_database_name = (1)
		   , collect_options_text = (1)
		 ACTION
			 (
				 sqlserver.sql_text
			   , sqlserver.nt_username
			   , sqlserver.server_principal_name
			   , sqlserver.client_hostname
			   , package0.collect_system_time
			   , package0.event_sequence
			   , sqlserver.database_id
			   , sqlserver.database_name
			   , sqlserver.username
			   , sqlserver.session_nt_username
			   , sqlserver.client_app_name
			   , sqlserver.session_id
			   , sqlserver.context_info
			   , sqlserver.client_connection_id
			 )
		),
		ADD EVENT sqlserver.logout
		(
		 ACTION
			 (
				 sqlserver.sql_text
			   , sqlserver.nt_username
			   , sqlserver.server_principal_name
			   , sqlserver.client_hostname
			   , package0.collect_system_time
			   , package0.event_sequence
			   , sqlserver.database_id
			   , sqlserver.database_name
			   , sqlserver.username
			   , sqlserver.session_nt_username
			   , sqlserver.client_app_name
			   , sqlserver.session_id
			   , sqlserver.context_info
			   , sqlserver.client_connection_id
			 )
		)
	ADD TARGET package0.event_file
		(SET filename = N'C:DatabaseXESVRLoginAudit.xel', max_file_size = (5120), max_rollover_files = (4))
	WITH
		(
			STARTUP_STATE = OFF
		  , TRACK_CAUSALITY = ON
		);
/* start the session */
ALTER EVENT SESSION SVRLoginOutAudit ON SERVER STATE = START;
GO
*/