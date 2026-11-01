# Portfolio 2 Query Processing and Optimisation

## Queries and results

Three SQL queries were created for the Hospital Management System database.

1. **Scheduled appointments:** Retrieves scheduled appointments for 2 November 2026, including patient details and the doctor's name. It returned one record: Amara Okafor with Dr Daniel Mensah at 09:00.

2. **Available doctors:** Identifies doctors who have no scheduled appointment at 09:00 on 2 November 2026. It uses `NOT EXISTS` to exclude doctors who already have an appointment at that time. It returned one record: Dr Fatima Okoye.

3. **Consultation count per appointment:** Counts the consultations associated with each appointment using a `LEFT JOIN`. It returned four records, including appointments without consultations. The two completed appointments each had one consultation, while the scheduled and cancelled appointments had zero.

## Index comparison

The test table was `p2_benchmark.patient_history`, containing 100,000 synthetic records linked to the existing Patient table.

The same date-range query was used before and after indexing. It retrieved patient history records from 1 March 2024 to 7 March 2024 (inclusive), returning 700 rows in both tests.

A B-tree index named `patient_history_date_idx` was added to the `history_date` column.

| Measurement | Before index | After index |
| --- | --- | --- |
| Scan type | Sequential Scan | Index Scan |
| Three execution times (ms) | 8.072, 7.298, 9.614 | 0.129, 1.931, 0.207 |
| Median time (ms) | 8.072 | 0.207 |
| Shared buffer hits, third run | 1,246 | 11 |

## Performance analysis

Before indexing, PostgreSQL used a Sequential Scan and removed 99,300 rows that did not match the date condition. After adding the B-tree index, it used an Index Scan to retrieve the 700 matching rows. The median execution time decreased from 8.072 ms to 0.207 ms, representing an approximately 97.44% reduction. Third-run shared buffer hits also decreased from 1,246 to 11. A limitation of the test is that it used synthetic data and only one date-range query, so results may differ with real-world data and other query patterns. The index also requires additional storage and increases the maintenance cost of INSERT, UPDATE and DELETE operations.

## Files

- `Queries.sql` – Contains the three SQL queries for the Hospital Management System.
- `Optimisation.sql` – Contains the benchmark table creation, synthetic data generation, test query and B-tree index creation.
- `screenshots/` – Contains screenshots of query results and before-and-after execution plans.

## Reference

- [PostgreSQL 16 Documentation – Using EXPLAIN](https://www.postgresql.org/docs/16/using-explain.html)
- [PostgreSQL 16 Documentation – Indexes](https://www.postgresql.org/docs/16/indexes.html)