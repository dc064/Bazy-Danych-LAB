USE Baza1
GO

/* Zadanie 1. 
WK z tabeli ETATY wybraæ id_firmy, stanowisko
oraz kolumny
(jezeli iloœæ znaków w STANOWISKO > id_firmy 'ST'
w przeciwnym razie 'ID'),
(jezeli STANOWSIKO zaczyna sie na 'P' piszemy 'P', jak na 'D' piszemy 'D',
w innych przypadkach piszemy '*') (funkcja LEN(kolumna) zwraca ilosc znakow */

GO
SELECT 
e.stanowisko, 
e.id_firmy,
CASE WHEN LEN(e.stanowisko) > LEN(id_firmy) THEN 'ST' ELSE 'ID' END AS 'ST/ID',
CASE WHEN LEFT(e.stanowisko, 1) = 'P' THEN 'P' WHEN LEFT(e.stanowisko, 1) = 'D' THEN 'D' ELSE '*' END AS '1. litera'
FROM etaty e

/* wynik polecenia:

stanowisko           id_firmy ST/ID 1. litera
-------------------- -------- ----- ---------
Doktorant            PW       ST    D
Wyk³adowca           PW       ST    *
Profesor uczelni     PW       ST    P
Starszy programista  LGE      ST    *
Programista          CDPR     ST    P
Instruktor           OWC      ST    *
Stolarz              ZSJ      ST    *
Ratownik             MOSJE    ST    *
Doradca klienta      VWW      ST    D
Serwisant            LGE      ST    *
Projektant           LGE      ST    P
Kelner               CPP      ST    *
Dyrektor hotelu      HHR      ST    D
Recepcjonistka       HHR      ST    *
Magazynier           SDG      ST    *
Serwisant            LGE      ST    *
Kelner               CPP      ST    *
Piekarz              PBU      ST    P
Piekarz              PBU      ST    P
Serwisant            LGE      ST    *
Kucharz              RKP      ST    *
Programista          CDPR     ST    P
Doktorant            PW       ST    D

(23 row(s) affected)

*/

GO

/* Polecenie 2

WW pokozac etaty i w jakich firmach s¹ (oraz 1sza litera imienia i nazwisko osoby)
tylko stanowiska typu Prezes dyrektor Kierownik
i tylko pensja pomiedzy 1000 a 10000
i tylko OSOBY mieszkaj¹ce w WOJ o nazwie Maz%
i tylko etaty zaczete po roku 2010 (funkcja YEAR(kolumna)

*/

SELECT 
CONVERT(nvarchar(4), LEFT(o.imie,1) + N'. ' + LEFT(o.nazwisko,1)) AS [inicjaly],
f.nazwa AS [nazwa_firmy],
e.pensja AS [pensja],
e.stanowisko AS [stanowisko]
FROM ETATY e, OSOBY o, FIRMY f, MIASTA m
WHERE (e.id_firmy = f.id_firmy)
AND (o.id_osoby = e.id_osoby)
AND (m.kod_woj LIKE '%MAZ')
AND (e.pensja > 1000)
AND (e.pensja < 10000)
AND (e.stanowisko LIKE 'Dyrektor%')
OR (e.stanowisko LIKE 'Kierownik%')
OR (e.stanowisko LIKE 'Prezes%')

/*

inicjaly nazwa_firmy                                                                                          pensja                stanowisko
-------- ---------------------------------------------------------------------------------------------------- --------------------- --------------------

(0 row(s) affected)


Nic nie spe³nia w mojej bazie tych kryteriów.
*/



/* Polecenie trzecie 

ILK
pokazac firmy z województwa o kodzie MAZ (je¿ei maj¹ pañstwo inne to inne),
i osoby w nich pracuj¹ce mieszkaj¹ w województwie o o kodzie zaczynaj¹cym siê na P )
Jak nie ma takich przypadków to dodaæ ze 2 do bazy

*/


/* Takich przypadków nie by³o- dodajê nowe do bazy: */
INSERT INTO OSOBY (id_osoby,id_miasta, imie, nazwisko, adres)
VALUES(20, 'GDY', 'Karolina', 'Wojciechowska', 'ul. D³uga 16')INSERT INTO ETATY ( id_etatu, id_osoby, id_firmy, stanowisko, pensja, od)
VALUES (24, 20, 'LGE', 'Konsultant', 4000, CONVERT(datetime, '20110106', 112))
INSERT INTO OSOBY (id_osoby,id_miasta, imie, nazwisko, adres)
VALUES(21, 'GDY', 'Adam', 'Domaga³a', 'ul. D³uga 41')INSERT INTO ETATY ( id_etatu, id_osoby, id_firmy, stanowisko, pensja, od)
VALUES (25, 21, 'CDPR', 'Programista', 8000, CONVERT(datetime, '20151112', 112))

GO
SELECT f.nazwa AS [nazwa firmy], e.stanowisko, o.imie, o.nazwisko, mo.kod_woj AS [woj_osoby]
FROM ETATY e, OSOBY o, FIRMY f, miasta mo /* miasta-osoby */, miasta mf /* miasta-firmy */
WHERE (e.id_osoby = o.id_osoby)
AND (e.id_firmy = f.id_firmy)
AND (o.id_miasta = mo.id_miasta)
AND (f.id_miasta = mf.id_miasta)
AND (mf.kod_woj = N'MAZ')
AND (mo.kod_woj LIKE N'P%')
AND YEAR(e.od) > 2010

/*

nazwa firmy                                                                                          stanowisko           imie                 nazwisko                       woj_osoby
---------------------------------------------------------------------------------------------------- -------------------- -------------------- ------------------------------ ---------
LG Electronics                                                                                       Konsultant           Karolina             Wojciechowska                  POM
CD Projekt RED                                                                                       Programista          Adam                 Domaga³a                       POM

(2 row(s) affected)


*/

GO 

/* Polecenie czwarte */

/* Jaka jest najmniejsza pensja wsród firm z miast o nazwie zaczynaj¹cej siê od W
(kto,w jakiej firmie, od kiedy i na jakim stanowsisku, kod WOJ zwi¹zany z Firm¹) */

SELECT o.imie, o.nazwisko, e.od, e.stanowisko, mf.kod_woj AS [woj firmy], f.id_miasta, pensja
FROM osoby o, etaty e, miasta mf, firmy f
WHERE
(e.id_osoby = o.id_osoby)
AND
(e.id_firmy = f.id_firmy)
AND
(mf.id_miasta = f.id_miasta)
AND
(mf.nazwa LIKE N'W%')
AND
(pensja = (SELECT MIN(pensja) FROM etaty e))

/*

imie                 nazwisko                       od                      stanowisko           woj firmy id_miasta pensja
-------------------- ------------------------------ ----------------------- -------------------- --------- --------- ---------------------
Alicja               G³owacka                       2016-02-06 00:00:00.000 Programista          MAZ       WAR       2000,00

(1 row(s) affected)

*/

/* Polecenie pi¹te

Pokazac iloœc osób w województwie o kodzie na literê M

*/

GO
SELECT COUNT(*) AS [ile_osob] 
FROM osoby o, miasta m
WHERE (o.id_miasta = m.id_miasta)
AND (m.kod_woj LIKE N'M%')

/* 
Wynik:

ile_osob
-----------
10

(1 row(s) affected)

Sprawdzê samodzielnie, czy na pewno tyle jest- zobaczê ca³e wiersze z tymi osobami i sam je policzê.
W ten sposób dowiem siê, czy wynik jest dobry:

select o.imie, o.nazwisko, o.id_miasta, m.kod_woj
FROM osoby o, miasta m
WHERE (m.id_miasta = o.id_miasta)
AND (m.kod_woj LIKE 'M%')

Wynik:

imie                 nazwisko                       id_miasta kod_woj
-------------------- ------------------------------ --------- -------
Jan                  Kowalski                       WAR       MAZ
Filip                Koz³owski                      WAR       MAZ
Dominika             Wysocka                        WAR       MAZ
Dawid                Zieliñski                      WAR       MAZ
Zofia                Zieliñska                      WAR       MAZ
Marek                Koz³owski                      CIE       MAZ
Maja                 Ko³akowska                     CIE       MAZ
Rados³aw             Mrówka                         P£O       MAZ
Julia                Ma³ecka                        PRZ       MAZ
Karol                Kowalski                       WAR       MAZ

(10 row(s) affected)


Takich osób jest 10, wobec tego wynik siê zgadza.
*/

/* Polecenie szóste

Pokazac w ilu roznych miastach s¹ OSOBY (liczbê takich miast)
, liczbê wszystkich osób i najwiêksze ID_OSOBY

*/

/* W ilu ró¿nych miastach s¹ osoby.
Najpierw stworzê tabelê pomocnicz¹ #t1 z miastami, które maj¹ jakiekolwiek osoby.
Potem zliczê iloœæ wierszy z tej w³aœnie tabeli */

GO

SELECT COUNT (o.id_miasta) AS [ile miast], o.id_miasta
INTO #t1
 FROM osoby o
 GROUP BY o.id_miasta

SELECT * FROM #t1
/*

ile miast   id_miasta
----------- ---------
2           CIE
1           GDA
3           GDY
2           HEL
1           JEL
1           LBL
1           P£O
1           PRZ
6           WAR
3           WRO

(10 row(s) affected)

*/

 SELECT COUNT (id_miasta)
 FROM #t1

 /*
 
-----------
10

(1 row(s) affected)

10 osób- czylii tyle, ile wierszy w #t1. Wynik siê zgadza */

/* Liczba wszystkich osób: */

SELECT COUNT (*) FROM osoby o

/*


-----------
21

(1 row(s) affected)

21 osób- tyle jest w mojej bazie
(W æwiczeniu 1 doda³em 19, w tym- kolejne 2, do podpunktu trzeciego)

Teraz najwy¿sze ID osoby. Numerowa³em osoby po kolei bez pomijania ¿adnego numeru, wiêc program powinien równie¿ tutaj wyœwietliæ 21:
*/

SELECT MAX(o.id_osoby)
FROM osoby o

/*


-----------
21

(1 row(s) affected)


21 - tyle te¿ jest wszystkich osób, wiêc najwy¿sze ID siê zgadza


Skrypt wykona³: Dawid Chmielewski GR1, nr indeksu 311188 */