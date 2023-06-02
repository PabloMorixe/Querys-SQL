SELECT a.account_id, a.name, a.description, a.email_address, a.display_name, a.replyto_address, s.servertype, s.servername, s.port, s.username, s.use_default_credentials, s.enable_ssl
FROM msdb.dbo.sysmail_account a, msdb.dbo.sysmail_server s
WHERE a.account_id = s.account_id
