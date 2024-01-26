use myTestDb;
GO

CREATE PROCEDURE GetRandomDateBetween
    @StartDate DATE,
    @EndDate DATE,
    @Result DATE OUTPUT
AS
BEGIN
    DECLARE @RandomDays INT
    -- Anzahl der Tage zwischen Startdatum und Enddatum berechnen
    SET @RandomDays = DATEDIFF(DAY, @StartDate, @EndDate)

    -- Zufällige Anzahl von Tagen zwischen 0 und der Anzahl der Tage im Bereich generieren
    SET @RandomDays = ROUND(((@RandomDays - 1) * RAND()), 0)

    -- Zufälliges Datum im Bereich generieren
    SET @Result = DATEADD(DAY, @RandomDays, @StartDate)
END;
GO

CREATE PROCEDURE CreateSchemaIfNotExists
    @SchemaName NVARCHAR(128)
AS
BEGIN
    -- Check if the schema already exists
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = @SchemaName)
    BEGIN
        -- Construct the SQL statement
        DECLARE @SQL NVARCHAR(MAX) = N'CREATE SCHEMA ' + QUOTENAME(@SchemaName);

        -- Execute the SQL statement
        EXEC sp_executesql @SQL;
    END
END;
GO

CREATE PROCEDURE CreateAllSchemas
AS
BEGIN
    EXEC CreateSchemaIfNotExists 'people';
    EXEC CreateSchemaIfNotExists 'locations';
END;
GO

EXEC CreateAllSchemas;
GO

CREATE PROCEDURE DropAllTables
AS
BEGIN
    DROP TABLE IF EXISTS people.PersonenAdressen;
    DROP TABLE IF EXISTS people.Personen;
    DROP TABLE IF EXISTS people.Geschlecht;
    DROP TABLE IF EXISTS locations.Adresse;
    DROP TABLE IF EXISTS locations.AdressenTyp;
    DROP TABLE IF EXISTS locations.Ort;
    DROP TABLE IF EXISTS locations.Land;
    DROP TABLE IF EXISTS dbo.strassen;
    DROP TABLE IF EXISTS dbo.temp_orte;
    DROP TABLE IF EXISTS dbo.temp_names;
END;
GO

EXEC DropAllTables;
GO

CREATE PROCEDURE people.ErstelleTabelleGeschlecht
AS
BEGIN
    create table people.Geschlecht
    (
        id         uniqueidentifier default newid() primary key,
        geschlecht NVARCHAR(30),
        gender     NVARCHAR(30),
    )
END;
GO

CREATE PROCEDURE locations.ErstelleTabelleAdressenTyp
AS
BEGIN
    create table locations.AdressenTyp
    (
        id          uniqueidentifier default newid() primary key,
        adressenTyp NVARCHAR(20),
        addressType NVARCHAR(20)
    )
END;
GO

CREATE PROCEDURE locations.ErstelleTabelleLand
AS
BEGIN
    create table locations.Land
    (
        id      uniqueidentifier default newid() primary key,
        land    NVARCHAR(50),
        country NVARCHAR(50)
    )
END;
GO

CREATE PROCEDURE locations.ErstelleTabelleOrt
AS
BEGIN
    create table locations.Ort
    (
        id    uniqueidentifier default newid() primary key,
        ort   NVARCHAR(100),
        place NVARCHAR(100),
        plz   NVARCHAR(5),
        zip   NVARCHAR(10),
        bundesland NVARCHAR(50)
    )
END;
GO

CREATE PROCEDURE people.ErstelleTabellePersonen
AS
BEGIN
    create table people.Personen
    (
        id           uniqueidentifier default newid() primary key,
        name         NVARCHAR(100),
        vorname      NVARCHAR(100),
        geburtstag   DATETIME2(7),
        steuerId     NVARCHAR(30),
        geschlechtId uniqueidentifier,

        foreign key (geschlechtId) references people.Geschlecht (id)
    )
END;
GO

CREATE PROCEDURE locations.ErstelleTabelleAdressen
AS
BEGIN
    create table locations.Adresse
    (
        id           uniqueidentifier default newid() primary key,
        landId       uniqueidentifier,
        ortId        uniqueidentifier,
        strasse      NVARCHAR(100),
        hausnummer   NVARCHAR(10),
        adresszusatz NVARCHAR(100),
        c_o          NVARCHAR(100),

        foreign key (landId) references locations.Land (id),
        foreign key (ortId) references locations.Ort (id)
    )
END;
GO

CREATE PROCEDURE people.ErstelleTabellePersonenAdressen
AS
BEGIN
    create table people.PersonenAdressen
    (
        id        uniqueidentifier default newid() primary key,
        personId  uniqueidentifier,
        adresseId uniqueidentifier,
        von       DATETIME2(7),
        bis       DATETIME2(7),
        typeId    uniqueidentifier,

        foreign key (personId) references people.Personen (id),
        foreign key (adresseId) references locations.Adresse (id),
        foreign key (typeId) references locations.AdressenTyp (id)
    )
END;
GO

CREATE PROCEDURE CreateAllTables
AS
BEGIN
    EXEC people.ErstelleTabelleGeschlecht;
    EXEC people.ErstelleTabellePersonen;
    EXEC locations.ErstelleTabelleLand;
    EXEC locations.ErstelleTabelleOrt;
    EXEC locations.ErstelleTabelleAdressenTyp;
    EXEC locations.ErstelleTabelleAdressen;
    EXEC people.ErstelleTabellePersonenAdressen;
END;
GO

EXEC CreateAllTables;
GO

CREATE PROCEDURE locations.LoadTemporaryTableStrassen
AS
BEGIN
    create table dbo.strassen
    (
        id      int,
        strasse nvarchar(40),
        suffix  nvarchar(20)
    )

    BULK INSERT dbo.strassen
        FROM '/var/opt/mssql/Strassen.csv'
        WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
        )
END;
GO

CREATE PROCEDURE locations.LoadTemporaryTableOrte
AS
BEGIN
    CREATE TABLE dbo.temp_orte
    (
        osm_id     nvarchar(20),
        ags        nvarchar(10),
        ort        nvarchar(50),
        plz        nvarchar(5),
        landkreis  nvarchar(50),
        bundesland nvarchar(50)
    )

    BULK INSERT dbo.temp_orte
        FROM '/var/opt/mssql/zuordnung_plz_ort.csv'
        WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
        )
END;
GO

CREATE PROCEDURE people.LoadNameVornameGeschlechtIntoTemporayNamesTable
AS
BEGIN
    create table dbo.temp_names
    (
        id       nvarchar(20),
        vorname  nvarchar(50),
        nachname nvarchar(50),
        gender   nvarchar(20)
    )

    BULK INSERT dbo.temp_names
        FROM '/var/opt/mssql/NameVornameGeschlecht.csv'
        WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
        );

    update dbo.temp_names
    set gender = lower(gender)
    where 1 = 1;

END;
GO

CREATE PROCEDURE LoadCsvDataIntoTemporaryTables
AS
BEGIN
    EXEC locations.LoadTemporaryTableStrassen;
    EXEC locations.LoadTemporaryTableOrte;
    EXEC people.LoadNameVornameGeschlechtIntoTemporayNamesTable;
END;
GO

CREATE PROCEDURE people.LoadStaticDataIntoGeschlecht
AS
BEGIN
    INSERT INTO people.Geschlecht (geschlecht, gender)
    VALUES ('weiblich', 'female')
         ,('männlich', 'male')
         ,('divers', 'diverse');
END;
GO

CREATE PROCEDURE locations.LoadStaticDataIntoAddressType
AS
BEGIN
    INSERT INTO locations.AdressenTyp (adressenTyp, addressType)
    VALUES (N'privat', N'private'),
           (N'geschäftlich', N'business');
END;
GO

CREATE PROCEDURE LoadStaticDataIntoTables
AS
BEGIN
    EXEC people.LoadStaticDataIntoGeschlecht;
    EXEC locations.LoadStaticDataIntoAddressType;
END;
GO

CREATE PROCEDURE people.GenerateNames
AS
BEGIN

    WITH nn AS (SELECT TOP (1000) nachname
                FROM dbo.temp_names
                ORDER BY newId()),
         vn AS (SELECT TOP (1000) tn.vorname, G.id AS geschlechtId
                FROM dbo.temp_names tn JOIN Geschlecht G ON G.gender = tn.gender
                ORDER BY newId())
    INSERT INTO people.Personen (vorname, name, geschlechtId)
    SELECT vn.vorname, nn.nachname, vn.geschlechtId
    FROM nn, vn;

END;
GO

CREATE PROCEDURE people.ChangeGender
    @number INT,
    @percent NUMERIC,
    @ID uniqueidentifier,
    @ID2 uniqueidentifier
AS
BEGIN

    select @number = count(vorname) * @percent
    from people.Personen
    where geschlechtId = @ID;

    update x set geschlechtID = @ID2
    from (select TOP (@number) geschlechtId from people.Personen where geschlechtId = @ID order by NEWID()) x;

END;
GO

CREATE PROCEDURE people.GenerateDiverseGenders
AS
BEGIN

    declare @numberOfNames INT;
    declare @genderID uniqueidentifier;
    declare @genderID2 uniqueidentifier;

    select @genderID = id from Geschlecht where gender = 'male';
    select @genderID2 = id from Geschlecht where gender = 'diverse';

    EXEC people.ChangeGender @numberOfNames, 0.1, @genderID, @genderID2;

    select @genderID = id from Geschlecht where gender = 'female';

    EXEC people.ChangeGender @numberOfNames, 0.1, @genderID, @genderID2;

END;
GO

CREATE PROCEDURE people.GenerateRandomBirthdaysForAge18_70
AS
BEGIN

    CREATE TABLE #temp_birthdays (
        id UNIQUEIDENTIFIER,
        birthday DATE
    )

    DECLARE @RandomBirthday DATE;
    DECLARE @RunningId UNIQUEIDENTIFIER;
    DECLARE @StartDate DATE;
    DECLARE @EndDate DATE;
    SET @StartDate = DATEADD(YEAR,-70,GETDATE());
    SET @EndDate = DATEADD(YEAR,-18,GETDATE());

    DECLARE cur_Person CURSOR FOR
    SELECT id FROM people.Personen;

    OPEN cur_Person;
    FETCH NEXT FROM cur_Person INTO @RunningId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC GetRandomDateBetween @StartDate, @EndDate, @RandomBirthday OUTPUT;
        INSERT INTO #temp_birthdays (id, birthday) VALUES (@RunningId,@RandomBirthday);
        FETCH NEXT FROM cur_Person INTO @RunningId;
    END

    CLOSE cur_Person;
    DEALLOCATE cur_Person;

    UPDATE p SET p.geburtstag = b.birthday
    FROM people.Personen p JOIN #temp_birthdays b ON p.id = b.id;

END;
GO

CREATE PROCEDURE locations.GenerateOrte
AS
BEGIN
    INSERT INTO locations.Ort (ort, plz, bundesland)
        SELECT ort, plz, bundesland
        FROM dbo.temp_orte;
END;
GO

CREATE PROCEDURE locations.GenerateAddress
AS
BEGIN
    DECLARE @personenAnzahl INT;
    SELECT @personenAnzahl = COUNT(id)
    FROM people.Personen;

    CREATE TABLE #numbers ( Number INT NOT NULL PRIMARY KEY ) ;

    WITH
    L0 AS ( SELECT 1 AS C UNION ALL SELECT 1) ,
    L1 AS ( SELECT 1 AS C FROM L0 AS A , L0 AS B ) ,
    L2 AS ( SELECT 1 AS C FROM L1 AS A , L1 AS B ) ,
    L3 AS ( SELECT 1 AS C FROM L2 AS A , L2 AS B ) ,
    Nums AS ( SELECT ROW_NUMBER () OVER ( ORDER BY ( SELECT NULL ) ) AS N FROM L3 )
    INSERT INTO #numbers SELECT N FROM Nums WHERE N <= 100;

    WITH street AS (SELECT CONCAT(strasse, ' ', suffix) AS Strasse
                    FROM dbo.strassen)
    INSERT INTO locations.Adresse (ortId, strasse, hausnummer)
    SELECT TOP (@personenAnzahl) O.id, Strasse, (SELECT TOP(1) Number FROM #numbers ORDER BY newid()) as HNr
    FROM locations.Ort O, street
    ORDER BY NEWID();
END;
GO

CREATE PROCEDURE people.InsertRandomPersonenAdressen
    @number INT,
    @type nvarchar = NULL
AS
BEGIN

    WITH p AS (SELECT top (@number) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id, id AS pid
           FROM people.Personen
           WHERE (ABS(CHECKSUM(id)) % 100) < 20),
     a as (SELECT top (@number) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id, id AS aid
           FROM locations.Adresse
           WHERE (ABS(CHECKSUM(id)) % 100) < 6)
    INSERT INTO people.PersonenAdressen (personId, adresseId, typeId)
    SELECT pid, aid, IIF(@type IS NULL, NULL, (SELECT id FROM locations.AdressenTyp WHERE adressenTyp = @type))
    FROM p JOIN a ON p.id = a.id;

END;
GO

CREATE PROCEDURE people.GeneratePersonenAdressen
AS
BEGIN

    EXEC people.InsertRandomPersonenAdressen 100000, 'privat';
    EXEC people.InsertRandomPersonenAdressen 100000;

    update people.PersonenAdressen
    set typeId = (select top (1) id from locations.AdressenTyp where adressenTyp = N'geschäftlich')
    where personId in
      (select personId from people.PersonenAdressen group by personId having count(personId) > 1)
      and typeId IS NULL;

    -- Denke über den möglichen Zustand der Tabelle nach. Welche Auswirkungen können die einzelnen
    -- Schritte haben?
    -- Was sollte der Zweck der Prozedur sein? 

END;
GO

CREATE PROCEDURE GenerateDatabaseData
AS
BEGIN
    EXEC people.GenerateNames;
    EXEC people.GenerateDiverseGenders;
    EXEC people.GenerateRandomBirthdaysForAge18_70;

    EXEC locations.GenerateOrte;
    EXEC locations.GenerateAddress;
    EXEC people.GeneratePersonenAdressen;
END;
GO

EXEC dbo.LoadStaticDataIntoTables;
EXEC dbo.LoadCsvDataIntoTemporaryTables;
EXEC dbo.GenerateDatabaseData;
GO

