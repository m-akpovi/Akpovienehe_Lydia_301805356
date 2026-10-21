
-- Hospital Management System schema
-- PostgreSQL 16
-- Schema: public

BEGIN;

-- Stores hospital staff roles.
CREATE TABLE public.staffRole (
    role_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_name VARCHAR(30) NOT NULL UNIQUE,
    CONSTRAINT staffrole_valid_name
        CHECK (role_name IN ('Doctor', 'Receptionist', 'Administrator'))
);

-- Stores patient identification and contact details.
CREATE TABLE public."Patient" (
    patient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Stores hospital staff and their assigned roles.
CREATE TABLE public."Staff" (
    staff_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role_id INTEGER NOT NULL,
    CONSTRAINT staff_role_fk
        FOREIGN KEY (role_id)
        REFERENCES public.staffRole (role_id)
);

-- Stores patient appointments with doctors.
CREATE TABLE public."Appointment" (
    appointment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(15) NOT NULL,
    CONSTRAINT appointment_patient_fk
        FOREIGN KEY (patient_id)
        REFERENCES public."Patient" (patient_id),
    CONSTRAINT appointment_doctor_fk
        FOREIGN KEY (doctor_id)
        REFERENCES public."Staff" (staff_id),
    CONSTRAINT appointment_valid_status
        CHECK (status IN ('scheduled', 'completed', 'cancelled'))
);

-- Prevents conflicting scheduled appointments for doctors.
CREATE UNIQUE INDEX appointment_doctor_time_unique
    ON public."Appointment"
       (doctor_id, appointment_date, appointment_time)
    WHERE status = 'scheduled';

-- Prevents conflicting scheduled appointments for patients.
CREATE UNIQUE INDEX appointment_patient_time_unique
    ON public."Appointment"
       (patient_id, appointment_date, appointment_time)
    WHERE status = 'scheduled';

-- Stores consultation details for appointments.
CREATE TABLE public."Consultation" (
    consultation_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id INTEGER NOT NULL UNIQUE,
    diagnosis TEXT NOT NULL,
    treatment_notes TEXT NOT NULL,
    consultation_date DATE NOT NULL,
    CONSTRAINT consultation_appointment_fk
        FOREIGN KEY (appointment_id)
        REFERENCES public."Appointment" (appointment_id),
    CONSTRAINT consultation_date_valid
        CHECK (consultation_date IS NOT NULL)
);

-- Additional validation is needed to ensure that:
-- 1. The assigned doctor has the Doctor role.
-- 2. Consultations are recorded only for completed appointments.
-- 3. consultation_date is on or after appointment_date.
-- Use a trigger or controlled transaction for these cross-table rules.
-- The consultation_date CHECK above does not enforce rule 3.

COMMIT;
