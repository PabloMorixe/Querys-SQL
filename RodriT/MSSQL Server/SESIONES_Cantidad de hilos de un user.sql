
/*************

 Query para obtener la cantidad de Hilos/sesiones activas para un login,
 
 usando vista dinamica.

 Patricio Pincas - 02/2017 

*************/


SELECT login_name ,COUNT(session_id) AS session_count   
FROM sys.dm_exec_sessions  
where login_name = 'usrtablerossoadesa' 
GROUP BY login_name