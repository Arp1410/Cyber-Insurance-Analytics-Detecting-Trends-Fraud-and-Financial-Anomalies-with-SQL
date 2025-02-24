# Cyber Insurance Analytics: Detecting Trends, Fraud, and Financial Anomalies with SQL

## 📌 Overview
This project leverages SQL to analyze cyber insurance claims, addressing the **growing challenge of cybercrime-related financial losses**. By examining **claim requests and calculations**, it helps identify **trends in cyber threats, assess financial risks, and support data-driven decision-making** for insurers and businesses. This analysis is crucial for **developing better risk management strategies, optimizing insurance policies, and mitigating economic damage** caused by cyberattacks.

### 📊 Dataset: [Claim Request and Calculation Dataset (Kaggle)](https://www.kaggle.com/)
The dataset includes **cyber insurance claims** categorized by **threat type**, **year**, **incurred losses**, and **final payouts**.

---

## 🔍 Key Insights 

### 1. **Ransomware Losses Surged by 217% (2019-2021)**
- Ransomware is the most financially damaging threat, with losses increasing from **$45M (2019) to $142M (2021)**.
- **Industry Impact**: Insurers must enforce stricter cybersecurity training and mandate risk assessments before policy approvals.

### 2. **Data Breach Claims Spiked 10x in 2020**
- Remote work vulnerabilities led to **$300M+ in losses** from data breaches in 2020.
- **Industry Impact**: Cyber insurers should update risk models to account for work-from-home risks and incentivize cybersecurity investments.

### 3. **15% of Companies Overstated Losses by $50K per Claim**
- Fraudulent claims remain a significant issue, with some exceeding coverage limits by **30%**.
- **Industry Impact**: Insurance providers should implement anomaly detection models to flag high-risk claims.

### 4. **Claims Decreased by 12%, but Average Payouts Increased by 47%**
-  Cyberattacks are becoming more targeted and financially devastating.
- **Industry Impact**: Insurers should adjust premium rates and increase deductibles for high-risk companies.

---

## 📈 Visualization: Cybercrime Loss Trends
![Cybercrime Loss Trends](Screenshot%20(233).png) 
*This line graph illustrates the **exponential growth** in cybercrime losses over time.*

---

## 🛠️ Skills & Technologies Used  

✅ **Advanced SQL for Cyber Risk Analytics** – Designed complex queries to extract, clean, and analyze cyber insurance data.  

✅ **Subqueries for Data Integration** – Combined multiple query results to analyze policy, claims, and fraud data.  

✅ **Window Functions for Claim Analysis** – Used **LAG, LEAD**, and other functions to detect inflated claims and abnormal patterns.    

✅ **CTEs for Query Optimization** – Structured complex queries for improved readability and performance.  

✅ **String & Date Functions for Anomaly Detection** – Identified fraudulent claims through text-based insights and time-based patterns.  

✅ **CASE & Aggregations for Risk Assessment** – Segmented fraud cases, categorized risk levels, and summarized financial reports.  

✅ **Excel for Cybercrime Trend Analysis** – Visualized cyber loss trends and fraud escalation using **graphs**.  



---

## 📢 Business Value  

### **📊 Cyber Loss Trends & Risk Assessment**  
- **Escalating Cyber Losses:** Analysis of multi-year data revealed a **sharp increase in cyber insurance claims**, with **2024 recording the highest financial impact**. This enables insurers to **adjust pricing models** and **prepare for rising risks**.  
- **Industry-Specific Risk Analysis:** By segmenting claims across industries, we identified **financial services and healthcare as the most vulnerable sectors**, helping insurers tailor cybersecurity policies for high-risk businesses.  
- **Seasonal Patterns in Cyber Incidents:** Identified **high-risk periods where cyber threats peak**, allowing companies to allocate **proactive risk mitigation strategies**.  

### **🚨 Fraud Detection & Anomaly Identification**  
- **Inflated Claims Detection:** Used **Window Functions (LAG, LEAD)** to flag suspicious claims where reported losses exceeded historical trends. This helps insurers **detect fraudulent activity before payout approvals**.  
- **Anomalies in Claim Reporting:** Identified **policyholders with repeated claim discrepancies**, leading to **enhanced fraud monitoring protocols**.  
- **Payout Analysis & Risk Segmentation:** By analyzing **variations in payout structures**, insurers can **detect outliers and prevent policy exploitation**.  

### **💡 Strategic Insights for Insurers**  
- **Optimized Policy Pricing:** Insurers can adjust **premium structures based on real-time fraud patterns**, ensuring **financial sustainability**.  
- **Fraud Prevention Frameworks:** The analysis flagged **key red flags in claim reporting**, guiding insurers to implement **stricter validation processes**.  
- **Data-Driven Risk Assessment:** By leveraging SQL insights, insurers can make **better financial decisions** and **reduce exposure to cyber threats**, leading to **stronger market positioning**.  

---

## 📜 SQL Code Snippets  

**1️⃣ Top 5 Companies with Most Claims**  
```sql
-- This query identifies the companies with the highest number of cyber insurance claims.  
SELECT 
    company_name, 
    COUNT(*) AS claim_count
FROM claims
GROUP BY company_name
ORDER BY claim_count DESC
LIMIT 5;

```
**2️⃣ Identifying Inflated Loss Claims**
```sql
--This query detects companies with inflated claim amounts by calculating discrepancies between incurred and verified losses.

WITH avg_losses AS (
    SELECT 
        company_name, 
        AVG(incurred_loss_amount - verified_incurred_loss_amount) AS avg_incurred_losses
    FROM claims
    GROUP BY company_name
)
SELECT 
    company_name, 
    ROUND(avg_incurred_losses, 2) AS inflated_losses
FROM avg_losses
WHERE avg_incurred_losses > (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY avg_incurred_losses) FROM avg_losses)
ORDER BY inflated_losses DESC
LIMIT 10;

```
**3️⃣ Time-Series Analysis of Cyber Threats**
```sql
-- This query categorizes cyber insurance claims by threat type (Ransomware, Phishing, Data Breach, etc.) and tracks financial losses over time.
---
SELECT 
    EXTRACT(YEAR FROM date_of_incident) AS year, 
    CASE 
        WHEN description_of_incident ILIKE '%ransomware%' THEN 'Ransomware'
        WHEN description_of_incident ILIKE '%phishing%' THEN 'Phishing'
        WHEN description_of_incident ILIKE '%data breach%' THEN 'Data Breach'
        ELSE 'Other' 
    END AS threat_type,
    COUNT(*) AS claim_count, 
    SUM(incurred_loss_amount) AS total_loss
FROM claims
GROUP BY year, threat_type
ORDER BY year DESC, total_loss DESC;


```
---

## 🚀 Let's Connect!  

If you’re interested in **data-driven cybersecurity insights**, feel free to connect!  

📧 **Email:** [arpitasalaria2003@gmail.com](mailto:arpitasalaria2003@gmail.com)  
🔗 **LinkedIn:** [Arpita Salaria](https://www.linkedin.com/in/arpita-salaria-562703263)  

---
---




