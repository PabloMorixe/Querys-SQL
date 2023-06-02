SELECT s.session_id, s.login_name, DB_NAME(s.database_id) as database_name, 
    s.host_name, s.program_name, c.client_net_address, client_tcp_port,
    c.net_transport, c.auth_scheme, s.login_time
FROM sys.dm_exec_sessions s
INNER JOIN sys.dm_exec_connections c 
ON s.session_id = c.session_id
WHERE s.login_name = 'usrsoa'
ORDER BY s.session_id
