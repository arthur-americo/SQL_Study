'It retrieves information about beds from a hospital database, including the hospital ID, department ID, department name,
 ward ID, ward name, bed ID, and bed name. The results are filtered by hospital ID, whether the bed is extra, 
 bed activation date, and bed deactivation date, and are ordered by hospital ID, department ID, ward ID, and bed ID.'
SELECT
    HOSPITAL.ID AS HOSPITAL_ID,
    DEPARTMENT.ID AS DEPARTMENT_ID,
    DEPARTMENT.NAME AS DEPARTMENT_NAME,
    WARD.ID AS WARD_ID,
    WARD.NAME AS WARD_NAME,
    BED.ID AS BED_ID,
    BED.NAME AS BED_NAME
FROM BED
INNER JOIN WARD ON BED.WARD_ID = WARD.ID
INNER JOIN DEPARTMENT ON WARD.DEPARTMENT_ID = DEPARTMENT.ID
WHERE HOSPITAL.ID IN (16,21,26)
AND BED.IS_EXTRA = 'N'
AND TRUNC(BED.ACTIVATION_DATE) < TO_DATE($IAString01$,'YYYY-MM-DD')
AND TRUNC(NVL(BED.DEACTIVATION_DATE,SYSDATE)) >= TO_DATE($IAString01$,'YYYY-MM-DD')
ORDER BY
    HOSPITAL.ID,
    DEPARTMENT.ID,
    WARD.ID,
    BED.ID