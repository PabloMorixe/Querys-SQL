USE [NOMBREBD]
GO



SELECT  
  OBJECT_SCHEMA_NAME(o2.id),
  [Table]     = o2.name,   
  [Constraint] = o.name,   
  [Enabled]   = case when ((C.Status & 0x4000)) = 0 then 1 else 0 end  
FROM sys.sysconstraints C  
  inner join sys.sysobjects o on  o.id = c.constid  
  inner join sys.sysobjects o2 on o2.id = o.parent_obj  
WHERE (C.Status & 0x4000) <> 0





--Verificar la integridad de datos en todas las constraints, estén o no habilitadas
DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS, ALL_ERRORMSGS