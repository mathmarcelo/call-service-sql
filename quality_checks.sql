-- Expected: 24 records, 24 distinct IDs, 0 invalid statuses, 1 missing wait,
-- 0 negative waits, 0 unmatched languages, and 0 calls outside the calendar.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT call_id) AS distinct_call_ids,
    SUM(CASE WHEN status NOT IN ('answered', 'abandoned') OR status IS NULL
        THEN 1 ELSE 0 END) AS invalid_statuses,
    SUM(CASE WHEN wait_seconds IS NULL THEN 1 ELSE 0 END) AS missing_waits,
    SUM(CASE WHEN wait_seconds < 0 THEN 1 ELSE 0 END) AS negative_waits,
    SUM(CASE WHEN language_id NOT IN (SELECT language_id FROM service_languages)
        THEN 1 ELSE 0 END) AS unmatched_languages,
    SUM(CASE WHEN date(call_date, 'start of month') IS NULL
        OR date(call_date, 'start of month') NOT IN
            (SELECT month_start FROM reporting_months)
        THEN 1 ELSE 0 END) AS calls_outside_calendar
FROM calls;
