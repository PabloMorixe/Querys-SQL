SELECT a.name LinkedServer, product Ambiente, provider Provider, data_source DataSource,remote_name Usuario 
FROM sys.Servers a
LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id