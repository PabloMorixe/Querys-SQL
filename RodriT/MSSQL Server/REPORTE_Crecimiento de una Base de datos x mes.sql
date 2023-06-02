declare @v_count as integer, 
@do_count as integer, 
@v_month as varchar(20),
--https://www.sqlskills.com/blogs/erin/trending-database-growth-from-backups/

@sql as varchar(5000)

create table #t_databases
(
Database_Name varchar(200),
January       float(3),
February      float(3),
March  float(3),
April  float(3),
May    float(3),
June   float(3),
July   float(3),
August float(3),
September     float(3),
October       float(3),
November      float(3),
December      float(3),
)
create table #t_databases_gateway
(
Database_Name varchar(200),
Database_Size float(3)
)
set @v_count = (select COUNT(*) from #t_databases ) 
if @v_count = 0 
begin
insert into #t_databases(Database_Name)
select name from sysdatabases 
 end
if @v_count <> 0 
 begin 
--this script captures the size of all databases. You can add a where clause to capture the size of specific database name 
 INSERT #t_databases (Database_Name) 
 SELECT DISTINCT Name FROM sysdatabases cr LEFT JOIN #t_databases c ON cr.Name = c.Database_Name WHERE c.Database_Name IS NULL 
 end 
 --select * from #t_databases 
 --drop table t_databases 
 set @do_count = 1 
 while (@do_count <=12) 
 begin 
 set @v_month = DATENAME(m, str(@do_count) + '/1/2016') --change the year to 2017 or other year as per your requirement 
 truncate table master.dbo.#t_databases_gateway 
 insert into #t_databases_gateway select distinct
(msdb.dbo.backupset.[database_name]),max(msdb.dbo.backupset.[Backup_Size]/1073741824)
from msdb.dbo.backupset inner join #t_databases on msdb.dbo.backupset.[database_name] = #t_databases.Database_Name where
datepart(m,msdb.dbo.backupset.[backup_finish_date]) =  @do_count and datepart(yyyy,msdb.dbo.backupset.[backup_finish_date] ) = 2018 group by msdb.dbo.backupset.[database_name]
set @sql = 'update #t_databases set ' + @v_month + ' = (select Database_Size from #t_databases_gateway where #t_databases.Database_Name = #t_databases_gateway.Database_Name)'
exec (@sql)
set @do_count = @do_count + 1
end
select * from #t_databases
drop table #t_databases_gateway
drop table #t_databases