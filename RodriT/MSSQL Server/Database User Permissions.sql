select sysusers.name as username, sysusers.gid, sysobjects.name as objectname, 
	sysobjects.id, CASE WHEN sysprotects_1.action is null 
	THEN CASE WHEN sysobjects.xtype = 'P' THEN 'N/A' ELSE 'No' END ELSE 'Yes' END 
	as 'SELECT', CASE WHEN sysprotects_2.action is null 
	THEN CASE WHEN sysobjects.xtype = 'P' THEN 'N/A' ELSE 'No' END ELSE 'Yes' END 
	as 'INSERT', CASE WHEN sysprotects_3.action is null 
	THEN CASE WHEN sysobjects.xtype = 'P' THEN 'N/A' ELSE 'No' END ELSE 'Yes' END 
	as 'UPDATE', CASE WHEN sysprotects_4.action is null 
	THEN CASE WHEN sysobjects.xtype = 'P' THEN 'N/A' ELSE 'No' END ELSE 'Yes' END 
	as 'DELETE', CASE WHEN sysprotects_5.action is null 
	THEN CASE WHEN sysobjects.xtype = 'U' THEN 'N/A' ELSE 'No' END ELSE 'Yes' END 
	as 'EXECUTE'from sysusers full join sysobjects 
	on ( sysobjects.xtype in ( 'P', 'U' ) and sysobjects.Name NOT LIKE 'dt%' ) 
	left join sysprotects as sysprotects_1  on sysprotects_1.uid = sysusers.uid 
	and sysprotects_1.id = sysobjects.id and sysprotects_1.action = 193 
	and sysprotects_1.protecttype in ( 204, 205 ) left join sysprotects as sysprotects_2  
	on sysprotects_2.uid = sysusers.uid and sysprotects_2.id = sysobjects.id 
	and sysprotects_2.action = 195 and sysprotects_2.protecttype in ( 204, 205 ) 
	left join sysprotects as sysprotects_3  on sysprotects_3.uid = sysusers.uid 
	and sysprotects_3.id = sysobjects.id and sysprotects_3.action = 197 
	and sysprotects_3.protecttype in ( 204, 205 ) left join sysprotects as sysprotects_4  
	on sysprotects_4.uid = sysusers.uid and sysprotects_4.id = sysobjects.id 
	and sysprotects_4.action = 196 and sysprotects_4.protecttype in ( 204, 205 ) 
	left join sysprotects as sysprotects_5  on sysprotects_5.uid = sysusers.uid 
	and sysprotects_5.id = sysobjects.id and sysprotects_5.action = 224 
	and sysprotects_5.protecttype in ( 204, 205 )
where (sysprotects_1.action is not null or 
	sysprotects_2.action is not null or sysprotects_3.action is not null 
	or sysprotects_4.action is not null or sysprotects_5.action is not null)
order by sysusers.name, sysobjects.name