# Hospital Management Database Design

## 1. Entities

The database contains five entities (tables):

1. **Patient** — stores patient identification and contact details.
2. **Staff** — stores hospital staff details, including doctors and administrators.
3. **Appointment** — stores appointment dates, times, status and links to patients and doctors.
4. **Consultation** — stores diagnoses and treatment notes for completed appointments.
5. **StaffRole** — identifies the role assigned to each staff member, such as doctor, receptionist or administrator.

The five entities support patient registration, staff management, appointment scheduling and consultation history.

## 2. Attributes and keys

**PK** means primary key, a field that uniquely identifies each record. **FK** means foreign key, a field that links to a record in another table. Required fields cannot be empty; optional fields can be empty.

### Patient

| Attribute | PostgreSQL type | Constraint |
|---|---|---|
| patient_id | INTEGER | PK, required |
| first_name | VARCHAR(50) | Required |
| last_name | VARCHAR(50) | Required |
| phone | VARCHAR(20) | Required |
| address | VARCHAR(50) | Required |
| email | VARCHAR(100) | Optional, unique when provided |

### Staff

| Attribute | PostgreSQL type | Constraint |
|---|---|---|
| staff_id | INTEGER | PK, required |
| first_name | VARCHAR(50) | Required |
| last_name | VARCHAR(50) | Required |
| phone | VARCHAR(20) | Required |
| address | VARCHAR(50) | Required |
| email | VARCHAR(100) | Required, unique |

### StaffRole

| Attribute | PostgreSQL type | Constraint |
|---|---|---|
| role_id | INTEGER | PK, required |
| role_name | VARCHAR(30) | Required, unique |

Allowed roles are Doctor, Receptionist and Administrator.

### Appointment

| Attribute | PostgreSQL type | Constraint |
|---|---|---|
| appointment_id | INTEGER | PK, required |
| patient_id | INTEGER | FK, required |
| doctor_id | INTEGER | FK to Staff, required |
| appointment_date | DATE | Required |
| appointment_time | TIME | Required |
| status | VARCHAR(15) | Required; scheduled, completed or cancelled |

### Consultation

| Attribute | PostgreSQL type | Constraint |
|---|---|---|
| consultation_id | INTEGER | PK, required |
| appointment_id | INTEGER | FK, required, unique |
| diagnosis | TEXT | Required |
| treatment_notes | TEXT | Required |
| consultation_date | DATE | Required |

The unique appointment FK ensures that each appointment has at most one consultation. The consultation date is stored because it records when the consultation occurs.

## 3. Relationships

- **Patient to Appointment:** One patient can have zero or many appointments. Each appointment belongs to exactly one patient.
- **Staff (doctor) to Appointment:** One doctor can have zero or many appointments. Each appointment has exactly one doctor.
- **Appointment to Consultation:** An appointment can have zero or one consultation. Each consultation belongs to exactly one appointment.
- **StaffRole to Staff:** One role can be assigned to many staff members. Each staff member has one role.

For example, patient P001 can have appointments A001 at 9:00 a.m. and A002 at 11:00 a.m. on the same day, with different appointment records.

## 4. Business rules and constraints

1. **Unique patient and staff numbers:** Primary keys identify patients and staff uniquely.
2. **Patient registration before booking:** The appointment's patient FK requires an existing patient.
3. **Existing patient and doctor:** Patient and doctor foreign keys prevent appointments from referencing missing records. The doctor must also have the Doctor role.
4. **Unique appointment number and valid status:** The primary key ensures uniqueness; `NOT NULL` constraints require date, time and status, while a `CHECK` constraint limits status to the three permitted values.
5. **No conflicting doctor appointments:** A unique constraint on doctor, date and time prevents two appointments for the same doctor at the same time when both are scheduled. A partial unique index can enforce this condition.
6. **Patient appointments at different times:** A similar partial unique index on patient, date and time prevents overlapping appointments at the same scheduled time but permits different times on the same day.
7. **At most one consultation per appointment:** The unique appointment FK prevents duplicate consultation records.
8. **Consultations only for completed appointments:** This requires a database trigger or controlled transaction because a normal `CHECK` constraint cannot reliably validate another table's status. The consultation date must be on or after the appointment date.

## 5. Design assumptions

1. Each staff member has one role; doctors are represented in the Staff table rather than a separate Doctor table.
2. Appointment times are stored as local hospital times, and appointments at different times on the same day are permitted.
3. Cancelled appointments remain in the database for history, and consultations require completed appointments.
