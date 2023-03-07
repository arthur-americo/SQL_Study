'This SQL script classifies hospital attendances based on unit and bed codes. It retrieves information about the attendance, 
patient, internal movement, sector, unit, and bed. The script filters the data by multi-company code, movement type, and 
internal movement date. The classification is done using a CASE statement that checks the unit code and assigns a 
classification of ‘DISCARDED’, ‘ADULT ICU’, ‘PEDIATRIC ICU’, ‘NEONATAL ICU’, or ‘NICU’. The results are ordered by 
multi-company code, internal movement date, and internal movement code.'
SELECT
    A.MULTI_COMPANY_CODE,
    A.ATTENDANCE_CODE,
    P.PATIENT_CODE,
    P.PATIENT_NAME,
    TO_CHAR(P.BIRTH_DATE,'YYYY-MM-DD') AS BIRTH_DATE,
    MI.MOVEMENT_TYPE,
    MI.INTERNAL_MOVEMENT_CODE,
    TO_CHAR(MI.INTERNAL_MOVEMENT_DATE,'YYYY-MM-DD') AS INTERNAL_MOVEMENT_DATE,
    S.SECTOR_CODE,
    S.SECTOR_NAME,
    U.UNIT_CODE,
    U.UNIT_DESCRIPTION,
    B.BED_CODE,
    B.BED_DESCRIPTION,
    CASE
        /* ADULT ICU */
        WHEN U.UNIT_CODE IN (
            70,374,
            357,407,
            315,323,325,369,388,395,401,428)
            THEN 'ADULT ICU'
        /* PEDIATRIC ICU */
        WHEN U.UNIT_CODE IN (382,402)
            THEN 'PEDIATRIC ICU'
        /* NEONATAL ICU */
        WHEN U.UNIT_CODE IN (421)
            THEN 'NEONATAL ICU'
        /* NICU */
        WHEN U.UNIT_CODE IN (422)
            THEN 'NICU'
        ELSE 'DISCARDED'
        END AS CLASSIFICATION
FROM HOSPITAL.INTERNAL_MOVEMENT MI
    INNER JOIN HOSPITAL.ATTENDANCE A ON MI.ATTENDANCE_CODE = A.ATTENDANCE_CODE
    INNER JOIN HOSPITAL.PATIENT P ON A.PATIENT_CODE = P.PATIENT_CODE
    INNER JOIN HOSPITAL.BED B ON MI.BED_CODE = B.BED_CODE
    LEFT JOIN HOSPITAL.UNIT U ON B.UNIT_CODE = U.UNIT_CODE
    LEFT JOIN HOSPITAL.SECTOR S ON U.SECTOR_CODE = S.SECTOR_CODE
WHERE A.MULTI_COMPANY_CODE IN (16,21,26)
AND MI.MOVEMENT_TYPE IN ('I', 'O')
AND TRUNC(MI.INTERNAL_MOVEMENT_DATE) = TO_DATE($IAString01$,'YYYY-MM-DD')
ORDER BY
A.MULTI_COMPANY_CODE,
TRUNC(MI.INTERNAL_MOVEMENT_DATE),
MI.INTERNAL_MOVEMENT_CODE