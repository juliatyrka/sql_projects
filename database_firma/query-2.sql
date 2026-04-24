--Lista 3
--zad1

CREATE SCHEMA IF NOT EXISTS firma;

ALTER TABLE kraj SET SCHEMA firma;
ALTER TABLE dzial SET SCHEMA firma;
ALTER TABLE adres SET SCHEMA firma;
ALTER TABLE oddzial SET SCHEMA firma;
ALTER TABLE projekt SET SCHEMA firma;
ALTER TABLE pracownik SET SCHEMA firma;
ALTER TABLE samochod SET SCHEMA firma;
ALTER TABLE projekt_pracownik SET SCHEMA firma;

CREATE OR REPLACE FUNCTION firma.pobierz_dane_pracownika_po_nazwisku(p_nazwisko VARCHAR)
RETURNS TABLE (
    imie VARCHAR,
    nazwisko VARCHAR,
    ulica VARCHAR,
    miejscowosc VARCHAR,
    kod_pocztowy CHAR(10),
    kraj_nazwa VARCHAR,
    nazwa_dzialu VARCHAR,
    nazwa_oddzialu VARCHAR
) 
AS $body$
BEGIN
    RETURN QUERY
    SELECT 
        p.Imie, 
        p.Nazwisko, 
        a.Ulica, 
        a.Miejscowosc, 
        a.KodPocztowy, 
        k.Nazwa AS kraj_nazwa,
        d.Nazwa AS nazwa_dzialu, 
        o.Nazwa AS nazwa_oddzialu
    FROM 
        firma.pracownik p
    LEFT JOIN firma.adres a ON p.AdresId = a.Id
    LEFT JOIN firma.kraj k ON a.KrajKod = k.Kod
    LEFT JOIN firma.dzial d ON p.DzialKod = d.Kod
    LEFT JOIN firma.oddzial o ON p.OddzialId = o.Id
    WHERE 
        p.Nazwisko = p_nazwisko;
END;
$body$ LANGUAGE plpgsql;

SELECT * 
FROM firma.pobierz_dane_pracownika_po_nazwisku('Dalgleish');

--Zad 2
CREATE OR REPLACE PROCEDURE firma.dodaj_pracownika(
    p_imie VARCHAR,
    p_nazwisko VARCHAR,
    p_kierownik_id INT,
    p_dzial_kod CHAR(3),
    p_oddzial_id INT,
    p_ulica VARCHAR,
    p_miejscowosc VARCHAR,
    p_kod_pocztowy CHAR(10),
    p_kraj_kod CHAR(2)
)
AS $body$
DECLARE 
	v_adres_id INT;
BEGIN
	INSERT INTO firma.adres(ulica, miejscowosc, kodpocztowy, krajkod)
	VALUES (p_ulica, p_miejscowosc, p_kod_pocztowy, p_kraj_kod)
	RETURNING id INTO v_adres_id;

	INSERT INTO firma.pracownik(imie, nazwisko, kierownikid, dzialkod, oddzialid, adresid, samochodid)
	VALUES (p_imie, p_nazwisko, p_kierownik_id, p_dzial_kod, p_oddzial_id, v_adres);

	RAISE NOTICE 'Dodano pracownika % % z adresem ID: %', p_imie, p_nazwisko, v_adres_id;

	EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Błąd! Szczegóły: %', SQLERRM;
END;
$body$ LANGUAGE plpgsql;

--Zad 3
CREATE OR REPLACE PROCEDURE firma.usun_pracownika(
	p_id INT
)
AS $body$
DECLARE
    v_adres_id INT;
BEGIN 
	SELECT adresid INTO v_adres_id FROM firma.pracownik WHERE id=p_id;

	UPDATE firma.samochod
	SET pracownikId = NULL
	WHERE pracownikId = p_id;

	DELETE from firma.pracownik
	WHERE id = p_id;

	IF v_adres_id IS NOT NULL THEN
		DELETE FROM firma.adres
		WHERE id = v_adres_id;
	END IF;

	RAISE NOTICE 'Pracownik o ID % oraz jego adres zostały usunięte. Samochód i projekty zostały odłączone.', p_id;
	EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Błąd podczas usuwania pracownika: %', SQLERRM;

END;
$body$ LANGUAGE plpgsql;

--Zad 4
CREATE OR REPLACE FUNCTION firma.liczba_pracownikow_dzialu(
	p_dzial_kod CHAR(3)
)
RETURNS INTEGER
AS $body$
    SELECT COUNT(*)::INTEGER
    FROM firma.pracownik
	WHERE dzialkod = p_dzial_kod;
$body$ LANGUAGE sql;

--Zad 5
CREATE OR REPLACE FUNCTION firma.czas_trwania_projektu(
	p_kod_projektu CHAR(5)
)
RETURNS INTEGER
AS $body$
DECLARE
    v_dni INTEGER;
BEGIN
	SELECT COALESCE(datazak::date, CURRENT_DATE) - dataroz::date
	INTO v_dni
	FROM firma.projekt
	WHERE p_kod_projektu = kod;

	RETURN v_dni;
END;
$body$ LANGUAGE plpgsql;

--Zad 6
CREATE OR REPLACE FUNCTION firma.dane_o_pracowniku(
	p_nazwisko CHAR(50)	
)
RETURNS TABLE (
	imie VARCHAR,
	nazwisko VARCHAR,
	ulica VARCHAR,
	miejscowosc VARCHAR,
	kod_pocztowy char(10),
	kraj VARCHAR,
	nazwa_dzialu VARCHAR,
	nazwa_oddzialu VARCHAR
)
AS $body$
BEGIN 
	RETURN QUERY
	SELECT p.imie, p.nazwisko, a.ulica, a.miejscowosc, a.kodpocztowy, k.nazwa, d.nazwa, o.nazwa
	FROM firma.pracownik p
	LEFT JOIN firma.adres a ON a.id = p.adresid
	LEFT JOIN firma.kraj k ON k.kod = a.krajkod
	LEFT JOIN firma.dzial d ON p.dzialkod = d.kod
	LEFT JOIN firma.oddzial o ON p.oddzialid = o.id
	WHERE p_nazwisko = p.nazwisko;
END;
$body$ LANGUAGE plpgsql;

--Zad 7
ALTER TABLE firma.pracownik 
ADD COLUMN DataUtworzenia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN DataModyfikacji TIMESTAMP;

CREATE OR REPLACE FUNCTION firma.pracownik_modyfikacja()
RETURNS TRIGGER AS $body$
BEGIN        
 NEW.DataModyfikacji = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$body$ LANGUAGE plpgsql;
