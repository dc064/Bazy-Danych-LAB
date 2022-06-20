/* Skrypt wykona�: Dawid Chmielewski, nr indeksu 311188 GR1 */

USE Baza2
GO

/* Jak nie ma tabeli CECHY to j� tworzymy */
IF NOT EXISTS
( SELECT *
FROM sysobjects o
WHERE (o.[name] = N'CECHY')
AND (OBJECTPROPERTY(o.[ID], N'IsUserTable')=1)
)
BEGIN
CREATE TABLE dbo.cechy
( kod nchar(4) NOT NULL CONSTRAINT PK_Cechy PRIMARY KEY
, opis nvarchar(40) NOT NULL
)
END

GO

/* Wstawiamy 10 r�znych cech - poni�ej przyk�ad jak wstawi� jedn� */
DECLARE @kod nchar(4)
SET @kod = N'SUP'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Super')
/* i tak pozosta�e 9 cech */

/* Wstawiam reszt� cech. W tworzeniu ka�dej pos�uguj� si� zmienn� @kod, kt�rej przy ka�dej cesze
** podstawiam inne warto�ci: */

GO

DECLARE @kod nchar(4)
/* 2 */
SET @kod = N'DU�'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Du�e')

/* 3 */
SET @kod = N'STO'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Stolica')

/* 4 */
SET @kod = N'MA�'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Ma�e')

/* 5 */
SET @kod = N'WJW'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Wojew�dzkie')

/* 6 */
SET @kod = N'CZY'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Czyste')

/* 7 */
SET @kod = N'MOR'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Nad morzem')

/* 8 */
SET @kod = N'CIK'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Ciekawe')

/* 9 */
SET @kod = N'ODR'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Nad Odr�')

/* 10 */
SET @kod = N'WIS'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Nad Wis��')

SELECT * FROM cechy c
/*
kod  opis
---- ----------------------------------------
CZY  Czyste
DU�  Du�e
MA�  Ma�e
MOR  Nad morzem
ODR  Nad Wis��
STO  Stolica
SUP  Super
WIS  Nad Wis��
WJW  Wojew�dzkie

(9 row(s) affected)

Wstawia�em cechy hurtowo, wi�c declare @kod przed ka�d� cech� z osobna nie by� potrzebny
*/


/* Tworzymy relacj� Cechy -> Miasta czyli tabel� Cechy_miasta */
IF NOT EXISTS
( SELECT *
FROM sysobjects o
WHERE (o.[name] = N'CECHY_Miasta')
AND (OBJECTPROPERTY(o.[ID], N'IsUserTable')=1)
)
BEGIN
CREATE TABLE dbo.cechy_Miasta
( kod nchar(4) NOT NULL CONSTRAINT FK_Cechy_Miasta__Cechy
FOREIGN KEY REFERENCES Cechy(kod)
, id_miasta nchar(3) /* w przypadku mojej bazy */
NOT NULL CONSTRAINT FK_Cechy_Miasta__Miasta
FOREIGN KEY REFERENCES Miasta(id_miasta)
, CONSTRAINT PK_Cechy_Miasta PRIMARY KEY (kod,id_miasta)
)
END

GO

/* wstawiamy wielu firmom cechy, 3-em po 4, 3-em po 2, 2um po jednej */

/* poni�ej przyk�ad jednego przypisania */
DECLARE @id nchar(3), @kod nchar(4)
SET @id = 'WAR'
SET @kod = N'STO'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

GO
DECLARE @id nchar(3), @kod nchar(4)
SET @id = 'WAR'
SET @kod = N'DU�'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'WAR'
SET @kod = N'WIS'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'WAR'
SET @kod = N'WJW'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'WRO'
SET @kod = N'DU�'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'WRO'
SET @kod = N'WJW'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'WRO'
SET @kod = N'ODR'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'WRO'
SET @kod = N'SUP'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDA'
SET @kod = N'WJW'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDA'
SET @kod = N'MOR'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDA'
SET @kod = N'DU�'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDA'
SET @kod = N'CIK'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'CIE'
SET @kod = N'SUP'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'CIE'
SET @kod = N'CZY'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'DZI'
SET @kod = N'CIK'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'DZI'
SET @kod = N'MA�'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDY'
SET @kod = N'MOR'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDY'
SET @kod = N'DU�'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'JEL'
SET @kod = N'SUP'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'HEL'
SET @kod = N'MOR'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

/*
select * from cechy

kod  opis
---- ----------------------------------------
CIK  Ciekawe
CZY  Czyste
DU�  Du�e
MA�  Ma�e
MOR  Nad morzem
ODR  Nad Wis��
STO  Stolica
SUP  Super
WIS  Nad Wis��
WJW  Wojew�dzkie

(10 row(s) affected)

select * from cechy_Miasta
order BY id_miasta

kod  id_miasta
---- ---------
CZY  CIE
SUP  CIE
CIK  DZI
MA�  DZI
MOR  GDA
DU�  GDA
CIK  GDA
WJW  GDA
DU�  GDY
MOR  GDY
MOR  HEL
SUP  JEL
WJW  WAR
STO  WAR
WIS  WAR
DU�  WAR
DU�  WRO
ODR  WRO
WJW  WRO
SUP  WRO

(20 row(s) affected)

*/


/* 1. Pokazac miasta maj�ce 3 zadane cechy - musz� mie� wszystkie
** Any lepiej zaprezentowa� dzia�anie skryptu, dodam jeszcze cech� ciekawe do Wroc�awia i Warszawy.
** Dzi�ki temu program powinien pokaza� trzy miasta */

DECLARE @id nchar(3), @kod nchar(4)
SET @id = 'WRO'
SET @kod = N'CIK'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'WAR'
SET @kod = N'CIK'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

/* SELECT * FROM Cechy_miasta

kod  id_miasta
---- ---------
CIK  DZI
CIK  GDA
CIK  WAR
CIK  WRO
CZY  CIE
DU�  GDA
DU�  GDY
DU�  WAR
DU�  WRO
MA�  DZI
MOR  GDA
MOR  GDY
MOR  HEL
ODR  WRO
STO  WAR
SUP  CIE
SUP  JEL
SUP  WRO
WIS  WAR
WJW  GDA
WJW  WAR
WJW  WRO

*/

/* DROP TABLE #tt */

CREATE TABLE #tt (id_cechy nchar(4) NOT NULL)
INSERT INTO #tt (id_cechy) VALUES (N'CIK')
INSERT INTO #tt (id_cechy) VALUES (N'DU�')
INSERT INTO #tt (id_cechy) VALUES (N'WJW')


SELECT m.*, X.[ile cech] 
	FROM miasta m
	join (SELECT mW.id_miasta, COUNT(*) AS [ile cech]
			FROM miasta mW
			join Cechy_miasta cw	ON (mW.id_miasta = cw.id_miasta)
			join #tt tW			ON (tW.id_cechy = cw.kod)
			GROUP BY mW.id_miasta
			HAVING
				COUNT(*) = 3
		) X ON (m.id_miasta = X.id_miasta)

/*

id_miasta kod_woj nazwa                ile cech
--------- ------- -------------------- -----------
GDA       POM     Gda�sk               3
WAR       MAZ     Warszawa             3
WRO       DOL     Wroc�aw              3

(3 row(s) affected)

Te trzy miasta maj� cechy, kt�re zada�em w tabeli tymczasowej #tt
*/


/* Pokaza� miasta maj�ce conajmniej 2 cechy spo�r�d zadanyc
    w kolejnosci od tych z najwi�ksz� ilo�ci� cech zgodnych 

** Do tej pory nie mam w bazie miasta, kt�re spe�nia�oby tylko dwie cechy
** spo�r�d tych w tabeli #tt. Dlatego, by wynik by� reprezentatywny, dodam
** cech� du�e do Dzier�oniowa. */

DECLARE @id nchar(3), @kod nchar(4)
SET @id = 'DZI'
SET @kod = N'DU�'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

/* Teraz zapytanie */
SELECT m.*, X.[ile cech] 
	FROM miasta m
	join (SELECT mW.id_miasta, COUNT(*) AS [ile cech]
			FROM miasta mW
			join Cechy_miasta cw	ON (mW.id_miasta = cw.id_miasta)
			join #tt tW			ON (tW.id_cechy = cw.kod)
			GROUP BY mW.id_miasta
			HAVING
				COUNT(*) >= 2
		) X ON (m.id_miasta = X.id_miasta)
ORDER BY X.[ile cech] DESC

/*

id_miasta kod_woj nazwa                ile cech
--------- ------- -------------------- -----------
GDA       POM     Gda�sk               3
WAR       MAZ     Warszawa             3
WRO       DOL     Wroc�aw              3
DZI       DOL     Dzier�oni�w          2

(4 row(s) affected)

*/


/* Pokaza� miasta maj�ce co najmniej jak�� cech� z zadanych
** w kolejnosci od tych z najwi�ksz� ilo�ci� cech zgodnych */

SELECT m.*, X.[ile cech] 
	FROM miasta m
	join (SELECT mW.id_miasta, COUNT(*) AS [ile cech]
			FROM miasta mW
			join Cechy_miasta cw	ON (mW.id_miasta = cw.id_miasta)
			join #tt tW			ON (tW.id_cechy = cw.kod)
			GROUP BY mW.id_miasta
			HAVING
				COUNT(*) >= 1
		) X ON (m.id_miasta = X.id_miasta)
ORDER BY X.[ile cech] DESC

/* 
id_miasta kod_woj nazwa                ile cech
--------- ------- -------------------- -----------
GDA       POM     Gda�sk               3
WAR       MAZ     Warszawa             3
WRO       DOL     Wroc�aw              3
DZI       DOL     Dzier�oni�w          2
GDY       POM     Gdynia               1

(5 row(s) affected)
*/

/*
Pokaza�, kt�re miasta maj� najwi�cej przypisanych cech
4.1 stworzy� tabel� tymczasowa id_miasta, liczba_cech
*/
SELECT m.nazwa, X.[ile cech]
INTO #t2
FROM MIASTA M
JOIN ( SELECT cW.id_miasta, COUNT(*) AS [ile cech]
	   FROM cechy_Miasta cW
	   GROUP BY cW.id_miasta
	   ) X on (M.id_miasta = X.id_miasta )

/*
Testuj�, czy dobrze zrobi�em tabel�:
select * from #t2

nazwa                ile cech
-------------------- -----------
Ciechan�w            2
Dzier�oni�w          3
Gda�sk               4
Gdynia               2
Hel                  1
Jelenia G�ra         1
Warszawa             5
Wroc�aw              5

(8 row(s) affected)

*/

select MAX(c.[ile cech]) From #t2 c

/*

-----------
5

(1 row(s) affected)


Szukamy miasta/miast, kt�re ma 5 cech */

SELECT m.*, X.[ile cech] 
	FROM miasta m
	join (SELECT mW.id_miasta, COUNT(*) AS [ile cech]
			FROM miasta mW
			join Cechy_miasta cw	ON (mW.id_miasta = cw.id_miasta)
			GROUP BY mW.id_miasta
			HAVING
				COUNT(*) =  (select MAX(c.[ile cech]) FROM #t2 c)

		) X ON (m.id_miasta = X.id_miasta)

/*

id_miasta kod_woj nazwa                ile cech
--------- ------- -------------------- -----------
WAR       MAZ     Warszawa             5
WRO       DOL     Wroc�aw              5

(2 row(s) affected)

Najwi�cej cech maj� Warszawa i Wroc�aw */


/*
    Z miast znajduj�cych si� w wojew�dztwie XX (kod wybrac samemu)
    zrobi� to samo co w punkcie 4)


Wybra�em kod DOL (Dolno�l�skie)
*/

SELECT m.nazwa, m.kod_woj, X.[ile cech]
INTO #t4
FROM MIASTA M
JOIN ( SELECT cW.id_miasta, COUNT(*) AS [ile cech]
	   FROM cechy_Miasta cW
	   GROUP BY cW.id_miasta
	   ) X on (M.id_miasta = X.id_miasta )
WHERE M.kod_woj = 'DOL'

/*
Sprawdzam, czy w tabeli #t4 s� tylko miasta z dolno�l�skiego:

select * from #t4

nazwa                kod_woj ile cech
-------------------- ------- -----------
Dzier�oni�w          DOL     3
Jelenia G�ra         DOL     1
Wroc�aw              DOL     5

(3 row(s) affected)

Doda�em tutaj kolumn� kod_woj, aby w dalszym zapytaniu �atwiej by�o u�y� tej tabeli.

*/

SELECT m.nazwa, X.[ile cech] 
	FROM #t4 m
	join (SELECT mW.nazwa, COUNT(*) AS [ile cech]
			FROM miasta mW
			join Cechy_miasta cw	ON (mW.id_miasta = cw.id_miasta)
			GROUP BY mW.nazwa
			HAVING
				COUNT(*) =  (select MAX(c.[ile cech]) FROM #t4 c)

		) X ON (m.nazwa = X.nazwa)

/*

nazwa                ile cech
-------------------- -----------
Wroc�aw              5

(1 row(s) affected)

*/

/* Skrypt wykona�: Dawid Chmielewski 
nr indeksu 311188
GR1
*/