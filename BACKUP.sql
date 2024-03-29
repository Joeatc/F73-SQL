BACKUP DATABASE myTestDb
TO DISK = N'/var/opt/mssql/data/myTestDb.bak'
WITH NOFORMAT, NOINIT,
NAME = N'myTestDb-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD, STATS = 10;


RESTORE DATABASE myTestDb
FROM DISK = N'/var/opt/mssql/data/myTestDb.bak'
WITH REPLACE, RECOVERY;

ALTER DATABASE myTestDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE myTestDb SET MULTI_USER;
