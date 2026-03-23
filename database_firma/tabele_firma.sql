--tabele w postgreSQL

-- KRAJE
CREATE TABLE IF NOT EXISTS kraj (
  Kod char(2) NOT NULL PRIMARY KEY,
  Nazwa varchar(50) NOT NULL
);

INSERT INTO kraj VALUES ('AM','Armenia'),('AR','Argentina'),('AT','Austria'),('BA','Bosnia and Herzegovina'),('BD','Bangladesh'),('BG','Bulgaria'),('BR','Brazil'),('BS','Bahamas'),('BW','Botswana'),('BY','Belarus'),('CA','Canada'),('CI','Ivory Coast'),('CL','Chile'),('CM','Cameroon'),('CN','China'),('CO','Colombia'),('CR','Costa Rica'),('CU','Cuba'),('CZ','Czech Republic'),('DE','Germany'),('DO','Dominican Republic'),('EE','Estonia'),('FI','Finland'),('FR','France'),('GB','United Kingdom'),('GE','Georgia'),('GN','Guinea'),('GR','Greece'),('GU','Guam'),('HR','Croatia'),('HT','Haiti'),('HU','Hungary'),('ID','Indonesia'),('IL','Israel'),('IQ','Iraq'),('IR','Iran'),('IS','Iceland'),('JP','Japan'),('KR','South Korea'),('KZ','Kazakhstan'),('LK','Sri Lanka'),('LT','Lithuania'),('MA','Morocco'),('MK','Macedonia'),('ML','Mali'),('MM','Myanmar'),('MN','Mongolia'),('MX','Mexico'),('NA','Namibia'),('NG','Nigeria'),('NL','Netherlands'),('NO','Norway'),('PA','Panama'),('PE','Peru'),('PG','Papua New Guinea'),('PH','Philippines'),('PL','Poland'),('PS','Palestinian Territory'),('PT','Portugal'),('RS','Serbia'),('RU','Russia'),('SE','Sweden'),('SI','Slovenia'),('SY','Syria'),('TH','Thailand'),('TZ','Tanzania'),('UA','Ukraine'),('US','United States'),('VE','Venezuela'),('YE','Yemen'),('ZA','South Africa'),('ZW','Zimbabwe');

-- DZIAŁY
CREATE TABLE IF NOT EXISTS dzial (
  Kod char(3) NOT NULL PRIMARY KEY,
  Nazwa varchar(50) NOT NULL
);

INSERT INTO dzial VALUES ('BD1','Business Development'),('HR1','Human Resources'),('RD1','Research and Development');

-- ADRESY
CREATE TABLE IF NOT EXISTS adres (
  Id SERIAL PRIMARY KEY,
  Ulica varchar(50) DEFAULT NULL,
  Miejscowosc varchar(50) NOT NULL,
  KodPocztowy char(10) DEFAULT NULL,
  KrajKod char(2) NOT NULL REFERENCES kraj(Kod)
);


INSERT INTO adres (Id, Ulica, Miejscowosc, KodPocztowy, KrajKod) VALUES 
(1,'561 Fulton Place','Carrazeda de Ansiães','5140-058','PT'), (101,'853 Cascade Street','Tengah',NULL,'ID'),(201,'34121 Emmet Place','Barang',NULL,'ID'),(301,'77 Lakeland Park','Yelkhovka','446870','RU'),(401,'40 Kedzie Place','Diveyevo','607320','RU'),(501,'2 Susan Center','Xumu',NULL,'CN'),(601,'28930 Hintze Pass','Lantang',NULL,'CN'),(701,'553 Parkside Street','Biris Daja',NULL,'ID'),(801,'2721 Division Point','Bayan',NULL,'MN'),(901,'4133 Sunfield Junction','Norrtälje','761 31','SE'),(1001,'6596 Pennsylvania Point','Kulary','366606','RU'),(1101,'99 Summer Ridge Alley','Gravataí','94000-000','BR'),(1201,'671 Gateway Terrace','Sentul',NULL,'ID'),(1301,'2789 Coleman Junction','Bandeirantes','86360-000','BR'),(1401,'0 Little Fleur Circle','Fonte Boa','69670-000','BR'),(1501,'6178 Fieldstone Hill','Alajuelita','11001','CR'),(1601,'60 Northland Plaza','Otradnoye','187332','RU'),(1801,'3761 Colorado Place','Mambulo','4407','PH'),(1901,'9 Nobel Junction','Miyakonojo','889-1912','JP'),(2001,'41257 Kinsman Parkway','Palapye',NULL,'BW'),(2101,'81450 Artisan Court','Yinghua',NULL,'CN'),(2201,'825 Forest Dale Junction','Härnösand','871 60','SE'),(2301,'0 Mcbride Park','Jiaoshanhe',NULL,'CN'),(2401,'679 Crownhardt Court','Selorejo',NULL,'ID');

-- ODDZIAŁY
CREATE TABLE IF NOT EXISTS oddzial (
  Id SERIAL PRIMARY KEY,
  Nazwa varchar(50) NOT NULL,
  AdresId int NOT NULL REFERENCES adres(Id)
);

INSERT INTO oddzial (Id, Nazwa, AdresId) VALUES (1,'Susan Center',501),(11,'Lantang',601),(21,'Yinghua',2101),(31,'Mcbride Park HQ',2301);

-- PROJEKTY
CREATE TABLE IF NOT EXISTS projekt (
  Kod char(5) NOT NULL PRIMARY KEY,
  Nazwa varchar(50) NOT NULL,
  DataRoz timestamp NOT NULL,
  DataZak timestamp DEFAULT NULL
);

INSERT INTO projekt VALUES ('BM727','envisioneer interactive communities','2023-03-03',NULL),('CDL50','extend customized mindshare','2022-10-23',NULL),('ICR30','cultivate B2C infrastructures','2022-07-01','2023-01-22'),('IRT35','transform compelling relationships','2022-05-31',NULL),('PZE22','aggregate bricks-and-clicks mindshare','2023-01-15',NULL),('YW477','innovate dynamic action-items','2022-09-04','2022-12-16');

-- PRACOWNIK
CREATE TABLE IF NOT EXISTS pracownik (
  Imie varchar(50) DEFAULT NULL,
  Nazwisko varchar(50) NOT NULL,
  Id SERIAL PRIMARY KEY,
  KierownikId int DEFAULT NULL REFERENCES pracownik(Id),
  DzialKod char(3) DEFAULT NULL REFERENCES dzial(Kod),
  OddzialId int DEFAULT NULL REFERENCES oddzial(Id),
  AdresId int DEFAULT NULL REFERENCES adres(Id),
  SamochodId int DEFAULT NULL 
);

INSERT INTO pracownik (Imie, Nazwisko, Id, KierownikId, DzialKod, OddzialId, AdresId, SamochodId) VALUES 
('Alva','Dalgleish',1,NULL,'BD1',31,1,1),('Nicky','Spencley',40,1,'BD1',11,101,3),('Braden','Moult',41,40,'HR1',11,201,NULL),('Carline','Forsdike',42,40,'RD1',11,301,10),('Cecily','Robus',43,40,'RD1',11,401,7),('Terry','Blowin',44,1,'BD1',21,701,NULL),('Rockey','Balsdone',45,1,'HR1',31,801,4),('Tremain','Hartland',46,1,'RD1',31,901,NULL),('Newton','Weatherhogg',47,40,'RD1',11,1001,NULL),('Doro','Sloyan',48,40,'RD1',11,1101,8),('Lianna','Renbold',49,40,'RD1',11,1201,11),('Bruis','Gillease',50,1,'RD1',31,1301,2),('Louise','MacArthur',51,1,'RD1',31,1401,NULL),('Jacobo','Blemen',52,44,'RD1',21,1501,NULL),('Tonia','Jeanes',53,44,'HR1',21,1601,6),('Gina','Calderbank',54,1,'BD1',21,1801,NULL),('Merci','Bolino',55,40,'HR1',1,1901,12),('Roddie','Gerrit',56,44,'RD1',1,2001,5),('Web','Lamport',57,44,'RD1',1,2201,NULL),('Shannon','Kruschov',58,40,'RD1',1,2401,9);

-- SAMOCHOD
CREATE TABLE IF NOT EXISTS samochod (
  Id SERIAL PRIMARY KEY,
  Marka varchar(20) NOT NULL,
  Model varchar(30) DEFAULT NULL,
  NrRejestr char(10) NOT NULL,
  PracownikId int DEFAULT NULL REFERENCES pracownik(Id)
);

INSERT INTO samochod (Id, Marka, Model, NrRejestr, PracownikId) VALUES 
(1,'Ferrari','599 GTB Fiorano','NL 5498F',1),(2,'Ford','E350','SF K371V',50),(3,'Ferrari','458 Italia','NW U992P',40),(4,'Chrysler','Concorde','IX A013B',45),(5,'Pontiac','6000','CO C453G',56),(6,'GMC','Savana 2500','YJ S033P',53),(7,'Toyota','Solara','OS C1952',43),(8,'Jeep','Patriot','PY Z328P',48),(9,'Chevrolet','Malibu','BM U559A',58),(10,'Honda','Civic','WN 3468K',42),(11,'Toyota','Camry','QJ X428I',49),(12,'Infiniti','FX','VD 67247',55),(13,'Lexus','IS300','PL A4469',NULL),(14,'Mazda','3','WR 8853Z',NULL),(15,'Mitsubishi','Colt','ZG V666X',NULL),(16,'Fiat','Punto','DW 77041',NULL);

-- PRZYPISANIE PROJEKTÓW
CREATE TABLE IF NOT EXISTS projekt_pracownik (
  ProjektKod char(5) NOT NULL REFERENCES projekt(Kod),
  PracownikId int NOT NULL REFERENCES pracownik(Id),
  PRIMARY KEY (ProjektKod, PracownikId)
);

INSERT INTO projekt_pracownik VALUES ('BM727',1),('IRT35',1),('CDL50',40),('YW477',40),('CDL50',42),('CDL50',43),('BM727',44),('ICR30',44),('PZE22',44),('BM727',45),('BM727',46),('YW477',47),('YW477',48),('YW477',49),('IRT35',50),('IRT35',51),('ICR30',52),('ICR30',53),('PZE22',53),('IRT35',54),('ICR30',56),('PZE22',56),('ICR30',57);
