	Select 
		SCHEMA_NAME(o.schema_id) as esquema,
		o.name as tabla,
		i.name as indice,
		i.type_desc as tipo,
		iu.user_lookups,
		iu.user_scans,
		iu.user_seeks,
		iu.user_updates
	from	sys.indexes i
	join	sys.objects o
		on	o.object_id = i.object_id
	left outer join	sys.dm_db_index_usage_stats IU
		on	iu.object_id = i.object_id
		and iu.index_id = i.index_id
		and IU.database_id = DB_ID()       
	where 
		o.type in('U')
	group by
		o.object_id,
		o.name,
		SCHEMA_NAME(o.schema_id),
		i.name,
		i.index_id,
		i.type,
		i.type_desc,
		user_lookups,
		user_scans,
		user_seeks,
		user_updates
