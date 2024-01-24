use myTestDb;

create table locations.temp_orte
(
    osm_id     nvarchar(20),
    ags        nvarchar(10),
    ort        nvarchar(50),
    plz        nvarchar(5),
    landkreis  nvarchar(50),
    bundesland nvarchar(50)
)

BULK INSERT locations.temp_orte
    FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
    WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

delete from locations.Ort

alter table locations.Ort
    add bundesland NVARCHAR(50);
go

insert into locations.Ort (ort, plz, bundesland)
select ort, plz, bundesland
from locations.temp_orte

select *
from locations.Ort

select *
from locations.temp_orte

select bundesland, count(ort)
from locations.Ort
group by bundesland
order by bundesland

SELECT STRING_AGG(QUOTENAME(bundesland), ',')
FROM (SELECT DISTINCT bundesland FROM locations.temp_orte) AS x

SELECT Landkreis,
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

SELECT Landkreis,
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

SELECT STRING_AGG(QUOTENAME(bundesland), ',')
FROM (SELECT DISTINCT bundesland FROM locations.temp_orte) AS x

SELECT Bundesland, Landkreis, COUNT(Ort) AS OrteCount
FROM locations.temp_orte
GROUP BY Bundesland, Landkreis
ORDER BY bundesland,
         landkreis

SELECT Landkreis,
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

DECLARE
    @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

-- Construct the list of unique Bundesländer
SELECT @columns = STRING_AGG(QUOTENAME(Bundesland), ',')
FROM (SELECT DISTINCT Bundesland FROM locations.temp_orte) AS x;

-- Construct the pivot query
SET
    @sql = N'
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
