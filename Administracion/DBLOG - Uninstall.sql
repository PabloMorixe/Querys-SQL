/*
**
** dbLog Toolkit (SQL Server 2000)
** Autor: Diego Pablo D'Ignazi
** Versión: 1.0.1
** Fecha: 06/07/2006
**
** Objetivo: Desinstalar los objetos en una base de datos de usuario
** Requisitos previos:
**	- Ejecutar con privilegios "sysadmin".
** Revisiones:
**	1.0.1
**		- FIX: se modificó para que detecte la vista "dblog_sysprocesses" 
**		       como un objeto del Toolkit
**	1.0.0 
**		- Versión inicial
**
*/

Declare @option_NoCount int

Set @option_NoCount = @@OPTIONS & 512

Set NoCount On

Print 'Uninstalling dbLog Toolkit...'

Declare @objowner sysname
Declare @objname sysname
Declare @objtype char(2)
Declare @sql varchar(1024)

Declare sysobjects Cursor Local Fast_Forward For
Select 	SU.name, SO.name, SO.type
From	sysobjects SO
	Inner Join sysusers SU On SU.uid = SO.uid
Where
	SO.name Like 'dblog_%'
Order By
	Case When SO.type = 'U' Then 0 Else 1 End

Open sysobjects
Fetch Next From sysobjects Into @objowner, @objname, @objtype
While (@@Fetch_Status = 0)
Begin
	Set @sql = 
	Case @objtype
		When 'TR' Then 'Drop Trigger'
		When 'V' Then 'Drop View'
		When 'U' Then 'Drop Table'
		When 'P' Then 'Drop Procedure'
		When 'TF' Then 'Drop Function'
		When 'FN' Then 'Drop Function'
		Else ''
	End
	
	If @sql != ''
	Begin
		Set @sql = @sql + ' [' + @objowner + '].[' + @objname + ']'
		
		Print '> Dropping ' + @objowner + '.' + @objname + '...'
		Execute(@sql)
		Print '  Dropped!'
	End
	
	Fetch Next From sysobjects Into @objowner, @objname, @objtype
End

Close sysobjects
Deallocate sysobjects

Print 'Finished!'

If @option_NoCount = 0 Set NoCount Off
Go
