SELECT ID_PLAN, ID_DEPOSITO, COD_INSUMO, ID_CUENTA, COUNT(*) TotalCount
FROM PLANES_DETALLES
GROUP BY ID_PLAN, ID_DEPOSITO, COD_INSUMO, ID_CUENTA
HAVING COUNT(*) > 1
ORDER BY 1, 2, 3, 4