-- SampleData.sql
-- Fictional hospital records for PostgreSQL 16.
-- Run after creating the schema. IDs are looked up by unique values.



BEGIN;

-- Add the allowed staff roles.
INSERT INTO public.staffRole (role_name)
VALUES ('Doctor'), ('Receptionist'), ('Administrator');


-- Add patients.
INSERT INTO public."Patient"
    (first_name, last_name, phone, address, email)
VALUES
    ('Amara', 'Okafor', '08030000001', '12 Example Road', 'amara.okafor@example.com'),
    ('Tunde', 'Bello', '08030000002', '24 Sample Avenue', 'tunde.bello@example.com'),
    ('Zainab', 'Ibrahim', '08030000003', '8 Fiction Street', 'zainab.ibrahim@example.com');

-- Add staff, looking up each role by its unique name.
INSERT INTO public."Staff"
    (first_name, last_name, phone, address, email, role_id)
VALUES
    ('Daniel', 'Mensah', '08040000001', '1 Clinic Lane',
     'daniel.mensah@example.com',
     (SELECT role_id FROM public.staffRole WHERE role_name = 'Doctor')),
    ('Fatima', 'Okoye', '08040000004', '4 Clinic Lane',
     'fatima.okoye@example.com',
     (SELECT role_id FROM public.staffRole WHERE role_name = 'Doctor')),
    ('Grace', 'Adebayo', '08040000002', '2 Clinic Lane',
     'grace.adebayo@example.com',
     (SELECT role_id FROM public.staffRole WHERE role_name = 'Receptionist')),
    ('Peter', 'Nwosu', '08040000003', '3 Clinic Lane',
     'peter.nwosu@example.com',
     (SELECT role_id FROM public.staffRole WHERE role_name = 'Administrator'));

-- Add appointments in scheduled, completed, and cancelled states.
-- The doctor is found by their unique email address.
INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES
    ((SELECT patient_id FROM public."Patient" WHERE email = 'amara.okafor@example.com'),
     (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
     DATE '2026-11-02', TIME '09:00', 'scheduled'),
    ((SELECT patient_id FROM public."Patient" WHERE email = 'tunde.bello@example.com'),
     (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
     DATE '2026-11-02', TIME '10:00', 'completed'),
    ((SELECT patient_id FROM public."Patient" WHERE email = 'zainab.ibrahim@example.com'),
     (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
     DATE '2026-11-02', TIME '11:00', 'cancelled'),
    ((SELECT patient_id FROM public."Patient" WHERE email = 'amara.okafor@example.com'),
     (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
     DATE '2026-11-03', TIME '09:00', 'completed');

-- Record consultations for completed appointments only.
INSERT INTO public."Consultation"
    (appointment_id, diagnosis, treatment_notes, consultation_date)
VALUES
    ((SELECT a.appointment_id
      FROM public."Appointment" a
      JOIN public."Patient" p ON p.patient_id = a.patient_id
      WHERE p.email = 'tunde.bello@example.com'
        AND a.appointment_date = DATE '2026-11-02'
        AND a.appointment_time = TIME '10:00'),
     'Seasonal allergy', 'Advised fluids and prescribed routine treatment.',
     DATE '2026-11-02'),
    ((SELECT a.appointment_id
      FROM public."Appointment" a
      JOIN public."Patient" p ON p.patient_id = a.patient_id
      WHERE p.email = 'amara.okafor@example.com'
        AND a.appointment_date = DATE '2026-11-03'
        AND a.appointment_time = TIME '09:00'),
     'Mild dehydration', 'Advised rest and increased fluid intake.',
     DATE '2026-11-03');

COMMIT;

SELECT 'staffRole' AS table_name, count(*) AS row_count FROM public.staffRole
UNION ALL SELECT 'Patient', count(*) FROM public."Patient"
UNION ALL SELECT 'Staff', count(*) FROM public."Staff"
UNION ALL SELECT 'Appointment', count(*) FROM public."Appointment"
UNION ALL SELECT 'Consultation', count(*) FROM public."Consultation";


