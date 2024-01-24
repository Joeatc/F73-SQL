use myTestDb

          BULK INSERT locations.test
              FROM 'zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              );
[2024-01-23 13:06:54] [S0002][208] Line 3: Invalid object name 'locations.test'.
[2024-01-23 13:06:54] [S0001][5701] Changed database context to 'myTestDb'.
myTestDb> use myTestDb;

          BULK INSERT locations.Ort
              FROM 'zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              );
[2024-01-23 13:07:12] [S0001][4860] Line 3: Cannot bulk load. The file "zuordnung_plz_ort.csv" does not exist or you don't have file access rights.
[2024-01-23 13:07:12] [S0001][5701] Changed database context to 'myTestDb'.
myTestDb> use myTestDb;

          BULK INSERT locations.Ort
              FROM './zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              );
[2024-01-23 13:07:30] [S0001][4860] Line 3: Cannot bulk load. The file "./zuordnung_plz_ort.csv" does not exist or you don't have file access rights.
[2024-01-23 13:07:30] [S0001][5701] Changed database context to 'myTestDb'.
myTestDb> use myTestDb;

          BULK INSERT locations.Ort
              FROM 'zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              );
[2024-01-23 13:13:01] [S0001][4860] Line 3: Cannot bulk load. The file "zuordnung_plz_ort.csv" does not exist or you don't have file access rights.
[2024-01-23 13:13:01] [S0001][5701] Changed database context to 'myTestDb'.
myTestDb> use myTestDb;

          BULK INSERT locations.Ort
              FROM 'zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              );
[2024-01-23 13:13:13] [S0001][4860] Line 3: Cannot bulk load. The file "zuordnung_plz_ort.csv" does not exist or you don't have file access rights.
[2024-01-23 13:13:13] [S0001][5701] Changed database context to 'myTestDb'.
myTestDb> use myTestDb;

          BULK INSERT locations.Ort
              FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              );
[2024-01-23 13:13:59] [S0001][4864] Line 3: Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 2, column 1 (id).
[2024-01-23 13:13:59] [S0001][5701] Changed database context to 'myTestDb'.
myTestDb> use myTestDb;

          BULK INSERT locations.Ort
              FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\r\n',
              FIRSTROW = 2
              );
[2024-01-23 13:16:13] [S0001][5701] Changed database context to 'myTestDb'.
[2024-01-23 13:16:13] completed in 81 ms
myTestDb> select top(100) * from locations.Ort
    [2024-01-23 13:19:58] 100 rows retrieved starting from 1 in 231 ms (execution: 38 ms, fetching: 193 ms)
              [2024-01-23 13:20:28] Unsafe query: 'Delete' statement without 'where' clears all data in the table
              myTestDb> delete from locations.Ort
    [2024-01-23 13:20:34] 12,854 rows affected in 463 ms
myTestDb> select top(100) * from locations.Ort
    [2024-01-23 13:20:41] 0 rows retrieved in 19 ms (execution: 7 ms, fetching: 12 ms)
myTestDb> use myTestDb;

BULK INSERT locations.Ort
              FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\r\n',
              FIRSTROW = 2
              );
[2024-01-23 13:20:47] [S0001][5701] Changed database context to 'myTestDb'.
[2024-01-23 13:20:47] completed in 74 ms
myTestDb> use myTestDb;

          BULK INSERT locations.Ort
              FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\r\n',
              FIRSTROW = 2
              );
[2024-01-23 13:20:51] [S0001][5701] Changed database context to 'myTestDb'.
[2024-01-23 13:20:51] completed in 48 ms
myTestDb> select top(100) * from locations.Ort
    [2024-01-23 13:21:00] 0 rows retrieved in 27 ms (execution: 9 ms, fetching: 18 ms)
[2024-01-23 13:21:20] Unsafe query: 'Delete' statement without 'where' clears all data in the table
myTestDb> delete from locations.Ort
    [2024-01-23 13:21:22] completed in 61 ms
myTestDb> create table locations.temp_orte (
                                                   osm_id varchar(20),
                                                   ags varchar(10),
                                                   ort varchar(50),
                                                   plz varchar (5),
                                                   landkreis varchar(50),
                                                   bundesland varchar(50)
          )
    [2024-01-23 13:24:19] completed in 42 ms
myTestDb> use myTestDb;

BULK INSERT locations.temp_orte
              FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\r\n',
              FIRSTROW = 2
              );
[2024-01-23 13:24:47] [S0001][5701] Changed database context to 'myTestDb'.
[2024-01-23 13:24:47] completed in 89 ms
myTestDb> select * from locations.temp_orte
    [2024-01-23 13:25:06] 0 rows retrieved in 56 ms (execution: 23 ms, fetching: 33 ms)
myTestDb> BULK INSERT locations.temp_orte
          FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
          WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              )
              [2024-01-23 13:26:10] 12,854 rows affected in 165 ms
              myTestDb> select * from locations.temp_orte
    [2024-01-23 13:26:30] 500 rows retrieved starting from 1 in 56 ms (execution: 16 ms, fetching: 40 ms)
                            myTestDb> BULK INSERT locations.Ort
                        FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
                        WITH (
                            FIELDTERMINATOR = ',',
                            ROWTERMINATOR = '\n',
                            FIRSTROW = 2
                            )
                            [2024-01-23 13:28:31] [S0001][4864] Line 1: Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 2, column 1 (id).
                            [2024-01-23 13:31:38] Unsafe query: 'Delete' statement without 'where' clears all data in the table
                            myTestDb> delete from locations.temp_orte
    [2024-01-23 13:31:40] 12,854 rows affected in 94 ms
myTestDb> select * from locations.temp_orte
    [2024-01-23 13:31:46] 0 rows retrieved in 41 ms (execution: 13 ms, fetching: 28 ms)
myTestDb> BULK INSERT locations.Ort
          FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
          WITH (
                  FIELDTERMINATOR = ',',
                  ROWTERMINATOR = '\n',
                  FIRSTROW = 2
                  )
                  [2024-01-23 13:32:59] [S0001][4864] Line 1: Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 2, column 1 (id).
                  myTestDb> BULK INSERT locations.temp_orte
          FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
          WITH (
                  FIELDTERMINATOR = ',',
                  ROWTERMINATOR = '\n',
                  FIRSTROW = 2
                  )
                  [2024-01-23 13:33:08] 12,854 rows affected in 123 ms
                  myTestDb> select * from locations.temp_orte
    [2024-01-23 13:33:15] 500 rows retrieved starting from 1 in 44 ms (execution: 10 ms, fetching: 34 ms)
                                myTestDb> insert into locations.Ort (ort, plz)
select ort, plz from locations.temp_orte
    [2024-01-23 13:39:02] 12,854 rows affected in 144 ms
[2024-01-23 13:40:17] Unsafe query: 'Delete' statement without 'where' clears all data in the table
myTestDb> delete from locations.Ort
    [2024-01-23 13:40:18] 12,854 rows affected in 96 ms
myTestDb> select * from locations.Ort
    [2024-01-23 13:40:39] 0 rows retrieved in 45 ms (execution: 28 ms, fetching: 17 ms)
myTestDb> insert into locations.Ort (ort, plz)
select ort, plz from locations.temp_orte
    [2024-01-23 13:51:32] 12,854 rows affected in 143 ms
myTestDb> select * from locations.Ort
    [2024-01-23 13:52:36] 500 rows retrieved starting from 1 in 45 ms (execution: 12 ms, fetching: 33 ms)
                  [2024-01-23 13:57:56] Unsafe query: 'Delete' statement without 'where' clears all data in the table
                  myTestDb> drop table locations.temp_orte
    [2024-01-23 13:58:22] completed in 81 ms
    myTestDb> create table locations.temp_orte (
                                                   osm_id nvarchar(20),
                                                   ags nvarchar(10),
                                                   ort nvarchar(50),
                                                   plz nvarchar (5),
                                                   landkreis nvarchar(50),
                                                   bundesland nvarchar(50)
              )
    [2024-01-23 13:58:27] completed in 29 ms
myTestDb> BULK INSERT locations.temp_orte
              FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
              WITH (
              FIELDTERMINATOR = ',',
              ROWTERMINATOR = '\n',
              FIRSTROW = 2
              )
[2024-01-23 13:58:39] 12,854 rows affected in 171 ms
[2024-01-23 13:58:50] Unsafe query: 'Delete' statement without 'where' clears all data in the table
myTestDb> delete from locations.Ort
    [2024-01-23 13:58:52] 12,854 rows affected in 101 ms
myTestDb> alter table locations.Ort
    add bundesland NVARCHAR(50)
[2024-01-23 13:59:05] completed in 57 ms
myTestDb> insert into locations.Ort (ort, plz, bundesland)
select ort, plz, bundesland from locations.temp_orte
    [2024-01-23 13:59:41] 12,854 rows affected in 221 ms
myTestDb> select * from locations.Ort
    [2024-01-23 13:59:52] 500 rows retrieved starting from 1 in 63 ms (execution: 34 ms, fetching: 29 ms)
                  myTestDb> select * from locations.temp_orte
    [2024-01-23 14:07:45] 500 rows retrieved starting from 1 in 131 ms (execution: 96 ms, fetching: 35 ms)
                                myTestDb> select bundesland, count(ort) from locations.Ort group by bundesland
                                                                                                        [2024-01-23 14:10:33] 16 rows retrieved starting from 1 in 177 ms (execution: 126 ms, fetching: 51 ms)
                                              myTestDb> select bundesland, count(ort) from locations.Ort group by bundesland order by bundesland
                                                                                                                                          [2024-01-23 14:11:11] 16 rows retrieved starting from 1 in 78 ms (execution: 65 ms, fetching: 13 ms)
                                                            myTestDb> SELECT bundesland , landkreis ,
                                                                             ROW_NUMBER () OVER ( PARTITION BY landkreis ORDER BY bundesland ) AS row_num
                                                                      FROM locations.temp_orte
                                                                          [2024-01-23 14:17:25] 500 rows retrieved starting from 1 in 285 ms (execution: 186 ms, fetching: 99 ms)
                                                                          myTestDb> SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland ORDER BY landkreis ) AS row_num
                                                                                    FROM locations.temp_orte
                                                                                        [2024-01-23 14:18:01] 500 rows retrieved starting from 1 in 119 ms (execution: 91 ms, fetching: 28 ms)
                                                                                        myTestDb> SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland ) AS row_num
                                                                                                  FROM locations.temp_orte
                                                                                                      [2024-01-23 14:18:19] [S0001][4112] Line 1: The function 'ROW_NUMBER' must have an OVER clause with ORDER BY.
                                                                                                      myTestDb> SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland order by bundesland) AS row_num
                                                                                                                FROM locations.temp_orte
                                                                                                                    [2024-01-23 14:18:43] 500 rows retrieved starting from 1 in 95 ms (execution: 73 ms, fetching: 22 ms)
                                                                                                                    myTestDb> SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland order by bundesland) AS row_num
                                                                                                                              FROM locations.temp_orte
                                                                                                                                  [2024-01-23 14:19:00] 500 rows retrieved starting from 501 in 243 ms (execution: 212 ms, fetching: 31 ms)
                                                                                                                                  myTestDb> SELECT COUNT(*) FROM (SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland order by bundesland) AS row_num
                                                                                                                                                                  FROM locations.temp_orte) t
    [2024-01-23 14:19:01] completed in 18 ms
myTestDb> SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland order by bundesland) AS row_num
          FROM locations.temp_orte
              [2024-01-23 14:19:02] 500 rows retrieved starting from 1,001 in 98 ms (execution: 82 ms, fetching: 16 ms)
                  myTestDb> SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland order by bundesland) AS row_num
                            FROM locations.temp_orte
                            group by landkreis, bundesland
                                [2024-01-23 14:20:06] 309 rows retrieved starting from 1 in 171 ms (execution: 152 ms, fetching: 19 ms)
                                myTestDb> SELECT bundesland , landkreis , ROW_NUMBER () OVER ( PARTITION BY bundesland order by landkreis) AS row_num
                                          FROM locations.temp_orte
                                          group by landkreis, bundesland
                                              [2024-01-23 14:44:46] 309 rows retrieved starting from 1 in 255 ms (execution: 170 ms, fetching: 85 ms)
                                              myTestDb> SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
                                                        FROM locations.temp_orte
                                                        GROUP BY Bundesland, Landkreis
                                                            [2024-01-23 15:08:44] 309 rows retrieved starting from 1 in 101 ms (execution: 76 ms, fetching: 25 ms)
                                                            myTestDb> SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
                                                                      FROM locations.temp_orte
                                                                      GROUP BY Bundesland, Landkreis
                                                                      ORDER BY bundesland, landkreis
                                                                          [2024-01-23 15:09:14] 309 rows retrieved starting from 1 in 72 ms (execution: 49 ms, fetching: 23 ms)
                                                                          myTestDb> SELECT STRING_AGG(QUOTENAME(bundesland), ',')
                                                                                    FROM (SELECT DISTINCT bundesland FROM locations.temp_orte) AS x
                                                                                        [2024-01-23 15:13:36] 1 row retrieved starting from 1 in 106 ms (execution: 88 ms, fetching: 18 ms)
                                                                                        myTestDb> SELECT Landkreis,
                                                                                                      [Baden-W├╝rttemberg]     as BL1,
                 [Brandenburg]            as BL2,
                 [Hessen]                 as BL3,
                 [Schleswig-Holstein]     as BL4,
                 [Mecklenburg-Vorpommern] as BL5,
                 [Saarland]               as BL6,
                 [Sachsen-Anhalt]         as BL7,
                 [Nordrhein-Westfalen]    as BL8,
                 [Bremen]                 as BL9,
                 [Th├╝ringen]             as BL10,
                 [Rheinland-Pfalz]        as BL11,
                 [Hamburg]                as BL12,
                 [Niedersachsen]          as BL13,
                 [Sachsen]                as BL14,
                 [Berlin]                 as BL15,
                 [Bayern]                 as BL16
                                                                                                  FROM (SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
                                                                                                      FROM locations.temp_orte
                                                                                                      GROUP BY Bundesland, Landkreis) AS SourceTable
                                                                                                      PIVOT
                                                                                                      (
                                                                                                      SUM(OrteCount)
                                                                                                      FOR Bundesland IN ([Baden-W├╝rttemberg],[Brandenburg],[Hessen],[Schleswig-Holstein],[Mecklenburg-Vorpommern],[Saarland],[Sachsen-Anhalt],[Nordrhein-Westfalen],[Bremen],[Th├╝ringen],[Rheinland-Pfalz],[Hamburg],[Niedersachsen],[Sachsen],[Berlin],[Bayern]) -- List all Bundesländer
                   ) AS PivotTable
[2024-01-23 15:16:42] 295 rows retrieved starting from 1 in 142 ms (execution: 109 ms, fetching: 33 ms)
                                                                                                      myTestDb> SELECT Landkreis,
                                                                                                                    [Baden-W├╝rttemberg]     as BW,
                 [Brandenburg]            as BR,
                 [Hessen]                 as HE,
                 [Schleswig-Holstein]     as SH,
                 [Mecklenburg-Vorpommern] as MV,
                 [Saarland]               as SL,
                 [Sachsen-Anhalt]         as SA,
                 [Nordrhein-Westfalen]    as NW,
                 [Bremen]                 as BR,
                 [Th├╝ringen]             as TH,
                 [Rheinland-Pfalz]        as RP,
                 [Hamburg]                as HH,
                 [Niedersachsen]          as NS,
                 [Sachsen]                as SA,
                 [Berlin]                 as B,
                 [Bayern]                 as BN
                                                                                                                FROM (SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
                                                                                                                    FROM locations.temp_orte
                                                                                                                    GROUP BY Bundesland, Landkreis) AS SourceTable
                                                                                                                    PIVOT
                                                                                                                    (
                                                                                                                    SUM(OrteCount)
                                                                                                                    FOR Bundesland IN ([Baden-W├╝rttemberg],[Brandenburg],[Hessen],[Schleswig-Holstein],[Mecklenburg-Vorpommern],[Saarland],[Sachsen-Anhalt],[Nordrhein-Westfalen],[Bremen],[Th├╝ringen],[Rheinland-Pfalz],[Hamburg],[Niedersachsen],[Sachsen],[Berlin],[Bayern]) -- List all Bundesländer
                   ) AS PivotTable
[2024-01-23 15:18:34] 295 rows retrieved starting from 1 in 104 ms (execution: 73 ms, fetching: 31 ms)
                                                                                                                    myTestDb> SELECT STRING_AGG(QUOTENAME(bundesland), ',')
                                                                                                                              FROM (SELECT DISTINCT bundesland FROM locations.temp_orte) AS x
                                                                                                                                  [2024-01-23 15:26:58] 1 row retrieved starting from 1 in 97 ms (execution: 52 ms, fetching: 45 ms)
                                                                                                                                  myTestDb> SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
                                                                                                                                            FROM locations.temp_orte
                                                                                                                                            GROUP BY Bundesland, Landkreis
                                                                                                                                            ORDER BY bundesland, landkreis
                                                                                                                                                [2024-01-23 15:27:48] 309 rows retrieved starting from 1 in 71 ms (execution: 37 ms, fetching: 34 ms)
                                                                                                                                                myTestDb> SELECT Landkreis,
                                                                                                                                                              [Baden-W├╝rttemberg]     as BW,
                 [Brandenburg]            as BR,
                 [Hessen]                 as HE,
                 [Schleswig-Holstein]     as SH,
                 [Mecklenburg-Vorpommern] as MV,
                 [Saarland]               as SL,
                 [Sachsen-Anhalt]         as SA,
                 [Nordrhein-Westfalen]    as NW,
                 [Bremen]                 as BR,
                 [Th├╝ringen]             as TH,
                 [Rheinland-Pfalz]        as RP,
                 [Hamburg]                as HH,
                 [Niedersachsen]          as NS,
                 [Sachsen]                as SA,
                 [Berlin]                 as B,
                 [Bayern]                 as BN
                                                                                                                                                          FROM (SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
                                                                                                                                                              FROM locations.temp_orte
                                                                                                                                                              GROUP BY Bundesland, Landkreis) AS SourceTable
                                                                                                                                                              PIVOT
                                                                                                                                                              (
                                                                                                                                                              SUM(OrteCount)
                                                                                                                                                              FOR Bundesland IN ([Baden-W├╝rttemberg],[Brandenburg],[Hessen],[Schleswig-Holstein],[Mecklenburg-Vorpommern],[Saarland],[Sachsen-Anhalt],[Nordrhein-Westfalen],[Bremen],[Th├╝ringen],[Rheinland-Pfalz],[Hamburg],[Niedersachsen],[Sachsen],[Berlin],[Bayern]) -- List all Bundesländer
                   ) AS PivotTable
[2024-01-23 15:28:39] 295 rows retrieved starting from 1 in 76 ms (execution: 42 ms, fetching: 34 ms)
                                                                                                                                                              myTestDb> DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

          -- Construct the list of unique Bundesländer
SELECT @columns = STRING_AGG(QUOTENAME(Bundesland), ',')
FROM (SELECT DISTINCT Bundesland FROM locations.temp_orte) AS x;

-- Construct the pivot query
SET @sql = N'
          SELECT Landkreis, ' + @columns + '
          FROM
          (
              SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
              FROM YourTableName
              GROUP BY Bundesland, Landkreis
          ) AS SourceTable
          PIVOT
          (
              SUM(OrteCount)
              FOR Bundesland IN (' + @columns + ')
          ) AS PivotTable;';

          -- Execute the dynamic pivot query
EXEC sp_executesql @sql;
[2024-01-23 15:40:29] [S0002][208] Line 2: Invalid object name 'YourTableName'.
myTestDb> DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

          -- Construct the list of unique Bundesländer
SELECT @columns = STRING_AGG(QUOTENAME(Bundesland), ',')
FROM (SELECT DISTINCT Bundesland FROM locations.temp_orte) AS x;

-- Construct the pivot query
SET @sql = N'
          SELECT Landkreis, ' + @columns + '
          FROM
          (
              SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
              FROM locations.temp_orte
              GROUP BY Bundesland, Landkreis
          ) AS SourceTable
          PIVOT
          (
              SUM(OrteCount)
              FOR Bundesland IN (' + @columns + ')
          ) AS PivotTable;';

          -- Execute the dynamic pivot query
EXEC sp_executesql @sql;
[2024-01-23 15:41:07] 295 rows retrieved starting from 1 in 138 ms (execution: 91 ms, fetching: 47 ms)
myTestDb> DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

          -- Construct the list of unique Bundesländer
SELECT @columns = STRING_AGG(QUOTENAME(Bundesland), ',')
FROM (SELECT DISTINCT Bundesland FROM locations.temp_orte) AS x;

-- Construct the pivot query
SET @sql = N'
          SELECT Landkreis, ' + @columns + '
          FROM
          (
              SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
              FROM locations.temp_orte
              GROUP BY Bundesland, Landkreis
              ORDER BY Landkreis
          ) AS SourceTable
          PIVOT
          (
              SUM(OrteCount)
              FOR Bundesland IN (' + @columns + ')
          ) AS PivotTable;';

          -- Execute the dynamic pivot query
EXEC sp_executesql @sql;
[2024-01-23 15:43:57] [S0001][1033] Line 9: The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP, OFFSET or FOR XML is also specified.
myTestDb> DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

          -- Construct the list of unique Bundesländer
SELECT @columns = STRING_AGG(QUOTENAME(Bundesland), ',')
FROM (SELECT DISTINCT Bundesland FROM locations.temp_orte) AS x;

-- Construct the pivot query
SET @sql = N'
          SELECT Landkreis, ' + @columns + '
          FROM
          (
              SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
              FROM locations.temp_orte
              GROUP BY Bundesland, Landkreis
          ) AS SourceTable
          PIVOT
          (
              SUM(OrteCount)
              FOR Bundesland IN (' + @columns + ')
          ) AS PivotTable Order By Landkreis;';

          -- Execute the dynamic pivot query
EXEC sp_executesql @sql;
[2024-01-23 15:45:04] 295 rows retrieved starting from 1 in 144 ms (execution: 112 ms, fetching: 32 ms)
