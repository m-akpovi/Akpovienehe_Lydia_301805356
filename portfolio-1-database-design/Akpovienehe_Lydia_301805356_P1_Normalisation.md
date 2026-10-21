# Hospital Management System Normalisation

Normalisation is the process of organising data into related tables to reduce repetition and prevent problems when information is added, updated or deleted. The Hospital Management System uses five tables: Patient, Staff, StaffRole, Appointment and Consultation.

The same two patients and their appointments are used in the examples below. Only the fields needed to explain normalisation are shown; the final design retains the other fields in the agreed database design. Names, contact details and appointment records are fictional.

## Starting hospital appointment record

The starting record stores patient details, doctor details and a list of appointments in one table. This makes it difficult to find, update or manage an individual appointment.

| patient_id | patient_name | phone | Appointments |
|---|---|---|---|
| P001 | Ada James | 08030000001 | A001: Dr Ben Cole, 2026-10-20, 09:00, scheduled; A002: Dr Ben Cole, 2026-10-20, 11:00, scheduled |
| P002 | John Peter | 08030000002 | A003: Dr Ben Cole, 2026-10-21, 10:00, scheduled |

The first row contains two appointments in one cell. This violates First Normal Form (1NF), which requires each cell to contain one value.

## 1NF: One value per cell

First Normal Form (1NF) means that each cell contains a single value and each record represents one entry.

The appointment list is separated into individual rows. Patient and doctor details repeat, but every appointment is now recorded separately.

| appointment_id | patient_id | patient_name | phone | doctor_id | doctor_name | appointment_date | appointment_time | status |
|---|---|---|---|---|---|---|---|---|
| A001 | P001 | Ada James | 08030000001 | S001 | Ben Cole | 2026-10-20 | 09:00 | scheduled |
| A002 | P001 | Ada James | 08030000001 | S001 | Ben Cole | 2026-10-20 | 11:00 | scheduled |
| A003 | P002 | John Peter | 08030000002 | S001 | Ben Cole | 2026-10-21 | 10:00 | scheduled |

**Key:** `appointment_id` is the primary key because it uniquely identifies each appointment. `patient_id` and `doctor_id` are foreign keys that link to patient and staff records.

A foreign key is a field that connects a record to another table.

The table satisfies 1NF, but patient names, phone numbers and doctor names repeat. Updating a patient's phone number requires changing multiple appointment rows, which can lead to inconsistent information.

## 2NF: Details depend on the whole key

Second Normal Form (2NF) includes 1NF. Every non-key field must depend on the whole primary key, not just part of a combined key.

A combined key uses two or more fields together to identify a record.

In the starting 1NF table, `appointment_id` alone identifies each appointment. Therefore, the table has a single-field primary key, not a combined key. There are no partial dependencies on part of a combined primary key, so the table is already in 2NF, assuming each appointment has a unique `appointment_id`.

However, patient and doctor details still describe separate entities. Separating these details improves the design and prepares it for 3NF.

### Patient details

**Key:** `patient_id`.

| patient_id | patient_name | phone |
|---|---|---|
| P001 | Ada James | 08030000001 |
| P002 | John Peter | 08030000002 |

### Staff details

**Key:** `staff_id`.

| staff_id | staff_name |
|---|---|
| S001 | Ben Cole |

### Appointment details

**Key:** `appointment_id`. `patient_id` and `doctor_id` are foreign keys.

| appointment_id | patient_id | doctor_id | appointment_date | appointment_time | status |
|---|---|---|---|---|---|
| A001 | P001 | S001 | 2026-10-20 | 09:00 | scheduled |
| A002 | P001 | S001 | 2026-10-20 | 11:00 | scheduled |
| A003 | P002 | S001 | 2026-10-21 | 10:00 | scheduled |

The patient and staff details move into their own tables because they describe patients and staff members rather than individual appointments. Appointment records retain their IDs, which link them to the correct patient and doctor.

This reduces repeated contact and staff details. The full agreed design also retains the other patient and staff attributes.

## 3NF: Keep details with the thing they describe

Third Normal Form (3NF) includes 2NF. Non-key fields must depend on the primary key, the whole key and nothing but the key. In simple terms, a field should describe the record identified by its primary key rather than depend on another non-key field.

The 1NF table contains these dependencies:

- `patient_id` determines `patient_name` and `phone`.
- `doctor_id` determines `doctor_name`.

These details describe the patient and staff member, not the appointment. They therefore belong in Patient and Staff rather than being repeated in Appointment.

The final design also separates staff roles and consultation records.

### Patient

**Key:** `patient_id`.

| patient_id | first_name | last_name | phone | address | email |
|---|---|---|---|---|---|
| P001 | Ada | James | 08030000001 | Warri | ada@example.com |
| P002 | John | Peter | 08030000002 | Warri | *(optional)* |

The patient table stores each patient's details once. The email field is optional but must be unique when provided.

### StaffRole

**Key:** `role_id`.

| role_id | role_name |
|---|---|
| R001 | Doctor |
| R002 | Receptionist |
| R003 | Administrator |

Each role is stored once rather than being repeatedly written as staff information.

### Staff

**Key:** `staff_id`. `role_id` is a foreign key to StaffRole.

| staff_id | first_name | last_name | phone | address | email | role_id |
|---|---|---|---|---|---|---|
| S001 | Ben | Cole | 08040000001 | Warri | ben@example.com | R001 |

The Staff table stores staff details once and links each staff member to one role. In this example, S001 has the Doctor role.

### Appointment

**Key:** `appointment_id`. `patient_id` and `doctor_id` are foreign keys to Patient and Staff.

| appointment_id | patient_id | doctor_id | appointment_date | appointment_time | status |
|---|---|---|---|---|---|
| A001 | P001 | S001 | 2026-10-20 | 09:00 | completed |
| A002 | P001 | S001 | 2026-10-20 | 11:00 | scheduled |
| A003 | P002 | S001 | 2026-10-21 | 10:00 | scheduled |

The Appointment table stores the booking details and links to the relevant patient and doctor. Ada can have two appointments on the same day because the times differ.

### Consultation

**Key:** `consultation_id`. `appointment_id` is a unique foreign key to Appointment.

| consultation_id | appointment_id | diagnosis | treatment_notes | consultation_date |
|---|---|---|---|---|
| C001 | A001 | Malaria | Prescribed treatment and follow-up | 2026-10-20 |

The Consultation table stores the diagnosis and treatment notes for a completed appointment. The unique `appointment_id` ensures that an appointment has at most one consultation. A scheduled appointment, such as A002, has no consultation yet.

## How the IDs keep the tables linked

The IDs preserve the relationships between the tables without repeating all the details.

- `patient_id` links each appointment to its patient.
- `doctor_id` links each appointment to a staff member who must have the Doctor role.
- `role_id` links each staff member to their assigned role.
- `appointment_id` links each consultation to its appointment.

For example, appointment A001 links to patient P001 and doctor S001. Consultation C001 links to A001, allowing the hospital to retrieve the patient, doctor, appointment and consultation details together.

## Final design and fields retained

The final normalised design contains the five agreed tables:

1. **Patient:** `patient_id`, `first_name`, `last_name`, `phone`, `address`, `email`.
2. **Staff:** `staff_id`, `first_name`, `last_name`, `phone`, `address`, `email`, `role_id`.
3. **StaffRole:** `role_id`, `role_name`.
4. **Appointment:** `appointment_id`, `patient_id`, `doctor_id`, `appointment_date`, `appointment_time`, `status`.
5. **Consultation:** `consultation_id`, `appointment_id`, `diagnosis`, `treatment_notes`, `consultation_date`.

The small examples omit no fields from the final design except where a table is explicitly shown with selected fields for readability. In particular, the full Patient table includes the optional email field, and the full Staff table includes the required email field. The appointment and consultation examples show all their agreed attributes.

The final design uses individual primary keys such as `appointment_id` and `consultation_id`. These IDs provide straightforward ways to identify and link records. Choosing a single-field ID instead of a combined key is a design choice; an ID alone does not prove that a table satisfies 3NF.

## Additional rules

Normalisation reduces repeated data, but it does not enforce every business rule by itself. The design also requires:

- Unique email addresses where specified and unique staff role names.
- Valid appointment statuses: `scheduled`, `completed` or `cancelled`.
- Validation that a doctor assigned to an appointment has the Doctor role.
- Partial unique indexes to prevent conflicting scheduled appointments for the same doctor or patient at the same date and time, while permitting different times on the same day.
- A trigger or controlled transaction to ensure consultations are created only for completed appointments.
- Validation that the consultation date is on or after the appointment date.

These constraints and validation rules preserve data accuracy alongside the normalised tables.