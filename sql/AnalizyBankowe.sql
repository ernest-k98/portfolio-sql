select *
from dbo.bank;



--- Podzia³ klientów ze wzglêdu na zawód i informacja czy maj¹ po¿yczkê
SELECT 
    job AS Zawód, 
    CASE loan WHEN 'no' THEN 'Nie' ELSE 'Tak' END AS Ma_pozyczkê,
    COUNT(*) AS Liczba_klientów
FROM dbo.bank
GROUP BY job, loan
ORDER BY Zawód, Ma_pozyczkê;

---Zapytanie mia³o na celu sprawdziæ, która grupa zawodowa klientów najchêtniej decydujê siê na po¿yczkê - spoœród wszystkich s¹ to przedsiêbiorcy (entrepreneur), praktycznie co 5ty przedsiêbiorca decydujê siê na po¿yczkê (21,34%)



--- Klienci, z którymi bank jeszcze siê nie kontaktowa³
SELECT 
    balance AS Œredni_roczny_balans, 
    CASE loan WHEN 'no' THEN 'Nie' ELSE 'Tak' END AS Ma_pozyczkê,
    CASE housing WHEN 'no' THEN 'Nie' ELSE 'Tak' END AS Ma_kredyt_hipoteczny
FROM dbo.bank
WHERE deposit = 'no' AND pdays = -1
ORDER BY CAST(balance AS INT) DESC;


--- Zapytanie pokazuje klientów z najwy¿szym œrednim balansem, z którymi nie kontaktowaliœmy siê jeszcze z ofert¹ lokaty. Ukazuje równie¿ czy dany klient ma inne zobowi¹zania w formie po¿yczki/kredytu hipotecznego. 
--- Klienci z wysokim œrednim balansem i brakiem zobowi¹zañ mog¹ byæ potencjalnym odbiorc¹ oferty.


--- Ilu klientów zdecydowa³o siê na lokatê w poszczególnych grupach wiekowych
with Grupy_wiekowe as(
SELECT 
    CASE 
        WHEN age < 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 59 THEN '46-59'
        ELSE '60+'
    END AS Przedzia³_wiekowy, 
    deposit
FROM dbo.bank
)
SELECT Przedzia³_wiekowy, COUNT(*) as L_klientow
FROM Grupy_wiekowe
WHERE deposit = 'yes'
GROUP BY Przedzia³_wiekowy
ORDER BY Przedzia³_wiekowy;

--- Zapytanie ukazuj¹ce tendencjê, w jakim wieku klienci najchêtniej decyduj¹ siê na za³o¿enie lokaty, umo¿liwiaj¹ce wybranie potencjalnej grupy odbiorców ze wzglêdu na wiek.
--- Klienci w przedziale wiekowym 26-35 stanowi¹ najwiêksz¹ grupe odbiorców.



--- Œredni balans dla klientów z lokat¹ i bez
SELECT deposit AS Lokata, 
    AVG(cast(balance as int)) as 'Œredni_balans'
FROM dbo.bank
GROUP BY deposit;

--- Szybkie zapytanie ukazuj¹ce, ¿e grupa osób decyduj¹cych siê na za³o¿enie lokaty ma wy¿szy œredni roczny balans.


--- Skutecznoœæ kampanii marketingowej wg zawodu
SELECT 
    job AS Zawód,
	concat(cast(
    COUNT(CASE WHEN deposit='yes' THEN 1 END) * 100.0 / COUNT(*) as decimal(5,2)),'%') AS Skutecznoœæ_proc
FROM dbo.bank
GROUP BY job
ORDER BY Skutecznoœæ_proc DESC;

--- Zapytanie ukazuje, która grupa zawodowa decyduje siê najchêtniej na oferowan¹ przez bank lokatê, najwiêksz¹ skutecznoœci¹ odznacza siê kampania wœród studentów.

--- Ile uda³o siê pozyskaæ klientów w ka¿dym miesi¹cu
SELECT
    CASE month 
        WHEN 'jan' THEN 'Styczeñ'
        WHEN 'feb' THEN 'Luty'
        WHEN 'mar' THEN 'Marzec'
        WHEN 'apr' THEN 'Kwiecieñ'
        WHEN 'may' THEN 'Maj'
        WHEN 'jun' THEN 'Czerwiec'
        WHEN 'jul' THEN 'Lipiec'
        WHEN 'aug' THEN 'Sierpieñ'
        WHEN 'sep' THEN 'Wrzesieñ'
        WHEN 'oct' THEN 'PaŸdziernik'
        WHEN 'nov' THEN 'Listopad'
        WHEN 'dec' THEN 'Grudzieñ'
    END AS Miesi¹c,
    COUNT(*) AS Liczba_klientów
FROM dbo.bank
WHERE deposit = 'yes'
GROUP BY month
ORDER BY CASE month
        WHEN 'jan' THEN 1 WHEN 'feb' THEN 2 WHEN 'mar' THEN 3 WHEN 'apr' THEN 4
        WHEN 'may' THEN 5 WHEN 'jun' THEN 6 WHEN 'jul' THEN 7 WHEN 'aug' THEN 8
        WHEN 'sep' THEN 9 WHEN 'oct' THEN 10 WHEN 'nov' THEN 11 WHEN 'dec' THEN 12
    END;
---Zapytanie ukazuje liczbê klientów decyduj¹cych siê na za³o¿enie lokaty z podzia³em na miesi¹ce w kolejnoœci od Stycznia do Grudnia.

--- Top 5 miesiêcy pod wzglêdem liczby pozyskanych klientów
SELECT TOP 5
    CASE month 
        WHEN 'jan' THEN 'Styczeñ'
        WHEN 'feb' THEN 'Luty'
        WHEN 'mar' THEN 'Marzec'
        WHEN 'apr' THEN 'Kwiecieñ'
        WHEN 'may' THEN 'Maj'
        WHEN 'jun' THEN 'Czerwiec'
        WHEN 'jul' THEN 'Lipiec'
        WHEN 'aug' THEN 'Sierpieñ'
        WHEN 'sep' THEN 'Wrzesieñ'
        WHEN 'oct' THEN 'PaŸdziernik'
        WHEN 'nov' THEN 'Listopad'
        WHEN 'dec' THEN 'Grudzieñ'
    END AS Miesi¹c,
    COUNT(*) AS Liczba_klientów
FROM dbo.bank
WHERE deposit = 'yes'
GROUP BY month
ORDER BY Liczba_klientów DESC;
--- Wyci¹gniêcie z wczeœniejszego zapytania 5 miesiêcy z najwy¿sz¹ liczb¹ pozyskanych klientów (lokaty). 
--- Wniosek: najbardziej udanym okresem na przeprowadzenie kampanii jest okres od Kwietnia do Sierpnia.


-- Ilu klientów za³o¿y³o lokatê w podziale na wiek i stan cywilny
with Klienci_przedzial as(
select 
    CASE 
        WHEN age < 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 59 THEN '46-59'
        ELSE '60+'
    END AS Przedzia³_wiekowy,
    marital AS Stan_cywilny,
	deposit
FROM dbo.bank
)
SELECT Przedzia³_wiekowy, Stan_cywilny, COUNT(*) AS Liczba_klientow
FROM Klienci_przedzial
WHERE deposit ='yes'
GROUP BY Przedzia³_wiekowy, Stan_cywilny
ORDER BY Przedzia³_wiekowy, Stan_cywilny;


--- Zapytanie maj¹ce na celu ukazanie wielowymiarowej segmentacji klientów.


