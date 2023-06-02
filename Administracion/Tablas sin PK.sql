-------------------------------------------------------------------
--TABLAS SIN CLAVE PRIMARIA EN LA BD ACTUAL
-------------------------------------------------------------------
SELECT 
   T.TABLE_NAME AS "Tables without PKs"
FROM INFORMATION_SCHEMA.TABLES AS T
WHERE NOT EXISTS 
   (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
      WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
         AND T.TABLE_NAME = TC.TABLE_NAME)
         AND T.TABLE_TYPE = 'BASE TABLE'