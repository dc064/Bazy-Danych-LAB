/* Skrypt wykona³: Dawid Chmielewski, nr indeksu 311188 GR1 */

USE Baza2
GO

/* Jak nie ma tabeli CECHY to j¹ tworzymy */
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

/* Wstawiamy 10 róznych cech - poni¿ej przyk³ad jak wstawiæ jedn¹ */
DECLARE @kod nchar(4)
SET @kod = N'SUP'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Super')
/* i tak pozosta³e 9 cech */

/* Wstawiam resztê cech. W tworzeniu ka¿dej pos³ugujê siê zmienn¹ @kod, której przy ka¿dej cesze
** podstawiam inne wartoœci: */

GO

DECLARE @kod nchar(4)
/* 2 */
SET @kod = N'DU¯'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Du¿e')

/* 3 */
SET @kod = N'STO'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Stolica')

/* 4 */
SET @kod = N'MA£'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Ma³e')

/* 5 */
SET @kod = N'WJW'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Wojewódzkie')

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
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Nad Odr¹')

/* 10 */
SET @kod = N'WIS'
IF NOT EXISTS (SELECT * FROM cechy c WHERE c.kod = @kod )
INSERT INTO cechy (kod, opis) VALUES (@kod, N'Nad Wis³¹')

SELECT * FROM cechy c
/*
kod  opis
---- ----------------------------------------
CZY  Czyste
DU¯  Du¿e
MA£  Ma³e
MOR  Nad morzem
ODR  Nad Wis³¹
STO  Stolica
SUP  Super
WIS  Nad Wis³¹
WJW  Wojewódzkie

(9 row(s) affected)

Wstawia³em cechy hurtowo, wiêc declare @kod przed ka¿d¹ cech¹ z osobna nie by³ potrzebny
*/


/* Tworzymy relacjê Cechy -> Miasta czyli tabelê Cechy_miasta */
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

/* poni¿ej przyk³ad jednego przypisania */
DECLARE @id nchar(3), @kod nchar(4)
SET @id = 'WAR'
SET @kod = N'STO'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

GO
DECLARE @id nchar(3), @kod nchar(4)
SET @id = 'WAR'
SET @kod = N'DU¯'

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
SET @kod = N'DU¯'

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
SET @kod = N'DU¯'

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
SET @kod = N'MA£'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDY'
SET @kod = N'MOR'

IF NOT EXISTS ( SELECT * FROM cechy_Miasta c WHERE c.id_miasta = @id AND c.kod = @kod)
INSERT INTO cechy_Miasta(id_miasta, kod) VALUES (@id, @kod)

SET @id = 'GDY'
SET @kod = N'DU¯'

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
DU¯  Du¿e
MA£  Ma³e
MOR  Nad morzem
ODR  Nad Wis³¹
STO  Stolica
SUP  Super
WIS  Nad Wis³¹
WJW  Wojewódzkie

(10 row(s) affected)

select * from cechy_Miasta
order BY id_miasta

kod  id_miasta
---- ---------
CZY  CIE
SUP  CIE
CIK  DZI
MA£  DZI
MOR  GDA
DU¯  GDA
CIK  GDA
WJW  GDA
DU¯  GDY
MOR  GDY
MOR  HEL
SUP  JEL
WJW  WAR
STO  WAR
WIS  WAR
DU¯  WAR
DU¯  WRO
ODR  WRO
WJW  WRO
SUP  WRO

(20 row(s) affected)

*/


/* 1. Pokazac miasta maj¹ce 3 zadane cechy - musz¹ mieæ wszystkie
** Any lepiej zaprezentowaæ dzia³anie skryptu, dodam jeszcze cechê ciekawe do Wroc³awia i Warszawy.
** Dziêki temu program powinien pokazaæ trzy miasta */

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
DU¯  GDA
DU¯  GDY
DU¯  WAR
DU¯  WRO
MA£  DZI
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
INSERT INTO #tt (id_cechy) VALUES (N'DU¯')
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
GDA       POM     Gdañsk               3
WAR       MAZ     Warszawa             3
WRO       DOL     Wroc³aw              3

(3 row(s) affected)

Te trzy miasta maj¹ cechy, które zada³em w tabeli tymczasowej #tt
*/


/* Pokazaæ miasta maj¹ce conajmniej 2 cechy spoœród zadanyc
    w kolejnosci od tych z najwiêksz¹ iloœci¹ cech zgodnych 

** Do tej pory nie mam w bazie miasta, które spe³nia³oby tylko dwie cechy
** spoœród tych w tabeli #tt. Dlatego, by wynik by³ reprezentatywny, dodam
** cechê du¿e do Dzier¿oniowa. */

DECLARE @id nchar(3), @kod nchar(4)
SET @id = 'DZI'
SET @kod = N'DU¯'

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
GDA       POM     Gdañsk               3
WAR       MAZ     Warszawa             3
WRO       DOL     Wroc³aw              3
DZI       DOL     Dzier¿oniów          2

(4 row(s) affected)

*/


/* Pokazaæ miasta maj¹ce co najmniej jak¹œ cechê z zadanych
** w kolejnosci od tych z najwiêksz¹ iloœci¹ cech zgodnych */

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
GDA       POM     Gdañsk               3
WAR       MAZ     Warszawa             3
WRO       DOL     Wroc³aw              3
DZI       DOL     Dzier¿oniów          2
GDY       POM     Gdynia               1

(5 row(s) affected)
*/

/*
Pokazaæ, które miasta maj¹ najwiêcej przypisanych cech
4.1 stworzyæ tabelê tymczasowa id_miasta, liczba_cech
*/
SELECT m.nazwa, X.[ile cech]
INTO #t2
FROM MIASTA M
JOIN ( SELECT cW.id_miasta, COUNT(*) AS [ile cech]
	   FROM cechy_Miasta cW
	   GROUP BY cW.id_miasta
	   ) X on (M.id_miasta = X.id_miasta )

/*
Testujê, czy dobrze zrobi³em tabelê:
select * from #t2

nazwa                ile cech
-------------------- -----------
Ciechanów            2
Dzier¿oniów          3
Gdañsk               4
Gdynia               2
Hel                  1
Jelenia Góra         1
Warszawa             5
Wroc³aw              5

(8 row(s) affected)

*/

select MAX(c.[ile cech]) From #t2 c

/*

-----------
5

(1 row(s) affected)


Szukamy miasta/miast, które ma 5 cech */

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
WRO       DOL     Wroc³aw              5

(2 row(s) affected)

Najwiêcej cech maj¹ Warszawa i Wroc³aw */


/*
    Z miast znajduj¹cych siê w województwie XX (kod wybrac samemu)
    zrobiæ to samo co w punkcie 4)


Wybra³em kod DOL (Dolnoœl¹skie)
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
Sprawdzam, czy w tabeli #t4 s¹ tylko miasta z dolnoœl¹skiego:

select * from #t4

nazwa                kod_woj ile cech
-------------------- ------- -----------
Dzier¿oniów          DOL     3
Jelenia Góra         DOL     1
Wroc³aw              DOL     5

(3 row(s) affected)

Doda³em tutaj kolumnê kod_woj, aby w dalszym zapytaniu ³atwiej by³o u¿yæ tej tabeli.

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
Wroc³aw              5

(1 row(s) affected)

*/

/* Skrypt wykona³: Dawid Chmielewski 
nr indeksu 311188
GR1
*/