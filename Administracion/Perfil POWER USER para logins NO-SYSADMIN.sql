use database_name;
-- Grant role permission to select form any table:
EXEC sp_addrolemember 'db_datareader', 'role_name';
-- Grant role permission to show execution plans from SSMS:
grant SHOWPLAN to [role_name];
-- Server level permissions require that context be changed to [master] database.
use master
-- Grant role permission to view system tables and views:
grant VIEW SERVER STATE to [role_name];
-- Grant role permission to view object schemas:
grant VIEW ANY DEFINITION to [role_name];
-- Grant role permission to view execution plans or start traces:
grant ALTER TRACE to [role_name];
-- Grant role permission to read logs:
grant exec on xp_ReadErrorLog to [role_name];
GO
