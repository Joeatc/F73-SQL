use myTestDb;
go

create schema people;
go

create schema locations;
go

create table people.Geschlecht
(
    id         uniqueidentifier default newid() primary key,
    geschlecht NVARCHAR(30),
    gender     NVARCHAR(30)
)

create table locations.AdressenTyp
(
    id          uniqueidentifier default newid() primary key,
    adressenTyp NVARCHAR(20),
    addressType NVARCHAR(20)
)

create table locations.Land
(
    id      uniqueidentifier default newid() primary key,
    land    NVARCHAR(50),
    country NVARCHAR(50)
)

create table locations.Ort
(
    id    uniqueidentifier default newid() primary key,
    ort   NVARCHAR(100),
    place NVARCHAR(100),
    plz   NVARCHAR(5),
    zip   NVARCHAR(10)
)

create table people.Personen
(
    id           uniqueidentifier default newid() primary key,
    name         NVARCHAR(100),
    vorname      NVARCHAR(100),
    geburtstag   DATETIME2(7),
    steuerId     NVARCHAR(30),
    geschlechtId uniqueidentifier,

    foreign key (geschlechtId) references people.Geschlecht(id)
)

create table locations.Adresse
(
    id           uniqueidentifier default newid() primary key,
    landId       uniqueidentifier,
    ortId        uniqueidentifier,
    strasse      NVARCHAR(100),
    hausnummer   NVARCHAR(10),
    adresszusatz NVARCHAR(100),
    c_o          NVARCHAR(100),

    foreign key (landId) references locations.Land(id),
    foreign key (ortId) references locations.Ort(id)
)

create table people.PersonenAdressen
(
    id        uniqueidentifier default newid() primary key,
    personId  uniqueidentifier,
    adresseId uniqueidentifier,
    von       DATETIME2(7),
    bis       DATETIME2(7),
    typeId    uniqueidentifier,

    foreign key (personId) references people.Personen(id),
    foreign key (adresseId) references locations.Adresse(id),
    foreign key (typeId) references locations.AdressenTyp(id)
)
