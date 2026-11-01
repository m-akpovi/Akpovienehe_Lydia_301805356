SELECT
    patient_id,
    first_name,
    last_name,
    phone,
    address,
    email
FROM public."Patient"
ORDER BY patient_id;

SELECT
    patient_id,
    first_name,
    last_name,
    phone,
    address,
    email
FROM public."Patient"
WHERE patient_id IN (4, 5)
ORDER BY patient_id;

BEGIN;

UPDATE public."Patient"
SET address = '14 Updated Example Road'
WHERE patient_id = 4
  AND address = '12 Example Road';

COMMIT;

UPDATE public."Patient"
SET address = '14 Updated Example Road'
WHERE patient_id = 4
  AND address = '12 Example Road';

  BEGIN;

UPDATE public."Patient"
SET phone = '08030000022'
WHERE patient_id = 5;