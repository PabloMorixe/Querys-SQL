-- This script will set recovery model to Simple on all databases
use [master]
go
 
-- Declare variable for each database name
declare @databaseName nvarchar(128)
 
-- Define the cursor
declare databaseCursor cursor
 
-- Define the cursor dataset
for
select [name] from sys.databases
 
-- Start loop
open databaseCursor
 
-- Get information from the first row
fetch next from databaseCursor into @databaseName
 
-- Loop until there are no more rows
while @@fetch_status = 0
begin
 print 'Setting recovery model to Simple for database [' + @databaseName + ']'
 exec('alter database [' + @databaseName + '] set recovery Simple')
 
-- Get information from next row
 fetch next from databaseCursor into @databaseName
end
 
-- End loop and clean up
close databaseCursor
deallocate databaseCursor
go