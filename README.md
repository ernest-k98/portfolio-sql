# Portfolio SQL — Bank Marketing Dataset

**Krótko:** Zestaw zapytań SQL analizujących Bank Marketing Dataset (Kaggle). Celem jest pokazanie umiejętności:
- segmentacja klientów (wiek, zawód, stan cywilny),
- agregacje i miary biznesowe (skuteczność kampanii, średni balans),
- przygotowanie widoków i użycie CTE,
- podstawowe przygotowanie do raportowania (eksport CSV, wykresy).

## Co zawiera repozytorium
- `sql/analizy.sql` — wszystkie zapytania ze skomentowanymi wnioskami.
- `sql/create_view.sql` — przykład CREATE VIEW `Klienci_segmentacja`.
- `data/` — przykładowe wyniki (CSV) z zapytań.
- `images/` — wykresy i zrzuty ekranu.
- `raport.pdf` — krótki raport z wnioskami (opcjonalnie).

## Jak odtworzyć
1. Pobierz dataset (Bank Marketing dataset z Kaggle) i wgraj do bazy `dbo.bank`.
2. Wykonaj skrypty z `sql/` w SQL Server (SSMS/Azure Data Studio).
3. Wyniki możesz eksportować do CSV i użyć Power BI / Excel do wizualizacji.

## Najważniejsze wnioski (skrót)
- Najwyższa skuteczność kampanii: _studenci_ (74,72%).
- Najlepsze miesiące na kampanie: _Kwiecień–Sierpień_.
- Grupa o najwyższym średnim saldzie częściej zakłada lokaty.
- Single w wieku 26-35 to grupa, która najchętniej zakłada lokaty.

## Kontakt
[Ernest Krzysik] — www.linkedin.com/in/ernest-krzysik-55257b167 / ernest.krzysik@onet.pl
