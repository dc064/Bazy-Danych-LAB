USE Baza2
GO

/*
Skrypt wykona³: Dawid Chmielewski, nr indeksu 311188, GR1 
Bazy Danych, zadanie 4.
*/

/*
Z4.1 Napisac procedurê szukaj_bez (@nazwa nvarchar(40) )

Która zwróci lsitê osob z nazw¹ miasta i wojewóztwa
Ale tylko tych w którzy nigdy nie pracowali w firmie
o nazwie @nazwa
*/

IF NOT EXISTS 
( SELECT 1
	FROM sysobjects o 
	WHERE	(OBJECTPROPERTY(o.[ID], N'IsProcedure') = 1)
	AND		(o.[name] = 'szukaj_bez')
)
BEGIN
	DECLARE @command nvarchar(100) 
	SET @command = N'CREATE PROCEDURE dbo.szukaj_bez AS SELECT ''hello world'' '
	EXEC sp_sqlexec @command
END

GO
ALTER PROCEDURE dbo.szukaj_bez (@nazwa nvarchar(40))
AS
DECLARE CC INSENSITIVE CURSOR FOR
	SELECT o.id_osoby FROM OSOBY o ORDER BY 1
DECLARE @i int
OPEN CC
FETCH NEXT FROM CC INTO @i
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS ( SELECT * FROM ETATY e, FIRMY f WHERE e.id_osoby = @i AND e.id_firmy = f.id_firmy AND f.nazwa = @nazwa )
		SELECT o.imie, o.nazwisko, m.nazwa AS [miasto], w.nazwa AS [nazwa woj]
		FROM OSOBY o, MIASTA m, WOJ w
		WHERE (o.id_miasta = m.id_miasta)
		AND (w.kod_woj = m.kod_woj)
		AND o.id_osoby = @i
	FETCH NEXT FROM CC INTO @i
END
CLOSE CC
DEALLOCATE CC

GO
DECLARE @nazwa nvarchar(40)
SET @nazwa = 'LG Electronics'


EXEC dbo.szukaj_bez @nazwa

/*
Wynik procedury dla firmy LG Electronics:

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Jan                  Kowalski                       Warszawa             Mazowieckie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Dominika             Wysocka                        Warszawa             Mazowieckie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Wincenty             Chmielewski                    Gdynia               Pomorskie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Aneta                Piekarz                        Jelenia Góra         Dolnoœl¹skie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Marek                Nowak                          Wroc³aw              Dolnoœl¹skie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Kamila               Nowak                          Wroc³aw              Dolnoœl¹skie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Zofia                Zieliñska                      Warszawa             Mazowieckie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Piotr                Zaj¹c                          Hel                  Pomorskie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Marcelina            Zaj¹c                          Hel                  Pomorskie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Kamil                Œlimak                         Wroc³aw              Dolnoœl¹skie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Maja                 Ko³akowska                     Ciechanów            Mazowieckie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Alicja               Maciejak                       Gdañsk               Pomorskie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Alicja               G³owacka                       Lublin               Lubelskie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Julia                Ma³ecka                        Przasnysz            Mazowieckie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Karol                Kowalski                       Warszawa             Mazowieckie

(1 row(s) affected)

imie                 nazwisko                       miasto               nazwa woj
-------------------- ------------------------------ -------------------- --------------------
Adam                 Domaga³a                       Gdynia               Pomorskie

(1 row(s) affected)

*/

/*

Z4.2
Napisaæ procedurê, która dla parametru @kod_woj wypisze

Listê miast (nazwa miasta, nazwa woj
, srednia pensja akt , max pensja akt
, liczba etatów aktualnych, liczba ludzi pracuj¹cych

*/

IF NOT EXISTS 
( SELECT 1
	FROM sysobjects o 
	WHERE	(OBJECTPROPERTY(o.[ID], N'IsProcedure') = 1)
	AND		(o.[name] = 'zad2')
)
BEGIN
	DECLARE @command nvarchar(100) 
	SET @command = N'CREATE PROCEDURE dbo.zad2 AS SELECT ''hello world'' '
	EXEC sp_sqlexec @command
END

GO


ALTER PROCEDURE dbo.zad2 (@kod_woj nvarchar(4))
AS
SELECT m.nazwa, w.nazwa AS [wojewodztwo], A.[srednia pensja], B.[maksymalna pensja], C.[aktualne etaty], D.[pracujace osoby] 
FROM MIASTA m
JOIN WOJ w ON (w.kod_woj = @kod_woj AND m.kod_woj = w.kod_woj)
JOIN (
SELECT ma.nazwa, AVG(ea.pensja) AS [srednia pensja]
FROM ETATY ea, FIRMY fa, MIASTA ma
WHERE (ea.id_firmy = fa.id_firmy)
AND (fa.id_miasta = ma.id_miasta)
AND (ea.do is null)
GROUP BY ma.nazwa 
) A ON (A.nazwa = m.nazwa)
JOIN (
SELECT mb.nazwa, MAX(eb.pensja) AS [maksymalna pensja]
FROM ETATY eb, FIRMY fb, MIASTA mb
WHERE (eb.id_firmy = fb.id_firmy)
AND (fb.id_miasta = mb.id_miasta)
AND (eb.do is null)
GROUP BY mb.nazwa
) B on (B.nazwa = m.nazwa)
JOIN (
SELECT mc.nazwa, COUNT(*) AS [aktualne etaty]
FROM ETATY ec, FIRMY fc, MIASTA mc
WHERE (ec.id_firmy = fc.id_firmy)
AND (fc.id_miasta = mc.id_miasta)
AND (ec.do is null)
GROUP BY mc.nazwa
) C ON (C.nazwa = m.nazwa)
JOIN (
SELECT md.nazwa,  COUNT(ed.id_osoby) AS [pracujace osoby] /*COUNT(DISTINCT e.id_osoby) AS [ile osob pracuje]*/
FROM ETATY ed, FIRMY fd, MIASTA md
WHERE (ed.id_firmy = fd.id_firmy)
AND (fd.id_miasta = md.id_miasta)
AND (ed.do is null)
GROUP BY md.nazwa
) D on (D.nazwa = m.nazwa)



DECLARE @kod_woj nvarchar(4)
SET @kod_woj = 'MAZ'

EXEC dbo.zad2 @kod_woj

/*
Przyk³ad wywo³ania procedury dla województwa Mazowieckiego (kod MAZ)

nazwa                wojewodztwo          srednia pensja        maksymalna pensja     aktualne etaty pracujace osoby
-------------------- -------------------- --------------------- --------------------- -------------- ---------------
Ciechanów            Mazowieckie          4000,00               4000,00               2              2
P³ock                Mazowieckie          2600,00               2600,00               1              1
Warszawa             Mazowieckie          7316,6666             24000,00              9              9

(3 row(s) affected)

*/

/*
Skrypt wykona³: Dawid Chmielewski, nr indeksu 311188, GR1 
*/