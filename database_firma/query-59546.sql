--postgreSQL
--zad1
SELECT UPPER(LEFT(imie, 1)) || '.' || nazwisko AS osoba
FROM pracownik
ORDER BY nazwisko;

--zad2
SELECT p.imie, p.nazwisko, a.Miejscowosc
FROM pracownik AS p
LEFT JOIN adres AS a
ON p.AdresId=a.Id
WHERE a.Miejscowosc LIKE 'B%';

--zad 3
SELECT p.imie, p.nazwisko, k.nazwisko
FROM pracownik p
JOIN dzial d
ON p.dzialkod = d.kod
JOIN pracownik k
ON p.kierownikId = k.Id
WHERE p.dzialkod = 'RD1';

--zad 4
SELECT p.imie, p.nazwisko, s.NrRejestr
FROM pracownik p
JOIN samochod s
ON s.pracownikId = p.Id
WHERE s.NrRejestr IS NOT NULL;

--zad 5
SELECT p.nazwa, COUNT(*) AS ilosc_pracownikow
FROM projekt p
JOIN projekt_pracownik as pp
ON pp.ProjektKod = p.kod
GROUP BY p.nazwa;

--zad 6
SELECT a.krajkod, COUNT(*) AS ilosc
FROM adres a
JOIN pracownik p
ON p.adresId = a.Id
GROUP BY a.krajkod;

--zad 7
SELECT p.imie, p.nazwisko, o.nazwa
FROM pracownik p
LEFT JOIN samochod s
ON s.pracownikId = p.Id
JOIN oddzial o
ON o.id=p.oddzialid
WHERE s.NrRejestr IS NULL;

--zad 8
SELECT DISTINCT pp.projektkod, k.nazwisko
FROM projekt_pracownik pp
JOIN pracownik p
ON p.id = pp.pracownikid
JOIN pracownik k
ON p.id = k.kierownikid;


--zad 9
SELECT DISTINCT p.dzialkod, a.miejscowosc
FROM pracownik p
JOIN oddzial o
ON o.id = p.oddzialid
JOIN adres a
ON a.id = o.adresid;

--zad 10
SELECT o.nazwa, s.marka, s.model, s.NrRejestr
FROM pracownik p
JOIN oddzial o
ON o.id = p.oddzialid
JOIN samochod s
ON s.id =p.samochodid

