--ROL
CREATE ROLE ROL_EXEC_FUNCIONES



--PERMISOS PARA TODAS LAS FUNCIONES DE LA BD
SELECT 'GRANT SELECT ON ' + name + ' TO ROL_EXEC_FUNCIONES', *
FROM SYS.objects
WHERE type IN ('TF', 'IF')
UNION
SELECT 'GRANT EXEC ON ' + name + ' TO ROL_EXEC_FUNCIONES', *
FROM SYS.objects
WHERE type = 'FN'