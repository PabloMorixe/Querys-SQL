SELECT c.value as 'Memoria(MB)'
FROM sys.configurations c WHERE c.[name] = 'max server memory (MB)'