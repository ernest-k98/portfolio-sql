select *
from dbo.bank;



--- Podzia� klient�w ze wzgl�du na zaw�d i informacja czy maj� po�yczk�
SELECT 
    job AS Zaw�d, 
    CASE loan WHEN 'no' THEN 'Nie' ELSE 'Tak' END AS Ma_pozyczk�,
    COUNT(*) AS Liczba_klient�w
FROM dbo.bank
GROUP BY job, loan
ORDER BY Zaw�d, Ma_pozyczk�;

---Zapytanie mia�o na celu sprawdzi�, kt�ra grupa zawodowa klient�w najch�tniej decyduj� si� na po�yczk� - spo�r�d wszystkich s� to przedsi�biorcy (entrepreneur), praktycznie co 5ty przedsi�biorca decyduj� si� na po�yczk� (21,34%)



--- Klienci, z kt�rymi bank jeszcze si� nie kontaktowa�
SELECT 
    balance AS �redni_roczny_balans, 
    CASE loan WHEN 'no' THEN 'Nie' ELSE 'Tak' END AS Ma_pozyczk�,
    CASE housing WHEN 'no' THEN 'Nie' ELSE 'Tak' END AS Ma_kredyt_hipoteczny
FROM dbo.bank
WHERE deposit = 'no' AND pdays = -1
ORDER BY CAST(balance AS INT) DESC;


--- Zapytanie pokazuje klient�w z najwy�szym �rednim balansem, z kt�rymi nie kontaktowali�my si� jeszcze z ofert� lokaty. Ukazuje r�wnie� czy dany klient ma inne zobowi�zania w formie po�yczki/kredytu hipotecznego. 
--- Klienci z wysokim �rednim balansem i brakiem zobowi�za� mog� by� potencjalnym odbiorc� oferty.


--- Ilu klient�w zdecydowa�o si� na lokat� w poszczeg�lnych grupach wiekowych
with Grupy_wiekowe as(
SELECT 
    CASE 
        WHEN age < 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 59 THEN '46-59'
        ELSE '60+'
    END AS Przedzia�_wiekowy, 
    deposit
FROM dbo.bank
)
SELECT Przedzia�_wiekowy, COUNT(*) as L_klientow
FROM Grupy_wiekowe
WHERE deposit = 'yes'
GROUP BY Przedzia�_wiekowy
ORDER BY Przedzia�_wiekowy;

--- Zapytanie ukazuj�ce tendencj�, w jakim wieku klienci najch�tniej decyduj� si� na za�o�enie lokaty, umo�liwiaj�ce wybranie potencjalnej grupy odbiorc�w ze wzgl�du na wiek.
--- Klienci w przedziale wiekowym 26-35 stanowi� najwi�ksz� grupe odbiorc�w.



--- �redni balans dla klient�w z lokat� i bez
SELECT deposit AS Lokata, 
    AVG(cast(balance as int)) as '�redni_balans'
FROM dbo.bank
GROUP BY deposit;

--- Szybkie zapytanie ukazuj�ce, �e grupa os�b decyduj�cych si� na za�o�enie lokaty ma wy�szy �redni roczny balans.


--- Skuteczno�� kampanii marketingowej wg zawodu
SELECT 
    job AS Zaw�d,
	concat(cast(
    COUNT(CASE WHEN deposit='yes' THEN 1 END) * 100.0 / COUNT(*) as decimal(5,2)),'%') AS Skuteczno��_proc
FROM dbo.bank
GROUP BY job
ORDER BY Skuteczno��_proc DESC;

--- Zapytanie ukazuje, kt�ra grupa zawodowa decyduje si� najch�tniej na oferowan� przez bank lokat�, najwi�ksz� skuteczno�ci� odznacza si� kampania w�r�d student�w.

--- Ile uda�o si� pozyska� klient�w w ka�dym miesi�cu
SELECT
    CASE month 
        WHEN 'jan' THEN 'Stycze�'
        WHEN 'feb' THEN 'Luty'
        WHEN 'mar' THEN 'Marzec'
        WHEN 'apr' THEN 'Kwiecie�'
        WHEN 'may' THEN 'Maj'
        WHEN 'jun' THEN 'Czerwiec'
        WHEN 'jul' THEN 'Lipiec'
        WHEN 'aug' THEN 'Sierpie�'
        WHEN 'sep' THEN 'Wrzesie�'
        WHEN 'oct' THEN 'Pa�dziernik'
        WHEN 'nov' THEN 'Listopad'
        WHEN 'dec' THEN 'Grudzie�'
    END AS Miesi�c,
    COUNT(*) AS Liczba_klient�w
FROM dbo.bank
WHERE deposit = 'yes'
GROUP BY month
ORDER BY CASE month
        WHEN 'jan' THEN 1 WHEN 'feb' THEN 2 WHEN 'mar' THEN 3 WHEN 'apr' THEN 4
        WHEN 'may' THEN 5 WHEN 'jun' THEN 6 WHEN 'jul' THEN 7 WHEN 'aug' THEN 8
        WHEN 'sep' THEN 9 WHEN 'oct' THEN 10 WHEN 'nov' THEN 11 WHEN 'dec' THEN 12
    END;
---Zapytanie ukazuje liczb� klient�w decyduj�cych si� na za�o�enie lokaty z podzia�em na miesi�ce w kolejno�ci od Stycznia do Grudnia.

--- Top 5 miesi�cy pod wzgl�dem liczby pozyskanych klient�w
SELECT TOP 5
    CASE month 
        WHEN 'jan' THEN 'Stycze�'
        WHEN 'feb' THEN 'Luty'
        WHEN 'mar' THEN 'Marzec'
        WHEN 'apr' THEN 'Kwiecie�'
        WHEN 'may' THEN 'Maj'
        WHEN 'jun' THEN 'Czerwiec'
        WHEN 'jul' THEN 'Lipiec'
        WHEN 'aug' THEN 'Sierpie�'
        WHEN 'sep' THEN 'Wrzesie�'
        WHEN 'oct' THEN 'Pa�dziernik'
        WHEN 'nov' THEN 'Listopad'
        WHEN 'dec' THEN 'Grudzie�'
    END AS Miesi�c,
    COUNT(*) AS Liczba_klient�w
FROM dbo.bank
WHERE deposit = 'yes'
GROUP BY month
ORDER BY Liczba_klient�w DESC;
--- Wyci�gni�cie z wcze�niejszego zapytania 5 miesi�cy z najwy�sz� liczb� pozyskanych klient�w (lokaty). 
--- Wniosek: najbardziej udanym okresem na przeprowadzenie kampanii jest okres od Kwietnia do Sierpnia.


-- Ilu klient�w za�o�y�o lokat� w podziale na wiek i stan cywilny
with Klienci_przedzial as(
select 
    CASE 
        WHEN age < 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 59 THEN '46-59'
        ELSE '60+'
    END AS Przedzia�_wiekowy,
    marital AS Stan_cywilny,
	deposit
FROM dbo.bank
)
SELECT Przedzia�_wiekowy, Stan_cywilny, COUNT(*) AS Liczba_klientow
FROM Klienci_przedzial
WHERE deposit ='yes'
GROUP BY Przedzia�_wiekowy, Stan_cywilny
ORDER BY Przedzia�_wiekowy, Stan_cywilny;


--- Zapytanie maj�ce na celu ukazanie wielowymiarowej segmentacji klient�w.


