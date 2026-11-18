-- Report 1: Monthly call volume and abandonment rate.
-- COUNT(call_id) preserves zero-call months after the LEFT JOIN.
SELECT
    m.month_start,
    COUNT(c.call_id) AS total_calls,
    SUM(CASE WHEN c.status = 'answered' THEN 1 ELSE 0 END) AS answered_calls,
    SUM(CASE WHEN c.status = 'abandoned' THEN 1 ELSE 0 END) AS abandoned_calls,
    ROUND(100.0 * SUM(CASE WHEN c.status = 'abandoned' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(c.call_id), 0), 2) AS abandonment_pct
FROM reporting_months AS m
LEFT JOIN calls AS c ON date(c.call_date, 'start of month') = m.month_start
GROUP BY m.month_start
ORDER BY m.month_start;

-- Report 2: Compare language groups across the entire sample.
-- AVG excludes missing waits. Publish the coverage count alongside it.
SELECT
    l.language_name,
    COUNT(c.call_id) AS total_calls,
    SUM(CASE WHEN c.status = 'abandoned' THEN 1 ELSE 0 END) AS abandoned_calls,
    ROUND(100.0 * SUM(CASE WHEN c.status = 'abandoned' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(c.call_id), 0), 2) AS abandonment_pct,
    COUNT(c.wait_seconds) AS calls_with_wait,
    ROUND(AVG(c.wait_seconds), 2) AS average_known_wait_seconds
FROM service_languages AS l
LEFT JOIN calls AS c ON c.language_id = l.language_id
GROUP BY l.language_id, l.language_name
ORDER BY l.language_name;

-- Report 3: Consecutive-month change in percentage points using CTEs and LAG.
-- The calendar includes every month, so LAG means the previous calendar month.
WITH monthly_rates AS (
    SELECT
        m.month_start,
        100.0 * SUM(CASE WHEN c.status = 'abandoned' THEN 1 ELSE 0 END)
            / NULLIF(COUNT(c.call_id), 0) AS abandonment_pct
    FROM reporting_months AS m
    LEFT JOIN calls AS c ON date(c.call_date, 'start of month') = m.month_start
    GROUP BY m.month_start
), compared AS (
    SELECT
        month_start,
        abandonment_pct,
        LAG(abandonment_pct) OVER (ORDER BY month_start) AS previous_month_pct
    FROM monthly_rates
)
SELECT
    month_start,
    ROUND(abandonment_pct, 2) AS abandonment_pct,
    ROUND(previous_month_pct, 2) AS previous_month_pct,
    ROUND(abandonment_pct - previous_month_pct, 2) AS change_percentage_points
FROM compared
ORDER BY month_start;
