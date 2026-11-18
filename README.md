# Call Service Reporting with SQL

A compact SQLite learning example exploring call volumes, abandonment rates, and reporting quality. The business questions are inspired by telephone service operations.

## Project status and contribution

This is an AI-assisted starter project prepared for Marcelo Paez's SQL refresher. Marcelo selected the reporting context based on prior service-operations experience. The initial synthetic dataset, SQL, documentation, and verification runner were generated and executed with AI assistance. Independent query practice, interpretation, and extensions are planned as the next stage of learning.

## Business questions

1. How many calls arrived each month, and what proportion were abandoned?
2. How do volumes, abandonment rates, and recorded wait times compare across language groups?
3. How does abandonment change from one calendar month to the next?

The queries demonstrate `LEFT JOIN`, `GROUP BY`, `CASE`, `NULLIF`, common table expressions, and the `LAG` window function.

## Results at a glance

| Month | Calls | Answered | Abandoned | Abandonment rate |
| --- | --- | --- | --- | --- |
| August 2026 | 8 | 5 | 3 | 37.5% |
| September 2026 | 8 | 6 | 2 | 25.0% |
| October 2026 | 8 | 7 | 1 | 12.5% |
| November 2026 | 0 | 0 | 0 | N/A |

The constructed sample decreases by 12.5 percentage points in both September and October. November's empty period has an undefined rate. These deliberately chosen records demonstrate query behavior and support no conclusions about an actual organization's performance.

[View all verified report tables](RESULTS.md)

## Data and metric definitions

All 24 calls are synthetic. There are no employer, customer, or caller records. Each row represents one incoming call, with one language and an outcome of answered or abandoned. The simplified sample includes no transfers or calls still in progress.

| Table | Purpose |
| --- | --- |
| `calls` | Unique call ID, date, language ID, outcome, and optional wait in seconds |
| `service_languages` | One row per language, including a group with no calls |
| `reporting_months` | Consecutive months, including a month with no calls |

- Abandonment rate is `100 × abandoned calls / total incoming calls`.
- Monthly change is the current rate minus the preceding month's rate, in percentage points.
- Average wait covers all calls with a recorded wait, including answered and abandoned calls. Missing waits are excluded from the average and reflected in the coverage count.
- A zero-call month or language has an undefined rate, represented as SQL `NULL` and displayed as `N/A`.

One wait time is deliberately missing. Primary keys, foreign keys, and check constraints enforce basic integrity. The quality query also checks duplicate IDs, outcomes, negative waits, language references, and calendar coverage. Report totals are reconciled back to the 24 input records.

## Run the example

Use Python 3.8 or newer with SQLite 3.25 or newer. The runner uses only Python's standard library.

```sh
python run_reports.py
```

The runner creates a fresh in-memory database, executes all three reports and the quality query, checks expected results, and writes `RESULTS.md`. It can be rerun safely. Run it normally so Python assertions remain enabled.

To practice SQL directly, execute `schema_and_data.sql` once in a fresh SQLite database, then run each statement in `reports.sql` and `quality_checks.sql`. SQLite date functions may need adaptation for other SQL dialects.

## Files

- `schema_and_data.sql` — Tables, constraints, and inspectable synthetic records.
- `reports.sql` — Three commented reporting queries.
- `quality_checks.sql` — Data-quality summary.
- `run_reports.py` — Reproducible runner and expected-result checks.
- `RESULTS.md` — Generated output tables.

## Planned independent practice

- Explain why counting call IDs preserves zero-call months after a left join.
- Recreate the monthly report without consulting the solution.
- Add a month of synthetic records and predict the output before running it.
- Add a report for answered calls with waits above a chosen threshold.
- Record personal findings and update the contribution statement as work is completed.
