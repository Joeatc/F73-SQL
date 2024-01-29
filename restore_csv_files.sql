use myTestDb;

with streets as (
    SELECT DISTINCT IIF(LEN(strasse) - LEN(REPLACE(strasse, ' ', '')) >= 2,
                        LEFT(strasse, CHARINDEX(' ', strasse, CHARINDEX(' ', strasse) + 1) - 1),
                        LEFT(strasse, CHARINDEX(' ', strasse, CHARINDEX(' ', strasse)) - 1)) as strasse,
                    IIF(LEN(strasse) - LEN(REPLACE(strasse, ' ', '')) >= 2,
                        SUBSTRING(strasse, CHARINDEX(' ', strasse, CHARINDEX(' ', strasse) + 1) + 1, LEN(strasse)),
                        SUBSTRING(strasse, CHARINDEX(' ', strasse, CHARINDEX(' ', strasse)) + 1, LEN(strasse))) as suffix
    FROM
        myTestDb.locations.Adresse
)

SELECT ROW_NUMBER() OVER ( ORDER BY (SELECT NULL) ) id , strasse, suffix FROM streets;
