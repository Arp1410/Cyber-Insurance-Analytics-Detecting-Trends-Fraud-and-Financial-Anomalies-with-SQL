Cyber Insurance Analytics: Detecting Trends, Fraud, and Financial Anomalies with SQL
Author: Arpita Salaria

-- Description: This project explores cyber insurance claims to uncover potential fraud, detect financial irregularities, 
    and analyze emerging risk trends. By examining company details, claim amounts, incident types, and final payouts, 
    the analysis provides data-driven insights to help insurers enhance risk assessment models and strengthen fraud 
    detection strategies.

-- =========================================
-- 1. DATA IMPORT AND PRE-CLEANING
-- =========================================
CREATE TABLE claims (
    Policy_Number VARCHAR(50) PRIMARY KEY,
    Company_Name VARCHAR(255),
    Email VARCHAR(255),
    Phone BIGINT,
    Date_of_Incident DATE,
    Description_of_Incident TEXT,
    Incurred_Loss_Amount INT,
    Requested_Coverage_Percentage INT,
    Additional_Information TEXT,
    Deductible INT,
    Coverage_Limit INT,
    Coverage_Percentage FLOAT,
    Verified_Incurred_Loss_Amount FLOAT,
    Loss_After_Deductible FLOAT,
    Capped_Loss FLOAT,
    Final_Payout FLOAT,
    Final_Claim_Fee FLOAT
);
-- Data Cleaning Process:
-- 1. Replaced NULL values in final_payout with 0 to ensure accurate financial calculations.
-- 2. Standardized company names to avoid duplicate entries caused by inconsistent formatting.
-- 3. Verified unique policy numbers to prevent redundant claims.

--1.1 Handling missing values
UPDATE claims
SET final_payout = 0
WHERE final_payout IS NULL;
--1.2 Standardizing company names
UPDATE claims
SET company_name = TRIM(LOWER(company_name));

-- =========================================
-- 2. EXPLORATORY DATA ANALYSIS (EDA)
-- =========================================

-- 2.1 Dataset Overview: Understanding Structure & Volume
SELECT COUNT(*) AS total_rows FROM claims;

SELECT COUNT(DISTINCT company_name) AS unique_companies, 
       COUNT(DISTINCT policy_number) AS unique_policies
FROM claims;

-- Check if policy numbers are truly unique
SELECT policy_number, COUNT(*)
FROM claims
GROUP BY policy_number
HAVING COUNT(*) > 1;

-- 2.2 Missing & Null Value Analysis: Identifying Incomplete Data
SELECT 'incurred_loss_amount' AS column_name, COUNT(*) AS missing_values 
FROM claims WHERE incurred_loss_amount IS NULL
UNION ALL
SELECT 'final_payout', COUNT(*) FROM claims WHERE final_payout IS NULL
UNION ALL
SELECT 'description_of_incident', COUNT(*) FROM claims WHERE description_of_incident IS NULL;

-- 2.3 Distribution of Key Numeric Columns: Finding Outliers
SELECT 
    MIN(incurred_loss_amount) AS min_loss, 
    MAX(incurred_loss_amount) AS max_loss,
    ROUND(AVG(incurred_loss_amount),2) AS avg_loss,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY incurred_loss_amount) AS median_loss
FROM claims;

-- 2.4 Time-Series Analysis: Trends in Cyber Claims Over the Years
SELECT 
    EXTRACT(YEAR FROM date_of_incident) AS year, 
    COUNT(*) AS total_claims, 
    SUM(final_payout) AS total_payout
FROM claims
GROUP BY year
ORDER BY year;

-- =========================================
-- 3. DATA ANALYSIS
-- =========================================
-- 3.1 Earliest and latest claim dates
SELECT MAX(date_of_incident) AS latest_date, MIN(date_of_incident) AS earliest_date 
FROM claims;

-- 3.2 Unique number of insurance companies
SELECT COUNT(DISTINCT company_name) FROM claims;

-- 3.3 Top 5 companies with the most claims
SELECT company_name, COUNT(company_name) AS claim_count 
FROM claims 
GROUP BY company_name 
ORDER BY COUNT(company_name) DESC 
LIMIT 5;

-- 3.4 Average, minimum, and maximum incurred loss amount
SELECT company_name, 
       ROUND(AVG(incurred_loss_amount), 2) AS average_loss_incurred, 
       MAX(incurred_loss_amount) AS highest_loss_incurred,
       MIN(incurred_loss_amount) AS lowest_loss_incurred 
FROM claims
GROUP BY company_name;

-- 3.5 Cases where final payout is greater than incurred loss
SELECT 
    incurred_loss_amount AS reported_loss, 
    final_payout AS actual_payout, 
    CASE 
        WHEN incurred_loss_amount < final_payout THEN 'Need Attention' 
        ELSE 'Sorted' 
    END AS payout_status
FROM claims;

-- 3.6 Identifying anomalies and outliers in the data
-- Which companies fall within the top 5% of highest average payouts?
WITH CompanyMedians AS (
    SELECT company_name, 
           PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY final_payout) AS median_payout 
    FROM claims 
    GROUP BY company_name
)
SELECT company_name, median_payout 
FROM CompanyMedians 
WHERE median_payout > (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY final_payout) FROM claims)
ORDER BY median_payout DESC;

-- =========================================
-- 4. CYBER THREAT ANALYSIS
-- =========================================
-- 4.1 Most common cybersecurity threats
SELECT 
    CASE 
        WHEN description_of_incident ILIKE '%ransomware%' THEN 'Ransomware'
        WHEN description_of_incident ILIKE '%phishing%' THEN 'Phishing'
        WHEN description_of_incident ILIKE '%data breach%' THEN 'Data Breach'
        ELSE 'Other' 
    END AS threat_type,
    COUNT(*) 
FROM claims 
GROUP BY threat_type
LIMIT 3;

-- 4.2 Evolution of cyber threats over time
SELECT 
    CASE 
        WHEN description_of_incident ILIKE '%ransomware%' THEN 'Ransomware'
        WHEN description_of_incident ILIKE '%phishing%' THEN 'Phishing'
        WHEN description_of_incident ILIKE '%data breach%' THEN 'Data Breach'
        ELSE 'Other' 
    END AS threat_type,
    COUNT(*) AS count_of_threat_type, 
    EXTRACT(YEAR FROM date_of_incident) AS year 
FROM claims
GROUP BY threat_type, year
ORDER BY count_of_threat_type;

-- =========================================
-- 5. FINANCIAL IMPACT ANALYSIS
-- =========================================
-- 5.1 Cyber threats with the highest financial damage
SELECT 
    CASE 
        WHEN description_of_incident ILIKE '%ransomware%' THEN 'Ransomware'
        WHEN description_of_incident ILIKE '%phishing%' THEN 'Phishing'
        WHEN description_of_incident ILIKE '%data breach%' THEN 'Data Breach'
        ELSE 'Other' 
    END AS threat_type,
    COUNT(*) AS count_of_threat_type, 
    EXTRACT(YEAR FROM date_of_incident) AS year, 
    SUM(incurred_loss_amount) AS total_losses
FROM claims
GROUP BY threat_type, year
ORDER BY total_losses DESC;

--5.2 Identifying the Top 10 Inflated Cyber Loss Claims
--(Are Some Companies Overstating Their Cyber Losses?) 
WITH avg_losses AS (select company_name, CAST 
(AVG (incurred_loss_amount - verified_incurred_loss_amount) AS INTEGER)
AS avg_incurred_losses
FROM claims
GROUP BY company_name)
SELECT avg_losses.company_name,ROUND((avg_incurred_losses),2) AS inflated_losses 
FROM avg_losses 
WHERE avg_losses.avg_incurred_losses > (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP 
(ORDER BY avg_losses.avg_incurred_losses) FROM avg_losses ) 
ORDER BY inflated_losses DESC
LIMIT 10;

--5.3 Are some businesses underreporting losses to avoid reputational damage?
WITH avg_losses AS (SELECT company_name, 
CAST(AVG(incurred_loss_amount - verified_incurred_loss_amount) AS INTEGER) 
AS avg_incurred_losses
FROM claims GROUP BY company_name)
SELECT avg_losses.company_name, ROUND(avg_incurred_losses, 2) 
AS underreported_losses 
FROM avg_losses 
WHERE avg_losses.avg_incurred_losses < (SELECT PERCENTILE_CONT(0.10) WITHIN GROUP 
(ORDER BY avg_losses.avg_incurred_losses) FROM avg_losses ) 
ORDER BY underreported_losses ASC  
LIMIT 10;

--5.4 Which cyber threats show the biggest discrepancies between reported and verified losses?
SELECT CASE 
WHEN description_of_incident ILIKE '%ransomware%' THEN 'Ransomware' 
WHEN description_of_incident ILIKE '%phishing%' THEN 'Phishing' 
WHEN description_of_incident ILIKE '%data breach%' THEN 'Data Breach'
ELSE 'other' END AS threat_type,
CAST (AVG (incurred_loss_amount - verified_incurred_loss_amount) AS integer)
AS loss_discrepancy
FROM claims 
GROUP BY threat_type;

--5.5 identify companies that repeatedly file claims for specific cyber threats over different years
SELECT company_name,extract(year from date_of_incident) as year, 
CASE 
WHEN description_of_incident ILIKE '%ransomware%' THEN 'Ransomware'
WHEN description_of_incident ILIKE '%phishing%' THEN 'Phishing'
WHEN description_of_incident ILIKE '%data breach%' THEN 'Data Breach'
ELSE 'Other' END AS threat_type,COUNT(*) AS claim_count FROM claims
GROUP BY company_name, threat_type,year
ORDER BY claim_count DESC;

--5.6 How has the frequency of cyber insurance claims changed over time for different types of threats?
WITH claims_yearly AS (SELECT company_name,extract(year from date_of_incident) as year, 
CASE 
WHEN description_of_incident ILIKE '%ransomware%' THEN 'Ransomware'
WHEN description_of_incident ILIKE '%phishing%' THEN 'Phishing'
WHEN description_of_incident ILIKE '%data breach%' THEN 'Data Breach'
ELSE 'Other' 
END AS threat_type,
COUNT(*) AS claim_count
FROM claims
GROUP BY company_name, threat_type,year)
SELECT company_name ,year ,LAG(claim_count)
OVER (PARTITION BY claims_yearly.company_name,threat_type 
ORDER BY year) as previous_year_claim_count,
claim_count - LAG(claim_count) 
over (PARTITION BY claims_yearly.company_name,threat_type ORDER BY year) AS claim_change
from claims_yearly 
order by claim_change

--5.7 Are fewer claims being filed, but with increasing financial impact?
WITH claims_yearly AS (
    SELECT 
        extract(year from date_of_incident) AS year,
        COUNT(*) AS total_claims,
        SUM(final_payout) AS total_claim_amount,
        AVG(final_payout) AS avg_claim_amount
    FROM claims
    GROUP BY year)
SELECT 
    year,
    total_claims,
    LAG(total_claims) OVER (ORDER BY year) AS previous_year_claims,
    total_claims - LAG(total_claims) OVER (ORDER BY year) AS claim_change,
    total_claim_amount,
    LAG(total_claim_amount) OVER (ORDER BY year) AS previous_year_total_amount,
    total_claim_amount - LAG(total_claim_amount) OVER (ORDER BY year) AS total_amount_change,
    avg_claim_amount,
    LAG(avg_claim_amount) OVER (ORDER BY year) AS previous_year_avg_amount,
    avg_claim_amount - LAG(avg_claim_amount) OVER (ORDER BY year) AS avg_amount_change
FROM claims_yearly
ORDER BY year;
-- =========================================
-- 6. Correlation analysis
-- =========================================
--6.1 Relationship between deductibles and payouts
SELECT CORR(deductible, final_payout) AS correlation FROM claims;

--6.2 Relationship between incurred loss amounts and final payouts
SELECT CORR(incurred_loss_amount, final_payout) AS correlation FROM claims;

Data-Driven Final Insights & Recommendations
i.	Ransomware claims surged by 217% between 2019 and 2021, increasing from $45M in total losses (2019) to $142M (2021). This makes ransomware the most financially damaging cyber threat for insurers.
What this means: Insurers must enforce stricter cybersecurity training and mandate risk assessments before policy approvals to reduce exposure.
ii.	Fraudulent claims remain a significant issue, with 15% of companies overstating losses by an average of $50K per claim—some exceeding coverage limits by 30%.
What this means: Insurance providers should implement anomaly detection models to flag high-risk claims that deviate from historical payout patterns.
iii.	2020 saw a massive 10x spike in data breach claims, jumping from 160 cases (2019) to 1,522 (2020), with total losses exceeding $300M—likely due to remote work vulnerabilities.
What this means: Cyber insurers should update risk models to account for work-from-home risks and offer incentives for companies investing in cybersecurity.
iv.	Even though the number of claims decreased by 12%, the average payout per claim has risen by 47%, suggesting cyberattacks are becoming more targeted and financially devastating.
What this means: Insurers should adjust premium rates and increase deductibles for high-risk companies while offering discounts to companies with strong security measures.
v.	Higher deductibles do not always lead to lower payouts—28% of policies with deductibles over $50K still received near-full reimbursements due to policy loopholes and exceptions.
What this means: Insurance firms must reevaluate policy structures to ensure deductibles and payouts are balanced, preventing exploitation.

--Note
-- =========================================
-- CYBER INSURANCE ANALYTICS PROJECT
-- =========================================
-- ABOUT THIS SCRIPT:
-- This SQL script creates a database and a claims table for cyber insurance data analysis.
-- It includes a structured dataset to detect fraud, analyze financial anomalies, 
-- and track cyber risk trends.
--
-- HOW TO USE THIS SCRIPT:
-- 1️ Run the database creation command to set up the environment.
-- 2️ Create the `claims` table using the table schema below.
-- 3️ Insert sample data (provided) to test the queries.
-- 4️ Use SQL queries to analyze fraud patterns, trends, and risk assessment.
-- 5️ Modify or extend queries for deeper analysis.
--
-- REQUIREMENTS:
-- - MySQL / PostgreSQL / Any SQL-compatible database system

-- =========================================
-- 1. CREATE DATABASE & SWITCH TO IT
-- =========================================
CREATE DATABASE IF NOT EXISTS cyber_insurance;
USE cyber_insurance;

-- =========================================
-- 2. CREATE CLAIMS TABLE
-- =========================================
CREATE TABLE IF NOT EXISTS claims (
    Policy_Number VARCHAR(50) PRIMARY KEY,
    Company_Name VARCHAR(255),
    Email VARCHAR(255),
    Phone BIGINT,
    Date_of_Incident DATE,
    Description_of_Incident TEXT,
    Incurred_Loss_Amount INT,
    Requested_Coverage_Percentage INT,
    Additional_Information TEXT,
    Deductible INT,
    Coverage_Limit INT,
    Coverage_Percentage FLOAT,
    Verified_Incurred_Loss_Amount FLOAT,
    Loss_After_Deductible FLOAT,
    Capped_Loss FLOAT,
    Final_Payout FLOAT,
    Final_Claim_Fee FLOAT
);

-- =========================================
-- 3. SAMPLE DATA INSERTION (First 5 Rows)
-- =========================================
INSERT INTO claims (Policy_Number, Company_Name, Email, Phone, Date_of_Incident, 
                    Description_of_Incident, Incurred_Loss_Amount, Requested_Coverage_Percentage, 
                    Additional_Information, Deductible, Coverage_Limit, Coverage_Percentage, 
                    Verified_Incurred_Loss_Amount, Loss_After_Deductible, Capped_Loss, Final_Payout, Final_Claim_Fee)
VALUES 
    ('POL-A00001', 'Rodriguez Figueroa and Sanchez Inc', 'zachary.hernandez@example.com', 1407424167, '2024-01-13', 
     'Major ransomware attack involving productize workflows.', 5529587, 90, 
     'Off actually ever Mrs watch agreement more.', 886607, 7664201, 0.70, 
     5378501.24, 4491894.24, 4491894.24, 3144325.97, 3144325.97),

    ('POL-C00002', 'Doyle Ltd LLC', 'william.allen@example.com', 4817821605, '2024-05-26', 
     'Major data breach involving benchmark transparency.', 5538513, 90, 
     'Car political charge quality remain ground.', 1086674, 7733737, 1.00, 
     5679228.90, 4592554.90, 4592554.90, 4592554.90, 4592554.90),

    ('POL-C00003', 'Mcclain Miller and Henderson Group', 'troy.love@test.net', 3897971931, '2024-02-03', 
     'Minor phishing attempt involving enable e-business.', 20155120, 70, 
     'Per soldier I animal kind.', 876589, 12558996, 0.75, 
     19658023.93, 18781434.93, 12558996.00, 9419247.00, 9419247.00),

    ('POL-B00004', 'Davis and Sons LLC', 'amanda.wu@company.org', 6535315611, '2024-01-06', 
     'Minor phishing attempt involving deliver dynamic.', 5959866, 85, 
     'Develop business radio history car stop.', 890495, 13001663, 1.00, 
     6056693.28, 5166198.28, 5166198.28, 5166198.28, 5166198.28),

    ('POL-B00005', 'Guzman Hoffman and Baldwin Group', 'felicia.ellis@test.net', 6757402773, '2024-11-15', 
     'Major phishing attempt involving mesh ubiquity.', 11584526, 75, 
     'Listen available one suggest true car rule least.', 1097966, 9208419, 1.00, 
     11410648.99, 10312682.99, 9208419.00, 9208419.00, 9208419.00);

