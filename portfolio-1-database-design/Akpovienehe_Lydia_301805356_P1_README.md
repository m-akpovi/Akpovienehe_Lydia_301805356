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
