'It generates a report that shows the total number of beds, the number of blocked beds, the number of available beds, 
the number of occupied beds, and the number of vacant beds for each unit in each department of the specified hospitals. 
The report is grouped by hospital, department, and unit, and is ordered by hospital, department, and unit.'
SELECT
    Hospital_ID,
    Department_Name,
    Unit_Name,
    COUNT(*) AS Total_Beds,
    SUM(CASE WHEN Bed_Status NOT IN ('Vacant','Occupied') THEN 1 ELSE 0 END) AS Blocked_Beds,
    SUM(CASE WHEN Bed_Status IN ('Vacant','Occupied') THEN 1 ELSE 0 END) AS Available_Beds,
    SUM(CASE WHEN Bed_Status IN ('Occupied') THEN 1 ELSE 0 END) AS Occupied_Beds,
    SUM(CASE WHEN Bed_Status IN ('Vacant') THEN 1 ELSE 0 END) AS Vacant_Beds
FROM (
    SELECT
        D.Hospital_ID,
        D.Department_ID,
        D.Department_Name,
        U.Unit_ID,
        U.Unit_Name,
        B.Bed_ID,
        B.Bed_Name,
        B.Bed_Status,
        CASE
            WHEN B.Bed_Status = 'Occupied' THEN 'Occupied'
            WHEN B.Bed_Status = 'Vacant' THEN 'Vacant'
            WHEN B.Bed_Status = 'Cleaning' THEN 'Cleaning'
            ELSE 'Blocked'
        END AS Status
    FROM HospitalDB.Bed B 
    INNER JOIN HospitalDB.Unit U ON B.Unit_ID = U.Unit_ID
    INNER JOIN HospitalDB.Department D ON U.Department_ID = D.Department_ID
    WHERE D.Hospital_ID IN (16,21,26)
    AND B.Is_Extra = 'N'
    AND B.Activation_Date < SYSDATE
    AND NVL(B.Deactivation_Date,SYSDATE) >= SYSDATE
)
GROUP BY
    Hospital_ID,
    Department_Name,
    Unit_Name
ORDER BY
    Hospital_ID,
    Department_Name,
    Unit_Name