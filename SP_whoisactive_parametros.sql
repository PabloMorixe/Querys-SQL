sp_whoisactive --         15,626,471
select * from sysprocesses where blocked > 0  or spid = 106
--
sp_whoisactive
    @delta_interval = 60 
	,@get_outer_command = 1
	,@get_plans = 1
	--,@Sort_order = 
	sp_whoisactive 
   @show_sleeping_spids = 2


	go
	sp_whoisactive @get_plans=2  
	go

	select * from sysprocesses where blocked > 0

	---
sp_whoisactive 

 328, @get_plans=2
go
 sp_who2 328
 --go

 sp_whoisactive 76,
    @delta_interval = 10 
	,@get_outer_command = 1
	,@get_plans = 1
