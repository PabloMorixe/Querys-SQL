SELECT a.[name] AS 'Logical Name',
    , a.[server_name] AS 'Server Name'
    , b.[name] AS 'Group Name' 
    , a.[description] 
FROM [msdb].[dbo].[sysmanagement_shared_registered_servers] a 
JOIN [msdb].[dbo].[sysmanagement_shared_server_groups] b 
    ON a.[server_group_id] = b.[server_group_id] 
ORDER BY b.[name] ASC, a.[server_name] ASC



SELECT [name] 
    , [value] 
FROM sys.extended_properties 
WHERE [class] = 0   -- database




EXEC sp_addextendedproperty @name = N'Description', @value = N'Test database' 
EXEC sp_addextendedproperty @name = N'Stakeholders', @value = N'John Doe, Jane Doe'




USE SOPORTECA
GO
SELECT * FROM SYS.extended_properties
WHERE class = 0



SELECT * FROM msdb.dbo.sysmanagement_shared_registered_servers