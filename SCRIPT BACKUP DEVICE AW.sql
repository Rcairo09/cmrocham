USE master
GO

--Crea el dispositivo de backups
EXEC sp_addumpdevice 'disk', 'AdventureWorksDevice',
'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorksDevice.bak';
GO

--Muestra la lista de los dispositivos de Backups
SELECT *
FROM sys.backup_devices
GO

--Borra el dispositivo de backups
EXEC sp_dropdevice 'AdventureWorksBackupDevice', 'delfile'
GO

CREATE PROCEDURE usp_CreateBackup
AS
DECLARE @BACKUP_NAME VARCHAR (100)
SET @BACKUP_NAME = N'AdventureWorksFullBackup ' +  FORMAT (GETDATE(),'yyyyMMdd_hhmmss');
BACKUP DATABASE AdventureWorks2019
TO AdventureWorksDevice
WITH NOFORMAT, NOINIT, NAME = @BACKUP_NAME
GO

EXEC usp_CreateBackup
GO

--Muestra los Backups creados dentro del dispositivo
RESTORE HEADERONLY FROM AdventureWorksDevice
GO

--Muestra los archivos generados por el Backup
RESTORE FILELISTONLY FROM AdventureWorksDevice
GO

CREATE PROCEDURE usp_RestoreBackup
@File TINYINT 
AS
RESTORE DATABASE AdventureWorks2019
FROM AdventureWorksDevice
WITH FILE = @File,
	MOVE N'AdventureWorks2017' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\\DATA\AwExamenBDII_Restore.mdf',
	MOVE N'AdventureWorks2017_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\\DATA\AwExamenBDII_Restore.ldf',
NOUNLOAD, REPLACE, STATS = 10
GO

EXEC usp_RestoreBackup 5


