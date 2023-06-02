SELECT DB_NAME(CAST(db.value AS INT)) AS DBName,
	 OBJECT_NAME(CAST(obj.value AS INT),CAST(db.value AS INT)) AS objName,
	 plan_handle,
	 refcounts,
	 usecounts,
	 pool_id,
	 cacheobjtype,
	 bucketid
FROM sys.dm_exec_cached_plans cp (NOLOCK)
CROSS APPLY sys.dm_exec_plan_attributes(cp.plan_handle) db 
CROSS APPLY sys.dm_exec_plan_attributes(cp.plan_handle) obj
WHERE db.attribute = 'dbid'
	 AND db.value = DB_ID('emerix')  
	 AND obj.attribute = 'objectid'
	 --agregar dato para ver el plan de un sp en particular
	 --AND obj.value = OBJECT_ID('uspGetEmployeeManagers')