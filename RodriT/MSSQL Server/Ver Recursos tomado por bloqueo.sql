SET NOCOUNT ON
declare @dbid int,
@fileid int,
@pageid int,
@spid  int,
@sql   varchar(128)

--set your spid of interest here:
set @spid = 74

select 
@dbid = substring(waitresource, 1, charindex (':', waitresource) - 1),
@fileid = substring(waitresource, 
charindex( ':', waitresource) + 1, 
charindex(':', waitresource, charindex(':', waitresource) + 1) - charindex(':',waitresource) - 1
),
@pageid = substring(waitresource,
charindex(':', waitresource, charindex(':', waitresource, charindex(':', waitresource) + 1)) + 1,
len(waitresource) - (charindex(':', waitresource, charindex(':', waitresource, charindex(':', waitresource) + 1)) + 1)
)
from master..sysprocesses
where spid = @spid
and waitresource like '%:%:%'

set @sql = 'dbcc page (' + convert(varchar,@dbid) + ',' + convert(varchar,@fileid) + ',' + convert(varchar,@pageid) + ') with no_infomsgs, tableresults'

if exists (select 1 from tempdb..sysobjects where xtype = 'U' and name like '#pageinfo%')
drop table #pageinfo
create table #pageinfo (
ParentObject varchar(128),
Object varchar(128),
Field  varchar(128),
Value  varchar(128) )

dbcc traceon (3604) with no_infomsgs
insert into #pageinfo (ParentObject, Object, Field, Value)
exec (@sql)

select object_name(Value) as 'waitresource object name'
from #pageinfo
where Field = 'm_objId'

dbcc traceoff (3604) with no_infomsgs
