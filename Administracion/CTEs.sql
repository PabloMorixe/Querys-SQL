--------------------------------------
--COMMON TABLE EXPRESSIONS
--------------------------------------
WITH CTE_name1 [ ( column_name [,...n] )
		 AS
		  (query defining the CTE1) ,
	 CTE_name2 [ ( column_name [,...n] )
		 AS
		  (query defining the CTE2)

		  


-------------
--EJEMPLO
-------------
WITH CTE1 (EventClass, Cant)
AS
	(
	SELECT EVENTCLASS, COUNT(*) 
	FROM TRAZAS
	GROUP BY EventClass
	)
SELECT EVENTCLASS, Cant
FROM CTE1
WHERE Cant = (SELECT MAX(Cant) FROM CTE1)




---------------------------------------------------------------
--EJEMPLO USANDO MULTIPLES TABLE EXPRESSIONS
---------------------------------------------------------------
WITH
  CountEmployees(dept_id, n) AS
    ( SELECT dept_id, count(*) AS n
      FROM employee GROUP BY dept_id ),
  DeptPayroll( dept_id, amt ) AS
     ( SELECT dept_id, sum(salary) AS amt
       FROM employee GROUP BY dept_id )
SELECT count.dept_id, count.n, pay.amt
FROM CountEmployees AS count JOIN DeptPayroll AS pay
ON count.dept_id = pay.dept_id
WHERE count.n = ( SELECT max(n) FROM CountEmployees )
   OR pay.amt = ( SELECT min(amt) FROM DeptPayroll )
