-- Query 1: Display scheduled appointments with patient and doctor details.
-- Only appointments scheduled for 2 November 2026 are displayed.

SELECT
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    s.first_name || ' ' || s.last_name AS doctor_name,
    r.role_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM public."Appointment" a
JOIN public."Patient" p
    ON a.patient_id = p.patient_id
JOIN public."Staff" s
    ON a.doctor_id = s.staff_id
JOIN public.staffRole r
    ON s.role_id = r.role_id
WHERE a.status = 'scheduled'
  AND a.appointment_date = DATE '2026-11-02'
ORDER BY
    a.appointment_date,
    a.appointment_time,
    a.appointment_id;

-- Query 2: Find doctors available at 09:00 on 2 November 2026.
-- A doctor is available if they have no scheduled appointment
-- at the specified date and time.

SELECT
    s.staff_id,
    s.first_name || ' ' || s.last_name AS doctor_name,
    s.phone,
    s.email
FROM public."Staff" s
JOIN public.staffRole r
    ON s.role_id = r.role_id
WHERE r.role_name = 'Doctor'
  AND NOT EXISTS (
      SELECT 1
      FROM public."Appointment" a
      WHERE a.doctor_id = s.staff_id
        AND a.appointment_date = DATE '2026-11-02'
        AND a.appointment_time = TIME '09:00'
        AND a.status = 'scheduled'
  )
ORDER BY
    s.last_name,
    s.first_name,
    s.staff_id;

-- Query 3: Count the consultations recorded for each appointment.
-- LEFT JOIN retains appointments even when they have no consultation.

SELECT
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    a.appointment_date,
    a.appointment_time,
    a.status,
    COUNT(c.consultation_id) AS consultation_count
FROM public."Appointment" a
JOIN public."Patient" p
    ON a.patient_id = p.patient_id
LEFT JOIN public."Consultation" c
    ON a.appointment_id = c.appointment_id
GROUP BY
    a.appointment_id,
    p.first_name,
    p.last_name,
    a.appointment_date,
    a.appointment_time,
    a.status
ORDER BY
    a.appointment_date,
    a.appointment_time,
    a.appointment_id;