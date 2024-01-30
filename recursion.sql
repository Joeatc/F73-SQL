WITH RecursiveNumbers AS (
    -- Anchor member ( base case )
    SELECT 1 AS number

    UNION ALL

    -- Recursive member
    SELECT number + 1
    FROM RecursiveNumbers
    WHERE number < 10)

SELECT number
FROM RecursiveNumbers;


-- =========================================
-- the employee sample
-- =========================================

use myTestDb;

drop table if exists people.employees;
create table people.employees
(
    employee_id   uniqueidentifier primary key default newid(),
    employee_name varchar(50),
    manager_id    uniqueidentifier
);

insert into people.employees (employee_name)
select top 5000 concat(vorname, ' ', name)
from people.Personen
order by newId();

-- set the big boss has manager_id = NULL.
-- who is it?
declare @ceo uniqueidentifier;
select top(1) @ceo = employee_id from people.employees order by newid();

select @ceo as CEO;

-- how many top managers shall he/she have?
update people.employees set manager_id = @ceo
where employee_id in (select top 5 employee_id from people.employees where manager_id IS NULL and employee_id <> @ceo);

select * from people.employees where manager_id = @ceo;

-- how many group leaders shall there be?
with top_managers as (
    SELECT employee_id as top_id FROM people.employees WHERE manager_id = @ceo
), group_leaders as (
        SELECT TOP 15 employee_id as group_id
        FROM people.employees
        WHERE manager_id IS NULL
          AND employee_id <> @ceo
        order by newid()
    )
update people.employees set manager_id = x.top_id
from (select top 15 group_id, top_id
      from group_leaders,
           top_managers
      order by newid()) x
where employee_id = x.group_id;

-- now there is the staff of workers left.

with top_managers as (
    select employee_id as top_id
    FROM people.employees
    WHERE manager_id = @ceo
), group_leaders as (
    select employee_id as group_id
    from people.employees
    where manager_id in (select top_id from top_managers)
)
update people.employees set manager_id = x.group_id
from (select group_id
      from group_leaders) x
where manager_id is null and employee_id <> @ceo;

select * from people.employees;


WITH RecursiveHierarchy AS (

    SELECT employee_id, employee_name, manager_id
    FROM people.employees
    WHERE employee_id = (select top 1 employee_id from people.employees order by newid()) -- starting with a specific employee

    UNION ALL

    -- Recursive member
    SELECT e.employee_id, e.employee_name, e.manager_id
    FROM people.employees e
    JOIN RecursiveHierarchy rh ON e.employee_id = rh.manager_id)

SELECT *
FROM RecursiveHierarchy;
GO


-- UOM Conversion
-- =====================================================

CREATE SCHEMA items;
GO

CREATE TABLE items.item
(
    id          uniqueidentifier default NEWID() primary key,
    description varchar(100),
    baseUOM     varchar(10),
    baseUnits   numeric,
    amount      numeric default 1,   -- Beispiel: 1 Schraube wiegt 15 Gramm
    priceUOM    varchar(10),
    priceUnits  numeric,
    priceAmount numeric default 1,    -- Beispiel: 1 kg kostet 35,70€
    currency    char(4)
)

INSERT INTO items.item (description) VALUES ('Schraube 8 x 50 mm, metrisch, Vollgewinde, Sechskant, 10.9');
INSERT INTO items.item (description) VALUES ('Tasse, Keramik, ohne Druck, schlank');

CREATE TABLE items.UOMConversion
(
    id             uniqueidentifier default NEWID() primary key,
    UOMFrom        varchar(10),
    UOMTo          varchar(10),
    ItemId         uniqueidentifier,
    ConversionType char(1), -- M = multiplizieren , D = dividieren
    Factor         numeric
)





CREATE FUNCTION items.UOMPath(
    @StartUnit nvarchar(10),
    @EndUnit nvarchar(10),
    @ItemId nvarchar(10) = NULL,
    @StartValue decimal(38, 20)
)
    RETURNS @paths TABLE
                   (
                       [PathId]           [int] IDENTITY (1,1) NOT NULL,
                       [UOMFrom]          [nvarchar](10)       NULL,
                       [UOMTo]            [nvarchar](10)       NULL,
                       [Path]             [nvarchar](max)      NULL,
                       [ConversionFactor] [decimal](38, 20)    NULL,
                       [ConvertedValue]   [decimal](38, 20)    NULL
                   )
AS
BEGIN
    WITH Edges AS
             (SELECT [UOMFrom]
                   , [UOMTo]
                   , [ItemId]
                   , [ConversionType]
                   , [Factor]
              FROM items.[UOMConversion]
              WHERE (ItemId is Null or itemId = @ItemId)

              UNION ALL

              SELECT [UOMTo]                     as [UOMFrom]
                   , [UOMFrom]                   as [UOMTo]
                   , [ItemId]
                   , IIF([ConversionType] = 'M', 'D', 'M') as Type
                   , [Factor]
              FROM items.[UOMConversion] UOMC1
              WHERE NOT EXISTS(SELECT 1
                               FROM items.[UOMConversion] UOMC2
                               WHERE UOMC1.[UOMFrom] = UOMC2.[UOMTo]
                                 AND UOMC1.[UOMTo] = UOMC2.[UOMFrom])
                AND (ItemId is Null or itemId = @ItemId)),
         cte AS
             (SELECT UOMFrom,
                     UOMTo,
                     CAST((UOMFrom + ' -> ' + UOMTo) AS NVARCHAR(MAX))                            AS Path,
                     IIF(ConversionType = 'M', Factor, 1 / Factor)                                AS ConversionFactor,
                     @StartValue * IIF(ConversionType = 'M', Factor, 1 / Factor) AS ConvertedValue
              FROM Edges
              WHERE UOMFrom = @StartUnit

              UNION ALL

              SELECT e.UOMFrom,
                     e.UOMTo,
                     CAST((c.Path + ' -> ' + e.UOMTo) AS NVARCHAR(MAX)),
                     c.ConversionFactor * IIF(e.ConversionType = 'M', e.Factor, 1 / e.Factor),
                     c.ConvertedValue * IIF(e.ConversionType = 'M', e.Factor, 1 / e.Factor) AS ConvertedValue
              FROM Edges e
                       INNER JOIN cte c ON e.UOMFrom = c.UOMTo
              WHERE c.Path NOT LIKE '%' + e.UOMTo + '%')
    INSERT
    INTO @paths (UOMFrom, UOMTo, Path, ConversionFactor, ConvertedValue)
    SELECT UOMFrom, UOMTo, Path, ConversionFactor, ConvertedValue
    FROM cte
    WHERE UOMTo = @EndUnit
    RETURN
END
