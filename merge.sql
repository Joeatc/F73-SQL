set nocount on;
set quoted_identifier on;

set dateformat dmy;

drop table if exists #ContactSamples;
create table #ContactSamples
(
    ContactNo  VARCHAR(10) NOT NULL PRIMARY KEY,
    Salutation VARCHAR(4)  NOT NULL,
    Degree     VARCHAR(13),
    GivenName  VARCHAR(13) NOT NULL,
    FamilyName VARCHAR(14) NOT NULL,
    BirthDate  DATE,
    Street     VARCHAR(33) NOT NULL,
    PostCode   INTEGER     NOT NULL,
    City       VARCHAR(28) NOT NULL,
    Phone      VARCHAR(27),
    Mobile     VARCHAR(25),
    Fax        VARCHAR(27),
    EMail      VARCHAR(37)
);

MERGE INTO #ContactSamples t
USING (VALUES ('1', 'Frau', NULL, 'Hannegret', 'Eisermann', '14.7.1998', 'In der Loh', 24116, 'Kiel', '0431/28258037',
               NULL, NULL, 'hannegret-eisermann@net.none')
            , ('2', 'Herr', NULL, 'Otto', 'Grabbe', NULL, 'Neumarkt', 63584, 'Gründau', '06058.1432347',
               '0179 - 3274212', NULL, NULL)
            , ('3', 'Frau', NULL, 'Gerritdina', 'Werder', NULL, 'Kondstraße', 93346, 'Ihrlerstein', '09441/80084809',
               '0160/2408868', NULL, 'gerritdinawerder@internet.none')
            , ('4', 'Herr', NULL, 'Pascal', 'Tag', NULL, 'Am Bühl', 54655, 'Usch', '+49 6563-17375120',
               '0154 - 65 81 54 3', NULL, 'pascaltag@internet.none')
            , ('5', 'Herr', NULL, 'Gregor', 'Klimke', NULL, 'An den Linden', 66763, 'Dillingen', NULL, '0153/5607819',
               NULL, 'gregor-klimke@xyz.none')
            , ('6', 'Frau', NULL, 'Sybilla', 'Hofmeister', '8.3.1921', 'An der Leye', 67742, 'Ginsweiler', NULL,
               '0176 . 322 569 0', NULL, 'sybilla-1921@web.none')
            , ('7', 'Herr', NULL, 'Rasmus', 'Wien', NULL, 'Littardweg', 21147, 'Hausbruch', '+49 (0)40/87 22 79 40',
               NULL, NULL, 'rwien@net.none')
            , ('8', 'Frau', NULL, 'Elke', 'Kalina', NULL, 'Zum Heidchen', 19205, 'Rögnitz', '03886 969 140 96',
               '0156 . 4922819', NULL, 'e-kalina@email.none')
            , ('9', 'Frau', NULL, 'Hiltrun', 'Leininger', NULL, 'Am Steig', 55767, 'Meckenbach', NULL,
               '+49(0)162 . 281 793 3', NULL, 'hiltrun.@internet.none')
            , ('10', 'Herr', NULL, 'Hanshelmut', 'Adams', NULL, 'Ginsterheide', 47809, 'Krefeld', '02151/79366468',
               '0156/6179331', NULL, 'hadams@company.none')
            , ('11', 'Frau', NULL, 'Ingetrud', 'Reimers', NULL, 'In der Hube', 48346, 'Ostbevern',
               '+49(0)2532 54512034', '0171/471 283 1', NULL, 'i-reimers@web.none')
            , ('12', 'Herr', NULL, 'Englbert', 'Knieper', NULL, 'Langestück', 56820, 'Mesenich', '02671/46143563', NULL,
               NULL, 'englbertknieper@company.none')
            , ('13', 'Herr', NULL, 'Treufried', 'Lober', NULL, 'Lindenhof', 99718, 'Greußen', '03636/67175613', NULL,
               NULL, 'treufried-lober@domain.none')
            , ('14', 'Herr', 'Dr.', 'Constantin', 'Holzmann', NULL, 'Hindemithstr.', 19061, 'Schwerin', '0385/29754277',
               '0165/7746922', NULL, 'constantin.@net.none')
            , ('15', 'Frau', NULL, 'Annagret', 'Rösener', NULL, 'An der Wintermaar', 72072, 'Tübingen',
               '07071/47940099', '0161/9826757', '07071/17376669', 'annagret.roesener@spam.none')
            , ('16', 'Herr', NULL, 'Wichard', 'Löwe', NULL, 'Klosterecke', 85049, 'Ingolstadt', '+49 841 - 95258995',
               '+49 (0)168 - 31 45 53 8', NULL, 'w.loewe@domain.none')
            , ('17', 'Frau', NULL, 'Frigga', 'Harris', '6.6.1979', 'Hingbergstr.', 85283, 'Wolnzach', NULL,
               '0157/2772541', NULL, 'frigga.harris@mail.none')
            , ('18', 'Frau', NULL, 'Lotti', 'Blenk', '8.10.1957', 'Auf dem Köppel', 06128, 'Halle',
               '+49 (0) 345/73 56 71 78', '0166 / 287 978 4', NULL, 'lotti.blenk@spam.none')
            , ('19', 'Frau', NULL, 'Emmi', 'Linhart', '22.10.1952', 'Buddestraße', 95326, 'Kulmbach',
               '+499221/731 226 53', '+49 (0)175 / 4274420', NULL, 'emmi_52@xyz.none')
            , ('20', 'Frau', NULL, 'Annerose', 'Kaya', '18.6.1993', 'An der Schule', 03238, 'Gorden-Staupitz',
               '03533/78638073', '0161/1658286', NULL, 'annerose_1993@web.none')
            , ('21', 'Frau', NULL, 'Kathrin', 'Stollberg', NULL, 'Starzend', 25727, 'Krumstedt', NULL, '0172/6916567',
               NULL, 'kathrinstollberg@spam.none')
            , ('22', 'Frau', NULL, 'Viola', 'Hinck', '23.12.1911', 'Georgsweiler Straße', 54636, 'Hamm',
               '06569/99492682', '0160/4209755', NULL, 'viola-hinck@host.none')
            , ('23', 'Herr', NULL, 'Haimo', 'Brodersen', NULL, 'Zum Flothfeld', 80802, 'München', '+49(0)89/456 983 51',
               '+49 (0)167 - 6094241', '089.44645566', 'haimobrodersen@host.none')
            , ('24', 'Herr', NULL, 'Conner', 'Köcher', NULL, 'Lenzenstück', 44225, 'Dortmund', '0231/18463812',
               '0152/8021940', NULL, 'c-koecher@company.none')
            , ('25', 'Herr', NULL, 'German', 'Falck', NULL, 'Trierer Str.', 76891, 'Bruchweiler-Bärenbach',
               '06391/88628079', '0165/5399838', NULL, 'gfalck@private.none')
            , ('26', 'Herr', NULL, 'Bertwin', 'Doege', NULL, 'An der Alten Burg', 34621, 'Frielendorf',
               '05684/45936687', '0162/9980240', '05684/99701217', 'b.doege@email.none')
            , ('27', 'Herr', NULL, 'Eitelfritz', 'Stefani', NULL, 'Abteistraße', 51373, 'Leverkusen', '0214/58956601',
               '0155/8616653', NULL, 'eitelfritzstefani@host.none')
            , ('28', 'Herr', NULL, 'Friedhardt', 'Hoops', NULL, 'Isingort', 69257, 'Wiesenbach', NULL, NULL, NULL,
               'friedhardthoops@mail.none')
            , ('29', 'Herr', NULL, 'Ingobert', 'Holzhausen', NULL, 'Hemsener Weg', 40789, 'Monheim am Rhein',
               '02173 - 248 417', '+49166 / 22 47 08 2', NULL, 'ingobertholzhausen@spam.none')
            , ('30', 'Herr', NULL, 'Enrico', 'Streit', '2.9.1971', 'Katzenberger Weg', 47669, 'Wachtendonk',
               '02836/35365495', NULL, NULL, 'enrico_streit@domain.none')
            , ('31', 'Frau', NULL, 'Juli', 'Reich', '26.4.1998', 'Kaiserswerther Straße', 54655, 'Steinborn',
               '06563/94606871', '0156/5794746', NULL, 'juli_reich@domain.none')
            , ('32', 'Frau', NULL, 'Louise', 'Auer', '1.9.1991', 'Oberfeller Straße', 25421, 'Pinneberg',
               '04101/43475725', '0165/4347006', NULL, 'l_auer@web.none')
            , ('33', 'Frau', NULL, 'Kyra', 'Christoph', NULL, 'An der Kirche', 17166, 'Dahmen', NULL, '0176/4740393',
               NULL, 'k-christoph@private.none')
            , ('34', 'Herr', NULL, 'Hieronymus', 'Althaus', '2.4.1998', 'Rüdesheimer Strasse', 38524, 'Sassenburg',
               '05371/85014546', NULL, NULL, 'hieronymus.98@private.none')
            , ('35', 'Frau', NULL, 'Michaela', 'Brütting', NULL, 'Josef-Schauer-Straße', 92363, 'Breitenbrunn',
               '09495/75686558', '0176/8124800', NULL, 'm_bruetting@web.none')
            , ('36', 'Frau', NULL, 'Myrjam', 'Quack', NULL, 'Richelsberg', 56414, 'Weroth', '06435/80515275',
               '0151/4609774', NULL, 'myrjam-quack@email.none')
            , ('37', 'Frau', NULL, 'Hertraud', 'Powell', NULL, 'Antoniusweg', 56754, 'Roes', NULL,
               '+49 (0)174 . 65 74 49 3', NULL, 'hertraud@internet.none')
            , ('38', 'Herr', NULL, 'Ruppert', 'Mössner', '21.10.1977', 'Herbartstr.', 54341, 'Fell',
               '+49 (0) 6502 . 36 49 25 93', '0175 . 4266024', NULL, NULL)
            , ('39', 'Frau', NULL, 'Gunthild', 'Cerny', NULL, 'Bottroper Straße', 89613, 'Grundsheim', '07357/4419575',
               '0163/7083328', NULL, 'gunthild.cerny@mail.none')
            , ('40', 'Herr', 'Prof.', 'Christward', 'Kielmann', NULL, 'Wallheckenweg', 25335, 'Elmshorn',
               '04121/26972696', NULL, '04121/18535056', 'christward-kielmann@domain.none')
            , ('41', 'Frau', NULL, 'Josephine', 'Tetzlaff', NULL, 'Hinter der Hardt', 91799, 'Langenaltheim',
               '+49 9145 / 85 71 90 50', '0173.84 04 74 9', NULL, NULL)
            , ('42', 'Frau', NULL, 'Mathilde', 'Tillmann', NULL, 'Im Sall', 89551, 'Königsbronn', '07328/3185776',
               '0163/6316748', '07328/80799622', 'm-tillmann@mail.none')
            , ('43', 'Frau', NULL, 'Cläre', 'Grünert', '3.2.1921', 'Salzwedeler Straße', 86854, 'Amberg',
               '08241/24629206', NULL, NULL, 'claere_gruenert@xyz.none')
            , ('44', 'Herr', NULL, 'Follrich', 'Watermann', NULL, 'Jülicher Straße', 91355, 'Hiltpoltstein',
               '09192/50823702', '0175/8536963', '09192/45659747', NULL)
            , ('45', 'Herr', NULL, 'Tobias', 'Kammerer', NULL, 'Am Stockpiper', 24852, 'Sollerup', '+49 4609.67099124',
               '0163 - 184 392 3', NULL, 'tobias_kammerer@private.none')
            , ('46', 'Herr', NULL, 'Bertolt', 'Harris', NULL, 'Heidering', 09496, 'Marienberg', '03735/47686998',
               '0162/6682789', NULL, 'bertolt_harris@host.none')
            , ('47', 'Herr', NULL, 'Joachim', 'Zill', NULL, 'Rechbergweg', 08393, 'Dennheritz', '03764/60930965',
               '0157/3115858', NULL, 'joachim-@mail.none')
            , ('48', 'Herr', NULL, 'Friedberg', 'Bierbrauer', NULL, 'Hohlweg', 93158, 'Teublitz', '09471/15827196',
               '0157/7430899', NULL, 'friedberg.bierbrauer@private.none')
            , ('49', 'Frau', NULL, 'Notburga', 'Schneeweiß', NULL, 'Ennigerloher Straße', 34477, 'Berndorf',
               '05631/64642142', '0159/8738409', '05631/72452555', 'notburga_schneeweiss@email.none')
            , ('50', 'Herr', NULL, 'Carlo', 'Mutter', NULL, 'Leineweberstraße', 54533, 'Dierfeld', '06572/79867754',
               '0159/4018629', NULL, NULL)
            , ('51', 'Herr', NULL, 'Lars', 'Henke', NULL, 'Hemdener Weg', 07387, 'Lausnitz', NULL, '0154/1413307',
               '03671/40719880', 'lars_henke@email.none')
            , ('52', 'Frau', 'Dr.', 'Elgard', 'Mähler', NULL, 'In den Gruben', 35756, 'Mittenaar', '02772/20369653',
               '0163/6435550', NULL, 'elgardmaehler@private.none')
            , ('53', 'Herr', 'Dr.', 'Niklas', 'Schack', NULL, 'Horstmarer Landweg', 67744, 'Homberg', '06788/59251973',
               '0159/7628838', NULL, 'niklas_schack@internet.none')
            , ('54', 'Frau', NULL, 'Kristina', 'Owen', NULL, 'Kanzlerstraße', 82041, 'Oberhaching', '089/62947357',
               '0174/9682639', NULL, 'kristina-owen@internet.none')
            , ('55', 'Frau', NULL, 'Edeltraut', 'Tiemann', NULL, 'Kiesseestraße', 54636, 'Ehlenz', '06561/36036037',
               NULL, NULL, 'edeltraut-tiemann@mail.none')
            , ('56', 'Frau', NULL, 'Elfi', 'Klaus', '4.8.1973', 'Gerichtstraße', 57271, 'Hilchenbach', '02733/27633182',
               '0150/6811223', '02733/46470379', NULL)
            , ('57', 'Herr', NULL, 'Nikodem', 'Hutter', NULL, 'Habichtshöhe', 49838, 'Wettrup', '05909/16925082',
               '0168/4576306', NULL, 'nikodem_@domain.none')
            , ('58', 'Herr', NULL, 'Gunhard', 'Tischer', NULL, 'Steineckstraße', 65582, 'Aull', NULL, '0175/9598592',
               NULL, NULL)
            , ('59', 'Frau', NULL, 'Serafine', 'Haslbeck', '3.7.1938', 'Von-Ketteler-Str.', 91805, 'Polsingen',
               '09093/45207979', NULL, NULL, 'serafine_1938@spam.none')
            , ('60', 'Herr', NULL, 'Traugott', 'Brock', '25.1.1974', 'Radebeuler Hof', 77977, 'Rust', '07822/18982664',
               NULL, NULL, 't-brock@internet.none')
            , ('61', 'Herr', 'Prof.', 'Wendelin', 'Nuss', '10.7.1955', 'Horionstraße', 93053, 'Regensburg',
               '0941/74271693', '0167/4908104', NULL, 'wendelinnuss@xyz.none')
            , ('62', 'Frau', NULL, 'Emmi', 'Reisinger', '10.7.1963', 'Am Schorenberg', 56288, 'Bell', '06762/26971290',
               NULL, NULL, NULL)
            , ('63', 'Herr', NULL, 'Friedolin', 'Piontek', NULL, 'Fronstraße', 82008, 'Unterhaching', '089 81304415',
               '0150 . 48 46 00 9', NULL, 'friedolinpiontek@email.none')
            , ('64', 'Herr', NULL, 'Simpert', 'Streng', NULL, 'Richardstrasse', 87490, 'Haldenwang', '08304/96717958',
               '0178/4826063', NULL, 'simpert_streng@company.none')
            , ('65', 'Frau', NULL, 'Annetrude', 'Türke', NULL, 'Türmchenstrasse', 27404, 'Rhade', NULL, '0164/4410276',
               NULL, 'atuerke@xyz.none')
            , ('66', 'Frau', NULL, 'Kim', 'Hagelstein', '19.5.1914', 'Arberstraße', 61462, 'Königstein',
               '06174/69707339', '0166/7831772', NULL, 'kim-1914@company.none')
            , ('67', 'Frau', NULL, 'Effi', 'Francis', NULL, 'Wilhelm-Busch-Weg', 67435, 'Neustadt an der Weinstraße',
               NULL, '0174/4894054', '06321/12447403', 'effifrancis@email.none')
            , ('68', 'Herr', NULL, 'Maic', 'Heidrich', NULL, 'Rainstr.', 25884, 'Viöl', '04843/56079465',
               '0175/8462908', NULL, 'maic_heidrich@xyz.none')
            , ('69', 'Frau', NULL, 'Aloisia', 'Seidler', NULL, 'Mertener Str.', 65224, 'Taunusstein', NULL,
               '0166/2681330', NULL, NULL)
            , ('70', 'Herr', NULL, 'Gunfried', 'Pampel', NULL, 'Fürst-zu-Salm-Horstmar-Str.', 06231, 'Bad Dürrenberg',
               '03462/74769332', '0177/3253892', NULL, 'gunfried_pampel@net.none')
            , ('71', 'Herr', NULL, 'Otheinrich', 'Feustel', '4.7.1972', 'Mühlackerweg', 86637, 'Wertingen',
               '08272/15312518', '0174/1609648', NULL, 'otheinrich_feustel@private.none')
            , ('72', 'Herr', NULL, 'Otto', 'Kottmann', '14.7.1987', 'Berge', 01156, 'Dresden', NULL, '0159/2595894',
               '0351/49848502', 'otto-1987@net.none')
            , ('73', 'Frau', NULL, 'Centa', 'Kolter', NULL, 'Auf dem Hostert', 54673, 'Uppershausen', '06564/73776811',
               '0179/9480729', '06564/19228556', 'centa-kolter@xyz.none')
            , ('74', 'Herr', NULL, 'Volkhart', 'Mucha', '21.12.1958', 'Nikolaus-Ehlen-Str.', 55767, 'Hattgenstein',
               '06782/74252119', '0168/4190317', NULL, 'volkhart1958@web.none')
            , ('75', 'Herr', NULL, 'Fabio', 'Barton', NULL, 'Steinbachstr.', 99986, 'Oppershausen', '03601/15969674',
               '0172/3347863', NULL, NULL)
            , ('76', 'Herr', NULL, 'Knuth', 'Picht', NULL, 'Kirchberg', 54340, 'Pölich', '06502/51085012', NULL, NULL,
               'k.picht@mail.none')
            , ('77', 'Herr', NULL, 'Dominik', 'Brodbeck', NULL, 'Maximilian-Kolbe-Str.', 79312, 'Emmendingen',
               '07641/69754362', NULL, NULL, 'dominik-brodbeck@company.none')
            , ('78', 'Frau', NULL, 'Oslinde', 'Gajewski', '24.9.1999', 'Büchel', 93049, 'Regensburg', '0941/72395618',
               NULL, '0941/63628052', 'o1999@spam.none')
            , ('79', 'Herr', NULL, 'Ludger', 'Hempelmann', NULL, 'Zum Burgschemm', 25924, 'Emmelsbüll-Horsbüll',
               '04665 . 73948609', NULL, NULL, NULL)
            , ('80', 'Frau', NULL, 'Berit', 'Kleinschmidt', '18.9.1943', 'Dorstfelder Hellweg', 53539, 'Welcherath',
               '02692/60427775', '0175/4507540', NULL, 'berit_43@company.none')
            , ('81', 'Frau', NULL, 'Vreneli', 'Magiera', NULL, 'Löhstraße', 27404, 'Gyhum', '04286/87035523',
               '+49 (0)176-24 91 24 9', NULL, 'vrenelimagiera@private.none')
            , ('82', 'Frau', NULL, 'Florentine', 'Ellenberger', NULL, 'Gabelsbergerstr.', 67753, 'Einöllen',
               '06304/17390479', '0159/7217974', NULL, 'florentine-ellenberger@email.none')
            , ('83', 'Herr', NULL, 'Gerdt', 'Engels', '20.5.1982', 'Kappenberger Damm', 98716, 'Geraberg', NULL, NULL,
               NULL, NULL)
            , ('84', 'Frau', NULL, 'Sonnhild', 'Gierse', NULL, 'Zum Heidentempel', 33142, 'Büren', '02951.49451852',
               '0150.55 43 89 7', NULL, 'sonnhild_gierse@email.none')
            , ('85', 'Frau', NULL, 'Annarose', 'Loges', NULL, 'Kalbecker Strasse', 66484, 'Dietrichingen',
               '+49 6332-19035445', '+49 (0) 171-3661277', NULL, NULL)
            , ('86', 'Herr', 'Prof. Dr.', 'Bernhart', 'Balthasar', NULL, 'Wickers Immberg', 72414, 'Rangendingen',
               '07471/14895443', NULL, NULL, 'bernhart-@internet.none')
            , ('87', 'Frau', NULL, 'Ilsemarie', 'Freitag', NULL, 'Mathildenstraße', 90475, 'Nürnberg', NULL, NULL, NULL,
               'ilsemariefreitag@company.none')
            , ('88', 'Frau', NULL, 'Angelika', 'Kaster', NULL, 'Diesterwegstr.', 21037, 'Hamburg', NULL,
               '0173-601 082 3', NULL, 'angelika-kaster@spam.none')
            , ('89', 'Frau', NULL, 'Gerlinda', 'Lüddecke', NULL, 'Hasenkampstr.', 97645, 'Ostheim vor der Rhön',
               '09777/57822681', NULL, NULL, 'gerlinda.lueddecke@mail.none')
            , ('90', 'Herr', NULL, 'Berndt', 'Treichel', NULL, 'Auestr.', 89176, 'Asselfingen', '07345/24300278', NULL,
               NULL, 'berndttreichel@web.none')
            , ('91', 'Herr', NULL, 'Karlfried', 'Weidler', '28.4.1929', 'Wallensteinstraße', 35080, 'Bad Endbach',
               '+49 2776 991 649 16', '+49 (0) 168 - 7898318', NULL, NULL)
            , ('92', 'Herr', NULL, 'Arne', 'Feser', NULL, 'Nieland', 53913, 'Swisttal', '02226/208185', '0172/8467354',
               NULL, 'a_@internet.none')
            , ('93', 'Herr', 'Dr. Dr.', 'Hanskarl', 'Rasmussen', '26.7.1915', 'Etzweiler Straße', 25588, 'Huje', NULL,
               '0151/1488224', NULL, 'hanskarl.rasmussen@private.none')
            , ('94', 'Herr', NULL, 'Torsten', 'Zühlke', NULL, 'Wacholderweg', 97836, 'Bischbrunn', '09394/25106002',
               '0164/7719860', NULL, 'torstenzuehlke@mail.none')
            , ('95', 'Herr', NULL, 'Otbert', 'Schlicker', '12.12.1928', 'Am Kammrädchen', 93158, 'Teublitz',
               '09471/29374118', '0167/9620075', NULL, 'o.schlicker@company.none')
            , ('96', 'Frau', NULL, 'Linde', 'Büttgen', NULL, 'Hannes-Schufen-Str.', 94239, 'Ruhmannsfelden',
               '09929/17482117', NULL, NULL, 'l_buettgen@web.none')
            , ('97', 'Frau', NULL, 'Delia', 'Schoop', '17.8.1906', 'Wiehagener Straße', 56291, 'Lingerhahn',
               '06747/97890744', '0173/5883223', NULL, NULL)
            , ('98', 'Frau', NULL, 'Ilsebärbel', 'Thome', NULL, 'Estern', 34508, 'Willingen', '05632/5702100',
               '0155/5644673', '05632/88957288', NULL)
            , ('99', 'Frau', 'Dr. Dr.', 'Annedoris', 'Hartwich', NULL, 'Bahndamm', 73269, 'Hochdorf', NULL,
               '0152 / 3160211', NULL, NULL)
            , ('100', 'Herr', NULL, 'Ehrhard', 'Joos', NULL, 'Moorweg', 38170, 'Winnigstedt', '05332/21628585',
               '0157/3094461', NULL, 'ehrhard-joos@web.none'))
    as s (ContactNo, Salutation, Degree, GivenName, FamilyName, BirthDate, Street, PostCode, City, Phone, Mobile, Fax,
          EMail)
ON (t.ContactNo = s.ContactNo)
WHEN MATCHED THEN
    UPDATE
    SET t.Salutation=s.Salutation,
        t.Degree=s.Degree,
        t.GivenName=s.GivenName,
        t.FamilyName=s.FamilyName,
        t.BirthDate=s.BirthDate,
        t.Street=s.Street,
        t.PostCode=s.PostCode,
        t.City=s.City,
        t.Phone=s.Phone,
        t.Mobile=s.Mobile,
        t.Fax=s.Fax,
        t.EMail=s.EMail
WHEN NOT MATCHED THEN
    INSERT (ContactNo, Salutation, Degree, GivenName, FamilyName, BirthDate, Street, PostCode, City, Phone, Mobile, Fax,
            EMail)
    VALUES (s.ContactNo, s.Salutation, s.Degree, s.GivenName, s.FamilyName, s.BirthDate, s.Street, s.PostCode, s.City,
            s.Phone, s.Mobile, s.Fax, s.EMail);
