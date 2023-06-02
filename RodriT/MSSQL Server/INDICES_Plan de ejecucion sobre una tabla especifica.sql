DECLARE @StringToSearchFor VARCHAR ( 100 )
SET @StringToSearchFor = '%%Auditlog%'
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
select
st . text AS [SQL]
, Cp . cacheobjtype
, Cp . objtype
, DB_NAME ( st . Dbid ) AS [DatabaseName]
, Cp . usecounts AS [uso Plan]
, QP . query_plan
from
sys . dm_exec_cached_plans cp
CROSS APPLY sys . dm_exec_sql_text ( cp . plan_handle ) st
CROSS APPLY sys . dm_exec_query_plan ( cp . plan_handle ) qp
where
cast ( QP . Query_plan AS NVARCHAR ( MAX )) like @StringToSearchFor
order by
cp . usecounts DESC