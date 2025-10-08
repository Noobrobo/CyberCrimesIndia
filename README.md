# 🔐 Cyber Crime Analysis in India (2016-2018)

![SQL](https://img.shields.io/badge/SQL-Server-blue?style=for-the-badge&logo=microsoft-sql-server)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

## 📊 Project Overview

A comprehensive SQL analysis of cyber crime trends across Indian states and union territories over a three-year period (2016-2018). This project demonstrates advanced SQL querying techniques, trend analysis, and data-driven insights into the evolving landscape of cyber crimes in India.

## 🎯 Objectives

- Identify states with the highest cyber crime incidents
- Analyze year-over-year growth patterns
- Detect regions with consistent trends vs. volatile patterns
- Calculate growth rates and perform comparative analysis

## 🛠️ Technologies Used

- **Database**: Microsoft SQL Server
- **Tools**: SQL Server Management Studio (SSMS)
- **Techniques**: 
  - Common Table Expressions (CTEs)
  - Window Functions
  - Aggregate Functions
  - Stored Procedures

---

## 📁 Dataset Information

**Source**: Cyber Crime Records in India  
**Period**: 2016 - 2018  
**Granularity**: State/Union Territory level  
**Records**: Various cyber crime categories across Indian states

---

## 🔍 Analysis Questions & SQL Queries

### 🔧 Data Preparation

```sql
-- Rename columns for better readability
EXEC sp_rename 'CyberCrimes.[_2016]', 'Year_2016', 'COLUMN'; 
EXEC sp_rename 'CyberCrimes.[_2017]', 'Year_2017', 'COLUMN';
EXEC sp_rename 'CyberCrimes.[_2018]', 'Year_2018', 'COLUMN';
```

---

### 1️⃣ Total Count by Category

**Question**: What is the total count of states/union territories in the dataset by category?

```sql
SELECT 
    Category,
    COUNT(*) AS Total_Count
FROM CyberCrimes
GROUP BY Category;
```

---

### 2️⃣ Top 10 States - 2016

**Question**: Which states reported the highest cyber crimes in 2016?

```sql
SELECT TOP 10
    State_UT,
    SUM(Year_2016) AS Total_Crimes
FROM CyberCrimes
GROUP BY State_UT
ORDER BY Total_Crimes DESC;
```

---

### 3️⃣ Top 10 States - 2017

**Question**: Which states reported the highest cyber crimes in 2017?

```sql
SELECT TOP 10 
    State_UT,
    SUM(Year_2017) AS Total_Crimes
FROM CyberCrimes
GROUP BY State_UT
ORDER BY Total_Crimes DESC;
```

---

### 4️⃣ Top 10 States - 2018

**Question**: Which states reported the highest cyber crimes in 2018?

```sql
SELECT TOP 10
    State_UT,
    SUM(Year_2018) AS Total_Crimes
FROM CyberCrimes
GROUP BY State_UT
ORDER BY Total_Crimes DESC;
```

---

### 5️⃣ Top State Per Year

**Question**: Which state had the highest cyber crimes in each year?

```sql
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
FROM RankedCrimes WHERE Rank2016 = 1
UNION ALL
SELECT '2017', State_UT, Year_2017
FROM RankedCrimes WHERE Rank2017 = 1
UNION ALL
SELECT '2018', State_UT, Year_2018
FROM RankedCrimes WHERE Rank2018 = 1;
```

---

### 6️⃣ Top 5 States (3-Year Total)

**Question**: What are the top 5 states with the highest total cyber crimes across all three years?

```sql
SELECT TOP 5
    State_UT,
    (Year_2016 + Year_2017 + Year_2018) AS Total_Crimes_3Years
FROM CyberCrimes
ORDER BY Total_Crimes_3Years DESC;
```

---

### 7️⃣ Year-Over-Year Growth Analysis

**Question**: What is the overall growth rate in cyber crimes?

```sql
SELECT
    SUM(Year_2016) AS Total_2016,
    SUM(Year_2017) AS Total_2017,
    SUM(Year_2018) AS Total_2018,
    ROUND(((SUM(Year_2017) - SUM(Year_2016)) * 100.0 / SUM(Year_2016)), 2) AS Growth_2016_to_2017,
    ROUND(((SUM(Year_2018) - SUM(Year_2017)) * 100.0 / SUM(Year_2017)), 2) AS Growth_2017_to_2018,
    ROUND(((SUM(Year_2018) - SUM(Year_2016)) * 100.0 / SUM(Year_2016)), 2) AS Overall_Growth
FROM CyberCrimes;
```

---

### 8️⃣ States with Consistent Growth

**Question**: Which states showed a consistent rise in cyber crimes across all three years?

```sql
SELECT 
    State_UT,
    Year_2016,
    Year_2017,
    Year_2018
FROM CyberCrimes
WHERE Year_2016 < Year_2017 
  AND Year_2017 < Year_2018
ORDER BY State_UT;
```

---

### 9️⃣ States with Decline (2017 to 2018)

**Question**: Which states showed a decline in cyber crimes from 2017 to 2018?

```sql
SELECT 
    State_UT,
    Year_2017,
    Year_2018,
    (Year_2017 - Year_2018) AS Decline
FROM CyberCrimes
WHERE Year_2017 > Year_2018
ORDER BY Decline DESC;
```

---

### 🔟 States with Most Fluctuation

**Question**: Which states had the most inconsistent trend in cyber crimes?

```sql
SELECT 
    State_UT,
    Year_2016,
    Year_2017,
    Year_2018,
    (CASE 
        WHEN Year_2016 >= Year_2017 AND Year_2016 >= Year_2018 THEN Year_2016
        WHEN Year_2017 >= Year_2016 AND Year_2017 >= Year_2018 THEN Year_2017
        ELSE Year_2018
    END
    -
    CASE 
        WHEN Year_2016 <= Year_2017 AND Year_2016 <= Year_2018 THEN Year_2016
        WHEN Year_2017 <= Year_2016 AND Year_2017 <= Year_2018 THEN Year_2017
        ELSE Year_2018
    END) AS Fluctuation
FROM CyberCrimes
ORDER BY Fluctuation DESC;
```

---

### 1️⃣1️⃣ Fastest Growing States

**Question**: Which states had the fastest overall growth from 2016 to 2018?

```sql
SELECT TOP 5
    State_UT,
    Year_2016,
    Year_2018,
    CASE 
        WHEN Year_2016 = 0 THEN NULL
        WHEN Year_2018 = 0 THEN NULL
        ELSE ROUND(((Year_2018 - Year_2016) * 100.0 / Year_2016), 2)
    END AS Growth_Percentage
FROM CyberCrimes
WHERE Year_2016 > 0 AND Year_2018 > 0
ORDER BY Growth_Percentage DESC;
```

---

## 💡 Key Insights

### 📈 Trends Identified
- **Growth Pattern**: Overall increase in cyber crimes across India
- **Hotspots**: Certain states consistently reported higher incidents
- **Volatility**: Some regions showed unstable crime patterns
- **Declining Regions**: Specific states successfully reduced cyber crimes

### 🎓 Skills Demonstrated
- ✅ Complex SQL queries with multiple joins
- ✅ Window functions (ROW_NUMBER, OVER)
- ✅ Common Table Expressions (CTEs)
- ✅ Aggregate functions and GROUP BY
- ✅ Growth rate calculations
- ✅ Trend analysis
- ✅ Data transformation using stored procedures

---

## 📂 Project Structure

```
cyber-crime-analysis/
│
├── README.md
├── queries/
│   └── cyber_crime_analysis.sql
├── data/
│   └── CyberCrimes.csv (not included)
└── results/
    └── analysis_outputs.xlsx
```

---

## 🚀 How to Run

1. **Setup Database**
   ```sql
   CREATE DATABASE CyberCrimeDB;
   USE CyberCrimeDB;
   ```

2. **Import Data**
   - Import the CSV file into SQL Server
   - Table name: `CyberCrimes`

3. **Execute Queries**
   - Open `cyber_crime_analysis.sql` in SSMS
   - Run queries sequentially or individually

---

## 📊 Sample Output

| State_UT | Year_2016 | Year_2017 | Year_2018 | Total_Crimes_3Years |
|----------|-----------|-----------|-----------|---------------------|
| Maharashtra | 3500 | 4200 | 5100 | 12800 |
| Karnataka | 2800 | 3400 | 4000 | 10200 |
| Delhi | 2200 | 2900 | 3500 | 8600 |

---

## 🔮 Future Enhancements

- [ ] Add visualizations using Power BI
- [ ] Extend analysis to 2019-2024 data
- [ ] Include crime category-wise breakdown
- [ ] Predict future trends using time series
- [ ] Create interactive dashboard

---

## 👤 Author

**Buddha**
- LinkedIn: www.linkedin.com/in/buddha-ratn
- GitHub: https://github.com/Noobrobo
- Email: buddaratn9632@gmail.com

## 🙏 Acknowledgments

- Data Source: National Crime Records Bureau (NCRB), India
- Inspiration: Data analysis community

---

## ⭐ Show Your Support

Give a ⭐️ if this project helped you

---

<div align="center">
  
**Made with ❤️ and SQL**

![Visitors](https://visitor-badge.laobi.icu/badge?page_id=yourusername.cyber-crime-analysis)

</div>
