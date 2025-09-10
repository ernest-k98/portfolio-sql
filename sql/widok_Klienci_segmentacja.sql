--- Stworzenie widoku w celu szybszego dost�pu do danych klient�w
create view Klienci_segmentacja as
select 
	case
		WHEN age < 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 59 THEN '46-59'
        ELSE '60+' end as Przedzial_wiekowy,
		marital,
		job,
		balance,
		deposit
from dbo.bank;
--- Widok Klienci_segmentacja umo�liwia szybkie filtrowanie i raportowanie klient�w bez konieczno�ci ka�dorazowego tworzenia podzia�u wiekowego.

--- Przyk�ad wykorzystania powy�szego
select marital,job,balance,deposit
from Klienci_segmentacja
where CAST(balance as int)>5000;

---W przyk�adzie wybieram klient�w o saldzie powy�ej 5000, co pozwala np. zidentyfikowa� potencjalnych odbiorc�w ofert premium.