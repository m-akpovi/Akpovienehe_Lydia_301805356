# Portfolio 1 Database Design and Modelling

## Case study

A hospital management system that stores patient records, staff details, appointments and medical consultations. Reception staff schedule appointments, while doctors record consultation details and diagnoses for patients. The system helps staff manage patient visits and retrieve relevant appointment and consultation history.

## Users

1. Receptionists register patients, maintain patient records and schedule appointments
2. Doctors view patient details, conduct consultations and record diagnoses and treatment notes
3. Hospital administrators register staff and maintain staff information.

## Main operations

1. The system supports registering a new patient
2. Updating patient contact details
3. Registering hospital staff
4. Scheduling an appointment between a patient and a doctor
5. Viewing appointments by patient, doctor or date
6. Recording consultation details and diagnoses
7. Retrieving a patient's appointment and consultation history.

## Business rules

1. Each patient has a unique patient number, and each staff member has a unique staff number.
2. Each patient must have a registered patient record before an appointment can be scheduled.
3. Each appointment must refer to one existing patient and one existing doctor.
4. Each appointment has a unique appointment number, a valid date and time, and a status of scheduled, completed or cancelled.
5. A doctor cannot have two scheduled appointments at the same date and time.
6. A patient may have multiple scheduled appointments on the same day, provided they are at different times.
7. Each consultation must refer to one existing appointment, and an appointment can have at most one consultation record.
8. A consultation can be recorded only for a completed appointment, and its consultation date cannot be earlier than the appointment date.

## Scope

The system covers one hospital, fictional patient and staff records, appointment scheduling, and consultation records containing diagnoses and treatment notes. It excludes pharmacy and drug inventory, laboratory investigations, billing and payments, inpatient admissions, insurance claims, and user authentication.
## Design and implementation files
| File	| Contents |
| --- | --- |
| [Akpovienehe_Lydia_301805356_P1_Design.md] |	Describes the hospital management system database design.|
| [Akpovienehe_Lydia_301805356_P1_ERDiagram.md] |	Contains the Entity Relationship Diagram showing the entities and their relationships. |
| [Akpovienehe_Lydia_301805356_P1_Normalisation.md] |	Explains the normalisation process used in the database design.|
| [Akpovienehe_Lydia_301805356_P1_Schema.sql]	| Contains the PostgreSQL 16 database schema, tables, keys, and constraints.|
| [Akpovienehe_Lydia_301805356_P1_SampleData.sql] |	Contains fictional sample records for testing the database. |
| [Akpovienehe_Lydia_301805356_P1_ConstraintTests.sql] |	Contains SQL statements used to test database constraints.
| [screenshots/] |	Contains screenshots showing the database implementation and constraint-testing results. |

## Implementation
The database was implemented using PostgreSQL 16.15 on Ubuntu 24.04. The PostgreSQL service was started, and the hospital_management_system database was accessed using the psql command-line interface. The schema creates five tables: staffRole, Patient, Staff, Appointment, and Consultation, using generated identity primary keys, foreign keys, unique constraints, NOT NULL constraints, CHECK constraints, and partial unique indexes.

Fictional sample records were inserted using the sample-data SQL file. The constraint-testing SQL file was then used to test invalid and duplicate records. Each test statement was executed separately so that rejected inserts could be identified without stopping the remaining tests.
## Test results
The tests confirmed that the database rejected records with missing required values, duplicate unique values, invalid staff roles, invalid foreign-key references, invalid appointment statuses, and conflicting scheduled appointment times. Duplicate scheduled appointments for the same doctor and duplicate scheduled appointments for the same patient at the same date and time were also rejected.

The final database counts were three staff roles, three patients, four staff members, four appointments, and two consultations. These results matched the expected sample-data totals, showing that the rejected test records did not increase the final record counts.

Some cross-table business rules still require additional validation. These include ensuring that only staff with the Doctor role are assigned as doctors, that consultations are recorded only for completed appointments, and that consultation dates are not earlier than appointment dates.