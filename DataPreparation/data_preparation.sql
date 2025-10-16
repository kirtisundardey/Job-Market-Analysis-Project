-- Create database for cleaning --
DROP DATABASE IF EXISTS job_market_analysis;
CREATE DATABASE job_market_analysis;
USE job_market_analysis;

-- view all tables --
SELECT * FROM job_market_analysis.market;

-- Copy of dataset --
DROP TABLE IF EXISTS job_market_analysis.market_copy;
CREATE TABLE job_market_analysis.market_copy AS
SELECT * FROM job_market_analysis.market;

-- remove some column's for we don't need for further visualization --
ALTER TABLE job_market_analysis.market
DROP COLUMN ID,
DROP COLUMN FIELD4,
DROP COLUMN Competitors,
DROP COLUMN Company_Name,
DROP COLUMN Size,
DROP COLUMN Salary_Estimate,
DROP COLUMN Headquarters,
DROP COLUMN Revenue;

-- rename column's for better understanding --
ALTER TABLE job_market_analysis.market
CHANGE COLUMN Job_Title Jobs_Name VARCHAR(100),
CHANGE COLUMN Location Job_City VARCHAR(35),
CHANGE COLUMN Founded Company_Founded_Year INT,
CHANGE COLUMN Hourly Hourly_Salary BIT(1),
CHANGE COLUMN Employer_provided Employer_Provided_Salary BIT(1),
CHANGE COLUMN Type_of_ownership Type_Of_Ownership VARCHAR(50),
CHANGE COLUMN company_txt Company_Name VARCHAR(55),
CHANGE COLUMN Avg_SalaryK Salary_Avg DECIMAL(10,2),
CHANGE COLUMN Lower_Salary Salary_Lower DECIMAL(10,2),
CHANGE COLUMN Upper_Salary Salary_Upper DECIMAL(10,2),
CHANGE COLUMN Job_Location Job_State VARCHAR(50),
CHANGE COLUMN Age Company_Age INT(10),
CHANGE COLUMN Python Python BIT(1),
CHANGE COLUMN spark Spark BIT(1),
CHANGE COLUMN aws AWS BIT(1),
CHANGE COLUMN excel Excel BIT(1),
CHANGE COLUMN sql_ `SQL` BIT(1),
CHANGE COLUMN sas SAS BIT(1),
CHANGE COLUMN keras Keras BIT(1),
CHANGE COLUMN pytorch PyTorch BIT(1),
CHANGE COLUMN scikit `Scikit-learn` BIT(1),
CHANGE COLUMN hadoop Hadoop BIT(1),
CHANGE COLUMN tensor TensorFlow BIT(1),
CHANGE COLUMN tableau Tableau BIT(1),
CHANGE COLUMN bi `Power BI` BIT(1),
CHANGE COLUMN flink Flink BIT(1),
CHANGE COLUMN mongo MongoDB BIT(1),
CHANGE COLUMN google_an `Google Analytics` BIT(1),
CHANGE COLUMN job_title_sim Job_Title_Sim VARCHAR(50),
CHANGE COLUMN seniority_by_title Seniority_Level VARCHAR(50),
CHANGE COLUMN Degree Employee_Degree VARCHAR(50);

-- modify some column's data type --
ALTER TABLE job_market_analysis.market
MODIFY Rating DECIMAL(3,1),
MODIFY Sector VARCHAR(50),
MODIFY Industry VARCHAR(50);

-- remove duplicate rows --
DROP TABLE IF EXISTS job_market_analysis.market_temp;
CREATE TABLE job_market_analysis.market_temp AS
SELECT DISTINCT * FROM job_market_analysis.market;
DROP TABLE job_market_analysis.market;
RENAME TABLE job_market_analysis.market_temp TO job_market_analysis.market;

-- Add index in the market table --
ALTER TABLE job_market_analysis.market
ADD COLUMN Company_id INT AUTO_INCREMENT PRIMARY KEY;

-- extract the city name before comma --
UPDATE job_market_analysis.market
SET Job_City = TRIM(SUBSTRING_INDEX(Job_City, ',', 1));

-- check the unique values of 'Job_State' --
SELECT DISTINCT Job_State
FROM job_market_analysis.market;

-- as you see 'Job_State' have abbreviations of State name --
-- mapping abbreviations to full names (Getting it from Google) --
UPDATE job_market_analysis.market
SET Job_State = CASE UPPER(TRIM(Job_State))
    WHEN 'AL' THEN 'Alabama'
    WHEN 'AK' THEN 'Alaska'
    WHEN 'AZ' THEN 'Arizona'
    WHEN 'AR' THEN 'Arkansas'
    WHEN 'CA' THEN 'California'
    WHEN 'CO' THEN 'Colorado'
    WHEN 'CT' THEN 'Connecticut'
    WHEN 'DE' THEN 'Delaware'
    WHEN 'FL' THEN 'Florida'
    WHEN 'GA' THEN 'Georgia'
    WHEN 'HI' THEN 'Hawaii'
    WHEN 'ID' THEN 'Idaho'
    WHEN 'IL' THEN 'Illinois'
    WHEN 'IN' THEN 'Indiana'
    WHEN 'IA' THEN 'Iowa'
    WHEN 'KS' THEN 'Kansas'
    WHEN 'KY' THEN 'Kentucky'
    WHEN 'LA' THEN 'Louisiana'
    WHEN 'ME' THEN 'Maine'
    WHEN 'MD' THEN 'Maryland'
    WHEN 'MA' THEN 'Massachusetts'
    WHEN 'MI' THEN 'Michigan'
    WHEN 'MN' THEN 'Minnesota'
    WHEN 'MS' THEN 'Mississippi'
    WHEN 'MO' THEN 'Missouri'
    WHEN 'MT' THEN 'Montana'
    WHEN 'NE' THEN 'Nebraska'
    WHEN 'NV' THEN 'Nevada'
    WHEN 'NH' THEN 'New Hampshire'
    WHEN 'NJ' THEN 'New Jersey'
    WHEN 'NM' THEN 'New Mexico'
    WHEN 'NY' THEN 'New York'
    WHEN 'NC' THEN 'North Carolina'
    WHEN 'ND' THEN 'North Dakota'
    WHEN 'OH' THEN 'Ohio'
    WHEN 'OK' THEN 'Oklahoma'
    WHEN 'OR' THEN 'Oregon'
    WHEN 'PA' THEN 'Pennsylvania'
    WHEN 'RI' THEN 'Rhode Island'
    WHEN 'SC' THEN 'South Carolina'
    WHEN 'SD' THEN 'South Dakota'
    WHEN 'TN' THEN 'Tennessee'
    WHEN 'TX' THEN 'Texas'
    WHEN 'UT' THEN 'Utah'
    WHEN 'VT' THEN 'Vermont'
    WHEN 'VA' THEN 'Virginia'
    WHEN 'WA' THEN 'Washington'
    WHEN 'WV' THEN 'West Virginia'
    WHEN 'WI' THEN 'Wisconsin'
    WHEN 'WY' THEN 'Wyoming'
    WHEN 'DC' THEN 'District of Columbia'
    ELSE Job_State
END;

-- 'Salary_Lower', 'Salary_Upper' and 'Salary_Avg' these columns salary are in 'k' form--
-- like so convert these columns into full numbers for visualization
UPDATE job_market_analysis.market
SET
    Salary_Lower = Salary_Lower * 1000,
    Salary_Upper = Salary_Upper * 1000,
    Salary_Avg = Salary_Avg * 1000;
    
-- check the unique values of 'Job_Title_Sim' -- 
SELECT DISTINCT Job_Title_Sim
FROM job_market_analysis.market;

-- clean 'Job_Title_Sim' column for visualization --
UPDATE job_market_analysis.market
SET Job_Title_Sim = CASE
    WHEN LOWER(Job_Title_Sim) = 'data scientist' THEN 'Data Scientist'
    WHEN LOWER(Job_Title_Sim) = 'data scientist project manager' THEN 'Data Scientist'
    WHEN LOWER(Job_Title_Sim) = 'analyst' THEN 'Data Analyst'
    WHEN LOWER(Job_Title_Sim) = 'data analitics' THEN 'Data Analyst'
    WHEN LOWER(Job_Title_Sim) = 'data engineer' THEN 'Data Engineer'
    WHEN LOWER(Job_Title_Sim) = 'data modeler' THEN 'Data Modeler'
    WHEN LOWER(Job_Title_Sim) = 'machine learning engineer' THEN 'ML Engineer'
    WHEN LOWER(Job_Title_Sim) = 'other scientist' THEN 'Other Scientist'
    WHEN LOWER(Job_Title_Sim) = 'director' THEN 'Director'
    WHEN LOWER(Job_Title_Sim) = 'na' THEN 'Not Specified'
    ELSE Job_Title_Sim
END;

-- check the unique values of 'Seniority_Level' -- 
SELECT DISTINCT Seniority_Level
FROM job_market_analysis.market;

-- clean 'Seniority_Level' for visualization --
UPDATE job_market_analysis.market
SET Seniority_Level = CASE
    WHEN LOWER(Seniority_Level) = 'sr' THEN 'Senior'
    WHEN LOWER(Seniority_Level) = 'jr' THEN 'Junior'
    WHEN LOWER(Seniority_Level) = 'na' OR Seniority_Level IS NULL THEN 'Not Specified'
    ELSE Seniority_Level
END;

-- check the unique values of 'Employee_Degree' -- 
SELECT DISTINCT Employee_Degree
FROM job_market_analysis.market;

-- clean 'Employee_Degree' for visualization --
UPDATE job_market_analysis.market
SET Employee_Degree = CASE
    WHEN LOWER(Employee_Degree) = 'm' THEN 'Masters'
    WHEN LOWER(Employee_Degree) = 'p' THEN 'PhD'
    WHEN LOWER(Employee_Degree) = 'na' THEN 'Not Specified'
    ELSE Employee_Degree
END;

-- check the unique values of 'Type_Of_Ownership' -- 
SELECT DISTINCT Type_Of_Ownership
FROM job_market_analysis.market;

-- create new column for visualization 'Ownership_Category' --
ALTER TABLE job_market_analysis.market
ADD COLUMN Ownership_Category VARCHAR(50);

UPDATE job_market_analysis.market
SET Ownership_Category = CASE
    WHEN Type_Of_Ownership = 'Company - Private' THEN 'Corporate'
    WHEN Type_Of_Ownership = 'Company - Public' THEN 'Corporate'
    WHEN Type_Of_Ownership = 'Subsidiary or Business Segment' THEN 'Corporate'
    WHEN Type_Of_Ownership = 'Government' THEN 'Government'
    WHEN Type_Of_Ownership = 'Hospital' THEN 'Healthcare'
    WHEN Type_Of_Ownership = 'Nonprofit Organization' THEN 'Nonprofit'
    WHEN Type_Of_Ownership = 'College / University' THEN 'Education'
    WHEN Type_Of_Ownership = 'School / School District' THEN 'Education'
    WHEN Type_Of_Ownership = 'Other Organization' THEN 'Other'
    ELSE 'Not Specified'
END;

-- replace -1 with Unknown / Non-Applicable the categorical column --
-- replace -1 with 0 in numerical column --
-- replace -1 With Null in 'Company_Founded_Year' --
UPDATE job_market_analysis.market
SET 
    Industry = CASE WHEN Industry = '-1' THEN 'Unknown / Non-Applicable' ELSE Industry END,
    Sector = CASE WHEN Sector = '-1' THEN 'Unknown / Non-Applicable' ELSE Sector END,
    Rating = CASE WHEN Rating = -1 THEN 0 ELSE Rating END,
    Company_Age = CASE WHEN Company_Age = -1 THEN 0 ELSE Company_Age END,
    Company_Founded_Year = CASE WHEN Company_Founded_Year = -1 THEN NULL ELSE Company_Founded_Year END;

-- Download our data table for visualization --
SELECT * FROM job_market_analysis.market;

-- Download also this data for visualization --
-- for question number 9.Skills Required by Companies for Each Job Title visualization --
CREATE VIEW skill_summary AS
(
  SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Python' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE Python = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Spark' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE Spark = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'AWS' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE AWS = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Excel' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE Excel = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'SQL' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE `SQL` = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'SAS' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE SAS = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Keras' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE Keras = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'PyTorch' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE `PyTorch` = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Scikit-learn' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE `Scikit-learn` = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'TensorFlow' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE TensorFlow = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Hadoop' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE Hadoop = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Tableau' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE Tableau = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Power BI' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE `Power BI` = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Flink' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE Flink = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'MongoDB' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE MongoDB = 1
GROUP BY Job_Title_Sim, Jobs_Name
UNION ALL
SELECT 
    Job_Title_Sim,
    Jobs_Name,
    'Google Analytics' AS Skill,
    COUNT(*) AS Job_Count
FROM market
WHERE `Google Analytics` = 1
GROUP BY Job_Title_Sim, Jobs_Name
);

-- To see the view --
SELECT * FROM job_market_analysis.skill_summary;


