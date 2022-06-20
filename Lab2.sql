USE Baza1
GO

/* Zadanie 1. 
WK z tabeli ETATY wybra� id_firmy, stanowisko
oraz kolumny
(jezeli ilo�� znak�w w STANOWISKO > id_firmy 'ST'
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
Wyk�adowca           PW       ST    *
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

WW pokozac etaty i w jakich firmach s� (oraz 1sza litera imienia i nazwisko osoby)
tylko stanowiska typu Prezes dyrektor Kierownik
i tylko pensja pomiedzy 1000 a 10000
i tylko OSOBY mieszkaj�ce w WOJ o nazwie Maz%
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


Nic nie spe�nia w mojej bazie tych kryteri�w.
*/



/* Polecenie trzecie 

ILK
pokazac firmy z wojew�dztwa o kodzie MAZ (je�ei maj� pa�stwo inne to inne),
i osoby w nich pracuj�ce mieszkaj� w wojew�dztwie o o kodzie zaczynaj�cym si� na P )
Jak nie ma takich przypadk�w to doda� ze 2 do bazy

*/


/* Takich przypadk�w nie by�o- dodaj� nowe do bazy: */
INSERT INTO OSOBY (id_osoby,id_miasta, imie, nazwisko, adres)
VALUES(20, 'GDY', 'Karolina', 'Wojciechowska', 'ul. D�uga 16')INSERT INTO ETATY ( id_etatu, id_osoby, id_firmy, stanowisko, pensja, od)
VALUES (24, 20, 'LGE', 'Konsultant', 4000, CONVERT(datetime, '20110106', 112))
INSERT INTO OSOBY (id_osoby,id_miasta, imie, nazwisko, adres)
VALUES(21, 'GDY', 'Adam', 'Domaga�a', 'ul. D�uga 41')INSERT INTO ETATY ( id_etatu, id_osoby, id_firmy, stanowisko, pensja, od)
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
CD Projekt RED                                                                                       Programista          Adam                 Domaga�a                       POM

(2 row(s) affected)


*/

GO 

/* Polecenie czwarte */

/* Jaka jest najmniejsza pensja wsr�d firm z miast o nazwie zaczynaj�cej si� od W
(kto,w jakiej firmie, od kiedy i na jakim stanowsisku, kod WOJ zwi�zany z Firm�) */

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
Alicja               G�owacka                       2016-02-06 00:00:00.000 Programista          MAZ       WAR       2000,00

(1 row(s) affected)

*/

/* Polecenie pi�te

Pokazac ilo�c os�b w wojew�dztwie o kodzie na liter� M

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

Sprawdz� samodzielnie, czy na pewno tyle jest- zobacz� ca�e wiersze z tymi osobami i sam je policz�.
W ten spos�b dowiem si�, czy wynik jest dobry:

select o.imie, o.nazwisko, o.id_miasta, m.kod_woj
FROM osoby o, miasta m
WHERE (m.id_miasta = o.id_miasta)
AND (m.kod_woj LIKE 'M%')

Wynik:

imie                 nazwisko                       id_miasta kod_woj
-------------------- ------------------------------ --------- -------
Jan                  Kowalski                       WAR       MAZ
Filip                Koz�owski                      WAR       MAZ
Dominika             Wysocka                        WAR       MAZ
Dawid                Zieli�ski                      WAR       MAZ
Zofia                Zieli�ska                      WAR       MAZ
Marek                Koz�owski                      CIE       MAZ
Maja                 Ko�akowska                     CIE       MAZ
Rados�aw             Mr�wka                         P�O       MAZ
Julia                Ma�ecka                        PRZ       MAZ
Karol                Kowalski                       WAR       MAZ

(10 row(s) affected)


Takich os�b jest 10, wobec tego wynik si� zgadza.
*/

/* Polecenie sz�ste

Pokazac w ilu roznych miastach s� OSOBY (liczb� takich miast)
, liczb� wszystkich os�b i najwi�ksze ID_OSOBY

*/

/* W ilu r�nych miastach s� osoby.
Najpierw stworz� tabel� pomocnicz� #t1 z miastami, kt�re maj� jakiekolwiek osoby.
Potem zlicz� ilo�� wierszy z tej w�a�nie tabeli */

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
1           P�O
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

10 os�b- czylii tyle, ile wierszy w #t1. Wynik si� zgadza */

/* Liczba wszystkich os�b: */

SELECT COUNT (*) FROM osoby o

/*


-----------
21

(1 row(s) affected)

21 os�b- tyle jest w mojej bazie
(W �wiczeniu 1 doda�em 19, w tym- kolejne 2, do podpunktu trzeciego)

Teraz najwy�sze ID osoby. Numerowa�em osoby po kolei bez pomijania �adnego numeru, wi�c program powinien r�wnie� tutaj wy�wietli� 21:
*/

SELECT MAX(o.id_osoby)
FROM osoby o

/*


-----------
21

(1 row(s) affected)


21 - tyle te� jest wszystkich os�b, wi�c najwy�sze ID si� zgadza


Skrypt wykona�: Dawid Chmielewski GR1, nr indeksu 311188 */