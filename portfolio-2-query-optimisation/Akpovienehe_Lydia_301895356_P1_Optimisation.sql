CREATE SCHEMA p2_benchmark;

-- Create a synthetic patient history table.
INSERT INTO p2_benchmark.patient_history
    (patient_id, history_date, activity_type, details)
SELECT
    p.patient_id,

    DATE '2024-01-01'
        + ((g.n - 1) / 100)::INTEGER,

    CASE (g.n % 4)
        WHEN 0 THEN 'Patient Review'
        WHEN 1 THEN 'Medical Check'
        WHEN 2 THEN 'Follow-up'
        ELSE 'Health Assessment'
    END,

    'Synthetic patient history record ' || g.n

FROM generated_rCREATE TABLE p2_benchmark.patient_history (
    history_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    history_date DATE NOT NULL,
    activity_type VARCHAR(30) NOT NULL,
    details TEXT NOT NULL,

    CONSTRAINT fk_history_patient
        FOREIGN KEY (patient_id)
        REFERENCES public."Patient"(patient_id)
);

-- Generate exactly 100,000 synthetic records.

WITH patients AS (
    SELECT
        patient_id,
        ROW_NUMBER() OVER (ORDER BY patient_id) AS rn
    FROM public."Patient"
),
generated_records AS (
    SELECT
        n,
        ((n - 1) % 3) + 1 AS patient_rn
    FROM generate_series(1, 100000) AS n
)
records g
JOIN patients p
    ON p.rn = g.patient_rn;

-- Refresh table statistics.
ANALYZE p2_benchmark.patient_history;

-- Confirm the total number of records.
SELECT COUNT(*) AS total_records
FROM p2_benchmark.patient_history;

-- Check the distribution across patients.
SELECT
    patient_id,
    COUNT(*) AS total_records
FROM p2_benchmark.patient_history
GROUP BY patient_id
ORDER BY patient_id;

-- Check date distribution.
SELECT
    MIN(history_date) AS first_date,
    MAX(history_date) AS last_date
FROM p2_benchmark.patient_history;

SELECT
    history_id,
    patient_id,
    history_date,
    activity_type,
    details
FROM p2_benchmark.patient_history
WHERE history_date >= DATE '2024-03-01'
  AND history_date < DATE '2024-03-08';

-- BEFORE INDEXING

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    history_id,
    patient_id,
    history_date,
    activity_type,
    details
FROM p2_benchmark.patient_history
WHERE history_date >= DATE '2024-03-01'
  AND history_date < DATE '2024-03-08';

-- CREATE B-TREE INDEX

CREATE INDEX patient_history_date_idx
ON p2_benchmark.patient_history
USING BTREE (history_date);

-- Refresh statistics.
ANALYZE p2_benchmark.patient_history;

-- AFTER INDEXING

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    history_id,
    patient_id,
    history_date,
    activity_type,
    details
FROM p2_benchmark.patient_history
WHERE history_date >= DATE '2024-03-01'
  AND history_date < DATE '2024-03-08';
