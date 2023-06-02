/*Informacion de Cada plan - cantidad de veces q se ejecuto, etc*/

select * from sys.dm_exec_cached_plans

/*informacion de optimizacion - p.e: se puede ver cuandos querys se han optimizado desde que se prendio el server*/

select * from sys.dm_exec_query_optimizer_info


/*devuelve en xml el plan utilizado por una query*/

select * from sys.dm_exec_query_plan

/*retorna en formato texto el query plan*/

select * from sys.dm_exec_text_query_plan


/*retorna todos los atributos de un plan, por ejemplo cuantas veces se ejecutó*/

select * from sys.dm_exec_plan_attributes