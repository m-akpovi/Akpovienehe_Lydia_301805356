
          BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

INSERT INTO public."Appointment"
(patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES
(4, 5, DATE '2026-11-05', TIME '16:00', 'scheduled')
RETURNING appointment_id, patient_id, doctor_id,
appointment_date, appointment_time, status;
SELECT appointment_id, patient_id, doctor_id,
       appointment_date, appointment_time, status
FROM public."Appointment"
WHERE doctor_id = 5
  AND appointment_date = DATE '2026-11-05'
  AND appointment_time = TIME '17:00'
  AND status = 'scheduled';
  BEGIN;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date,
     appointment_time, status)
VALUES
    (4, 5, DATE '2026-11-05',
     TIME '18:00', 'scheduled')
RETURNING appointment_id, patient_id, doctor_id,
          appointment_date, appointment_time, status;