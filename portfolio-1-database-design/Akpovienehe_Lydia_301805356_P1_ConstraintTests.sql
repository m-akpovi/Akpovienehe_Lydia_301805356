-- ConstraintTests.sql
-- Run each INSERT separately after SampleData.sql.
-- Each statement is designed to fail for the stated reason.
-- Do not wrap this file in a transaction: continue after each error.

-- Expected: NOT NULL violation (role_name is required).
INSERT INTO public.staffRole (role_name) VALUES (NULL);

-- Expected: UNIQUE violation (role_name already exists).
INSERT INTO public.staffRole (role_name) VALUES ('Doctor');

-- Expected: CHECK violation (this role name is not allowed).
INSERT INTO public.staffRole (role_name) VALUES ('Nurse');

-- Expected: NOT NULL violation (patient first_name is required).
INSERT INTO public."Patient" (first_name, last_name, phone, address, email)
VALUES (NULL, 'Test', '08050000001', '4 Test Road', 'valid.patient@example.com');

-- Expected: UNIQUE violation (patient email already exists).
INSERT INTO public."Patient" (first_name, last_name, phone, address, email)
VALUES ('New', 'Patient', '08050000004', '5 Test Road', 'amara.okafor@example.com');

-- Expected: NOT NULL violation (staff email is required).
INSERT INTO public."Staff" (first_name, last_name, phone, address, email, role_id)
VALUES ('Test', 'Staff', '08050000005', '6 Test Road', NULL,
        (SELECT role_id FROM public.staffRole WHERE role_name = 'Doctor'));

-- Expected: UNIQUE violation (staff email already exists).
INSERT INTO public."Staff" (first_name, last_name, phone, address, email, role_id)
VALUES ('Another', 'Doctor', '08050000006', '7 Test Road', 'daniel.mensah@example.com',
        (SELECT role_id FROM public.staffRole WHERE role_name = 'Doctor'));

-- Expected: FOREIGN KEY violation (the role ID does not exist).
INSERT INTO public."Staff" (first_name, last_name, phone, address, email, role_id)
VALUES ('Valid', 'Person', '08050000007', '8 Test Road', 'valid.staff@example.com', -999);

-- Expected: NOT NULL violation (appointment patient_id is required).
INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES (NULL,
        (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
        DATE '2026-11-04', TIME '09:00', 'scheduled');

-- Expected: FOREIGN KEY violation (patient does not exist).
INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES (-999,
        (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
        DATE '2026-11-04', TIME '09:00', 'scheduled');

-- Expected: FOREIGN KEY violation (staff ID does not exist).
INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES ((SELECT patient_id FROM public."Patient" WHERE email = 'amara.okafor@example.com'),
        -999, DATE '2026-11-04', TIME '09:00', 'scheduled');

-- Expected: CHECK violation (status must be scheduled, completed, or cancelled).
INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES ((SELECT patient_id FROM public."Patient" WHERE email = 'amara.okafor@example.com'),
        (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
        DATE '2026-11-04', TIME '09:00', 'pending');

-- Expected: UNIQUE index violation (doctor already has a scheduled appointment at this time).
INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES ((SELECT patient_id FROM public."Patient" WHERE email = 'tunde.bello@example.com'),
        (SELECT staff_id FROM public."Staff" WHERE email = 'daniel.mensah@example.com'),
        DATE '2026-11-02', TIME '09:00', 'scheduled');

-- Expected: UNIQUE index violation (patient already has a scheduled appointment at this time).
-- A different doctor isolates the patient-time index.
INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES ((SELECT patient_id FROM public."Patient" WHERE email = 'amara.okafor@example.com'),
        (SELECT staff_id FROM public."Staff" WHERE email = 'fatima.okoye@example.com'),
        DATE '2026-11-02', TIME '09:00', 'scheduled');

-- Expected: NOT NULL violation (consultation diagnosis is required).
INSERT INTO public."Consultation"
    (appointment_id, diagnosis, treatment_notes, consultation_date)
VALUES ((SELECT a.appointment_id
         FROM public."Appointment" a
         JOIN public."Patient" p ON p.patient_id = a.patient_id
         WHERE p.email = 'tunde.bello@example.com'
           AND a.appointment_date = DATE '2026-11-02'
           AND a.appointment_time = TIME '10:00'),
        NULL, 'Valid treatment notes.', DATE '2026-11-02');

-- Expected: UNIQUE violation (this appointment already has a consultation).
INSERT INTO public."Consultation"
    (appointment_id, diagnosis, treatment_notes, consultation_date)
VALUES ((SELECT a.appointment_id
         FROM public."Appointment" a
         JOIN public."Patient" p ON p.patient_id = a.patient_id
         WHERE p.email = 'tunde.bello@example.com'
           AND a.appointment_date = DATE '2026-11-02'
           AND a.appointment_time = TIME '10:00'),
        'Repeat test', 'Otherwise valid notes.', DATE '2026-11-02');

-- Expected: FOREIGN KEY violation (appointment does not exist).
INSERT INTO public."Consultation"
    (appointment_id, diagnosis, treatment_notes, consultation_date)
VALUES (-999, 'Valid diagnosis', 'Valid treatment notes.', DATE '2026-11-04');

-- Expected: CHECK violation (consultation_date is NOT NULL).
-- The NOT NULL column rule may be reported before the CHECK constraint.
INSERT INTO public."Consultation"
    (appointment_id, diagnosis, treatment_notes, consultation_date)
VALUES ((SELECT a.appointment_id
         FROM public."Appointment" a
         JOIN public."Patient" p ON p.patient_id = a.patient_id
         WHERE p.email = 'tunde.bello@example.com'
           AND a.appointment_date = DATE '2026-11-02'
           AND a.appointment_time = TIME '10:00'),
        'Valid diagnosis', 'Valid treatment notes.', NULL);

-- Final check: after all failed inserts, expected counts are:
-- staffRole = 3, Patient = 3, Staff = 4, Appointment = 4, Consultation = 2.
SELECT 'staffRole' AS table_name, COUNT(*) AS row_count FROM public.staffRole
UNION ALL
SELECT 'Patient', COUNT(*) FROM public."Patient"
UNION ALL
SELECT 'Staff', COUNT(*) FROM public."Staff"
UNION ALL
SELECT 'Appointment', COUNT(*) FROM public."Appointment"
UNION ALL
SELECT 'Consultation', COUNT(*) FROM public."Consultation"
ORDER BY table_name;

-- Note: the current schema does not enforce the cross-table rules listed
-- in its comments (doctor role, completed-only consultations, and consultation
-- date on/after appointment date). Those need a trigger or controlled workflow.
