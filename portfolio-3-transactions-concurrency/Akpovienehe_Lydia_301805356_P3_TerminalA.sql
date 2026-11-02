BEGIN;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

INSERT INTO public."Appointment"
    (patient_id, doctor_id, appointment_date,
     appointment_time, status)
VALUES
    (4, 5, DATE '2026-11-05',
     TIME '15:00', 'scheduled')
RETURNING appointment_id, patient_id, doctor_id,
          appointment_date, appointment_time, status;
          COMMIT;
          SELECT
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    appointment_time,
    status,
    COUNT(*) OVER (
        PARTITION BY doctor_id,
                     appointment_date,
                     appointment_time
    ) AS conflicting_appointments
FROM public."Appointment"
WHERE doctor_id = 5
  AND appointment_date = DATE '2026-11-05'
  AND appointment_time = TIME '14:00'
  AND status = 'scheduled';