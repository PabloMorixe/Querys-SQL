/*Provisto por Mariano Alvarez para analizar las posibles ejecuciones de una query, consumos de CPU, etc.*/

use master
go

select top 1000 
    q.total_worker_time,
    q.total_logical_reads,
    q.execution_count,
    q.total_worker_time/q.execution_count as avg_worktime, 
    q.plan_handle,
    p.query_plan,
    cast(p.query_plan as xml) as xmlplan
from 
                     sys.dm_exec_query_stats as q
outer apply  sys.dm_exec_text_query_plan(q.plan_handle,0,-1) as p
WHERE q.execution_count > 10
order by 
    --execution_count desc
    q.total_logical_reads desc
    --q.total_worker_time/q.execution_count desc



------------------------------

use master
go

with q1 as
(
select top 1000 
    q.total_worker_time,
    q.total_logical_reads,
    q.execution_count,
    q.total_worker_time/q.execution_count as avg_worktime, 
    q.plan_handle,
    p.query_plan,
    cast(p.query_plan as xml) as xmlplan
from 
                     sys.dm_exec_query_stats as q
outer apply  sys.dm_exec_text_query_plan(q.plan_handle,0,-1) as p
WHERE q.execution_count > 10
order by 
    --execution_count desc
    q.total_logical_reads desc
    --q.total_worker_time/q.execution_count desc
)
select * from q1 

where query_plan like '%tpre%'

