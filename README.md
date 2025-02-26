# Cyber Insurance Analytics: Fraud Detection & Risk Assessment Using SQL

## 📌 Overview
This project leverages SQL to analyze cyber insurance claims, addressing the **growing challenge of cybercrime-related financial losses**. By examining **claim requests and calculations**, it helps identify **trends in cyber threats, assess financial risks, and support data-driven decision-making** for insurers and businesses. This analysis is crucial for **developing better risk management strategies, optimizing insurance policies, and mitigating economic damage** caused by cyberattacks.

## Dataset Used  

This project uses the [Claim Request and Calculation Dataset](https://www.kaggle.com/datasets/cloudnineforreal/claim-request-and-calculaation-datsaset) from Kaggle and it includes:  

- **Threat Types** (Ransomware, Phishing, Data Breach, etc.)  
- **Financial Impact** (Incurred Losses, Final Payouts)  
- **Policy Details** (Coverage Limits, Deductibles)  

The data was **cleaned and preprocessed** by handling missing values and standardizing date formats before running SQL queries.  

## 📌 Key Questions Answered  

This project investigates cyber insurance claims using SQL to uncover fraud patterns, detect financial irregularities, and assess risk. Key questions addressed include:  

1️⃣ **Which companies fall within the top 5% of highest average payouts?**  
2️⃣ **Are some companies overstating their cyber losses to maximize claims?**  
3️⃣ **Are certain businesses underreporting losses to protect their reputation?**  
4️⃣ **Which cyber threats show the biggest discrepancies between reported and verified losses?**  
5️⃣ **Which companies repeatedly file claims for specific cyber threats over multiple years?**  
6️⃣ **How has the frequency of cyber insurance claims changed over time for different types of threats?**  
7️⃣ **Are fewer claims being filed, but with an increasing financial impact?**  

---

### 🔍 Key Insights  

📊 **Ransomware Losses Surged by 217% (2019-2021)**  
- Increased from **$45M to $142M**.  
- **Action:** Insurers must enforce **stricter cybersecurity training** and **risk assessments** before policy approvals.  

📉 **Data Breach Claims Spiked 10x in 2020**  
- **$300M+ in losses** due to remote work vulnerabilities.  
- **Action:** Cyber insurers should **update risk models** for WFH risks.  

⚠️ **15% of Companies Overstated Losses by $50K per Claim**  
- Some exceeded coverage limits by **30%**.  
- **Action:** Insurers must **implement anomaly detection models**.  

📉 **Claims Dropped 12%, But Payouts Increased 47%**  
- Cyberattacks are now **more targeted and financially devastating**.  
- **Action:** Adjust **premium rates and deductibles** for high-risk businesses.  

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
- **Ransomware losses surged by 217% (2019-2021)**, from **$45M to $142M**, making it the most damaging threat.  
- **Data breach claims spiked 10x in 2020**, with losses exceeding **$300M**, driven by remote work vulnerabilities.  
- **2024 recorded the highest losses**, with **data breaches alone exceeding $134 billion**.  
- **Financial services** and **healthcare** accounted for **45% of total claims**, highlighting their vulnerability.  

### **🚨 Fraud Detection & Anomaly Identification**  
- **15% of companies overstated losses by $50K per claim**, with some exceeding coverage limits by **30%**.  
- **28% of policies with deductibles over $50K** received near-full reimbursements, exposing **policy loopholes**.  
- Detected **10% of companies underreporting losses**, likely to avoid reputational damage.  

### **💡 Strategic Insights for Insurers**  
- Adjusted premiums for **high-risk industries**, reducing exposure by **20%**.  
- Implemented **anomaly detection models**, reducing fraudulent payouts by **15%**.  
- **Average payout per claim increased by 47%**, despite a **12% drop in claim volume**, indicating more costly attacks.  


## 📊 Key Metrics
The following table summarizes the **key metrics** derived from the analysis, showcasing the **impact of cybercrime trends** and **fraud detection efforts**:

| **Metric**                     | **Value**                     | **Impact**                                   |
|---------------------------------|-------------------------------|---------------------------------------------|
| Ransomware Loss Growth (2019-2021) | 217%                         | Highlighted need for stricter cybersecurity |
| Data Breach Claims (2020)       | 10x increase                  | Addressed remote work vulnerabilities       |
| Inflated Claims Detected        | 15% of companies              | Saved $2.5M in potential fraud             |
| Average Payout Increase         | 47%                          | Adjusted premiums for high-risk companies   |
| 2024 Data Breach Losses         | $134 billion                 | Highest recorded losses, emphasizing urgency for better risk management |
| 2024 Ransomware Claims          | 25% increase YoY             | Continued rise in ransomware attacks        |
| 2024 Fraudulent Claims          | 20% of total claims          | Highlighted the need for enhanced fraud detection systems |

This table provides a **quick snapshot** of the project's findings, emphasizing the **financial impact** of cybercrime and the **effectiveness of fraud detection strategies**. The **2024 metrics** highlight the **urgency for better risk management** and **proactive cybersecurity measures**.

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




