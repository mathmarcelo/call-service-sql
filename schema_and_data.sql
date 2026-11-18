-- SQLite. Synthetic records created solely for this learning example.
PRAGMA foreign_keys = ON;

CREATE TABLE service_languages (
    language_id INTEGER PRIMARY KEY,
    language_name TEXT NOT NULL UNIQUE
);

CREATE TABLE reporting_months (
    month_start TEXT PRIMARY KEY
);

CREATE TABLE calls (
    call_id INTEGER PRIMARY KEY,
    call_date TEXT NOT NULL,
    language_id INTEGER NOT NULL REFERENCES service_languages(language_id),
    status TEXT NOT NULL CHECK (status IN ('answered', 'abandoned')),
    wait_seconds INTEGER CHECK (wait_seconds >= 0)
);

INSERT INTO service_languages VALUES
    (1, 'English'), (2, 'Spanish'), (3, 'French'), (4, 'Arabic');

-- November deliberately has no calls to exercise empty-period reporting.
INSERT INTO reporting_months VALUES
    ('2026-08-01'), ('2026-09-01'), ('2026-10-01'), ('2026-11-01');

INSERT INTO calls VALUES
    (1, '2026-08-02', 1, 'answered', 20),
    (2, '2026-08-03', 2, 'abandoned', 90),
    (3, '2026-08-04', 3, 'answered', 35),
    (4, '2026-08-05', 1, 'abandoned', 120),
    (5, '2026-08-06', 2, 'answered', 25),
    (6, '2026-08-07', 3, 'abandoned', 100),
    (7, '2026-08-08', 1, 'answered', 15),
    (8, '2026-08-09', 2, 'answered', 30),
    (9, '2026-09-02', 1, 'answered', 18),
    (10, '2026-09-03', 2, 'abandoned', 80),
    (11, '2026-09-04', 3, 'answered', 28),
    (12, '2026-09-05', 1, 'answered', 22),
    (13, '2026-09-06', 2, 'answered', 20),
    (14, '2026-09-07', 3, 'abandoned', 85),
    (15, '2026-09-08', 1, 'answered', NULL),
    (16, '2026-09-09', 2, 'answered', 24),
    (17, '2026-10-02', 1, 'answered', 12),
    (18, '2026-10-03', 2, 'answered', 15),
    (19, '2026-10-04', 3, 'answered', 20),
    (20, '2026-10-05', 1, 'answered', 16),
    (21, '2026-10-06', 2, 'answered', 18),
    (22, '2026-10-07', 3, 'abandoned', 70),
    (23, '2026-10-08', 1, 'answered', 10),
    (24, '2026-10-09', 2, 'answered', 14);
