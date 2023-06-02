/*
Sirve para deshabilitar CHECK CONTRAINTS y FK CONSTRAINTS
*/



USE AdventureWorks
GO
-- Disable the constraint
ALTER TABLE HumanResources.Employee
NOCHECK CONSTRAINT CK_Employee_BirthDate
GO
-- Enable the constraint
ALTER TABLE HumanResources.Employee
WITH CHECK CHECK CONSTRAINT CK_Employee_BirthDate
GO