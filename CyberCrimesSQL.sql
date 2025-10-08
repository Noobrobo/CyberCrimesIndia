/*
================================================================================
PROJECT: Cyber Crime Analysis in India (2016-2018)
AUTHOR: Buddha
DATE: [08/10/2025]
DATABASE: SQL Server
================================================================================
*/

-- ============================================================================
-- DATA PREPARATION
-- ============================================================================

-- View the original data structure
SELECT * FROM CyberCrimes;

-- Rename columns for better readability
EXEC sp_rename 'CyberCrimes.[_2016]', 'Year_2016', 'COLUMN'; 
EXEC sp_rename 'CyberCrimes.[_2017]', 'Year_2017', 'COLUMN';
EXEC sp_rename 'CyberCrimes.[_2018]', 'Year_2018', 'COLUMN';


-- ============================================================================
-- Q1: Total count of states/union territories in the dataset by category
-- ============================================================================

SELECT 
    Category,
    COUNT(*) AS Total_Count
FROM CyberCrimes
GROUP BY Category;


-- ============================================================================
-- Q2: Top 10 states with highest cyber crimes in 2016
-- ============================================================================

SELECT TOP 10
    State_UT,
    SUM(Year_2016) AS Total_Crimes
FROM CyberCrimes
GROUP BY State_UT
ORDER BY Total_Crimes DESC;


-- ============================================================================
-- Q3: Top 10 states with highest cyber crimes in 2017
-- ============================================================================

SELECT TOP 10 
    State_UT,
    SUM(Year_2017) AS Total_Crimes
FROM CyberCrimes
GROUP BY State_UT
ORDER BY Total_Crimes DESC;


-- ============================================================================
-- Q4: Top 10 states with highest cyber crimes in 2018
-- ============================================================================

SELECT TOP 10
    State_UT,
    SUM(Year_2018) AS Total_Crimes
FROM CyberCrimes
GROUP BY State_UT
ORDER BY Total_Crimes DESC;


-- ============================================================================
-- Q5: Top state from each year (2016, 2017, 2018) with highest cases
-- ============================================================================

WITH RankedCrimes AS (
    SELECT 
        State_UT,
        Year_2016,
        Year_2017,
        Year_2018,
        ROW_NUMBER() OVER (ORDER BY Year_2016 DESC) AS Rank2016,
        ROW_NUMBER() OVER (ORDER BY Year_2017 DESC) AS Rank2017,
        ROW_NUMBER() OVER (ORDER BY Year_2018 DESC) AS Rank2018
    FROM CyberCrimes
)
SELECT '2016' AS Year, State_UT, Year_2016 AS Total_Crimes
FROM RankedCrimes
WHERE Rank2016 = 1
UNION ALL
SELECT '2017', State_UT, Year_2017
FROM RankedCrimes
WHERE Rank2017 = 1
UNION ALL
SELECT '2018', State_UT, Year_2018
FROM RankedCrimes
WHERE Rank2018 = 1;


-- ============================================================================
-- Q6: Top 5 states/UTs with highest total cyber crimes (2016-2018 combined)
-- ============================================================================

SELECT TOP 5
    State_UT,
    (Year_2016 + Year_2017 + Year_2018) AS Total_Crimes_3Years
FROM CyberCrimes
ORDER BY Total_Crimes_3Years DESC;


-- ============================================================================
-- Q7: Year-over-year growth rate analysis
-- ============================================================================

SELECT
    SUM(Year_2016) AS Total_2016,
    SUM(Year_2017) AS Total_2017,
    SUM(Year_2018) AS Total_2018,
    ROUND(((SUM(Year_2017) - SUM(Year_2016)) * 100.0 / SUM(Year_2016)), 2) AS Growth_2016_to_2017_Percent,
    ROUND(((SUM(Year_2018) - SUM(Year_2017)) * 100.0 / SUM(Year_2017)), 2) AS Growth_2017_to_2018_Percent,
    ROUND(((SUM(Year_2018) - SUM(Year_2016)) * 100.0 / SUM(Year_2016)), 2) AS Overall_Growth_2016_to_2018_Percent
FROM CyberCrimes;


-- ============================================================================
-- Q8: States with consistent rise in cyber crimes (2016→2017→2018)
-- ============================================================================

SELECT 
    State_UT,
    Year_2016,
    Year_2017,
    Year_2018
FROM CyberCrimes
WHERE Year_2016 < Year_2017 
  AND Year_2017 < Year_2018
ORDER BY State_UT;


-- ============================================================================
-- Q9: States with decline in cyber crimes from 2017 to 2018
-- ============================================================================

SELECT 
    State_UT,
    Year_2017,
    Year_2018,
    (Year_2017 - Year_2018) AS Decline
FROM CyberCrimes
WHERE Year_2017 > Year_2018
ORDER BY Decline DESC;


-- ============================================================================
-- Q10: States with most inconsistent trend (highest fluctuation 2016-2018)
-- ============================================================================

SELECT 
    State_UT,
    Year_2016,
    Year_2017,
    Year_2018,
    (
        CASE 
            WHEN Year_2016 >= Year_2017 AND Year_2016 >= Year_2018 THEN Year_2016
            WHEN Year_2017 >= Year_2016 AND Year_2017 >= Year_2018 THEN Year_2017
            ELSE Year_2018
        END
        -
        CASE 
            WHEN Year_2016 <= Year_2017 AND Year_2016 <= Year_2018 THEN Year_2016
            WHEN Year_2017 <= Year_2016 AND Year_2017 <= Year_2018 THEN Year_2017
            ELSE Year_2018
        END
    ) AS Fluctuation
FROM CyberCrimes
ORDER BY Fluctuation DESC;


-- ============================================================================
-- Q11: Top 5 states with fastest growth from 2016 to 2018
-- ============================================================================

SELECT TOP 5
    State_UT,
    Year_2016,
    Year_2018,
    CASE 
        WHEN Year_2016 = 0 THEN NULL
        WHEN Year_2018 = 0 THEN NULL
        ELSE ROUND(((Year_2018 - Year_2016) * 100.0 / Year_2016), 2)
    END AS Growth_Percentage_2016_to_2018
FROM CyberCrimes
WHERE Year_2016 > 0 AND Year_2018 > 0
ORDER BY Growth_Percentage_2016_to_2018 DESC;


/*
================================================================================
END OF ANALYSIS
================================================================================
*/