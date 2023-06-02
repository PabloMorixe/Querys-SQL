/*Genera el comando sql, correrlo sobre una base. Copiar la salida y correrla para eliminar todas las tablas*/

select 'DROP TABLE ' + name from sysobjects where xtype='U'