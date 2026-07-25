-- 1: نظرة عامة على الـ Churn

-- 1.1. اجمالي العملاء ال Churned ال Joined ونسبة ال Churn العامة
SELECT
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned_Customers,
    SUM(CASE WHEN Customer_Status = 'Joined' THEN 1 ELSE 0 END) AS Joined_Customers,
    CAST(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_status;

-- 1.2. متوسط Satisfaction Score و CLTV حسب Customer Status
SELECT
    Customer_Status,
    AVG(CAST(Satisfaction_Score AS FLOAT)) AS Avg_Satisfaction,
    AVG(CAST(CLTV AS FLOAT)) AS Avg_CLTV
FROM Telco_customer_churn_status
GROUP BY Customer_Status;

-- 2: مين اللي بيسيب؟

-- 2.1. نسبة ال Churn حسب الفئة العمرية
SELECT
    CASE
        WHEN d.Age < 30 THEN '18-29'
        WHEN d.Age BETWEEN 30 AND 44 THEN '30-44'
        WHEN d.Age BETWEEN 45 AND 64 THEN '45-64'
        ELSE '65+ (Senior)'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_demographics d
JOIN Telco_customer_churn_status s ON d.Customer_ID = s.Customer_ID
GROUP BY
    CASE
        WHEN d.Age < 30 THEN '18-29'
        WHEN d.Age BETWEEN 30 AND 44 THEN '30-44'
        WHEN d.Age BETWEEN 45 AND 64 THEN '45-64'
        ELSE '65+ (Senior)'
    END
ORDER BY Churn_Rate_Percent DESC;

-- 2.2. نسبة ال Churn حسب الجنس
SELECT
    d.Gender,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_demographics d
JOIN Telco_customer_churn_status s ON d.Customer_ID = s.Customer_ID
GROUP BY d.Gender;

-- 2.3. نسبة ال Churn حسب الحالة الاجتماعية ووجود Dependents
SELECT
    d.Married,
    d.Dependents,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_demographics d
JOIN Telco_customer_churn_status s ON d.Customer_ID = s.Customer_ID
GROUP BY d.Married, d.Dependents
ORDER BY Churn_Rate_Percent DESC;

-- 3: فين مكان الناس الي بيسيبوا؟
-- 3.1. اعلى 10 مدن في نسبة ال Churn 
SELECT TOP 10
    l.City,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_location l
JOIN Telco_customer_churn_status s ON l.Customer_ID = s.Customer_ID
GROUP BY l.City
HAVING COUNT(*) >= 5
ORDER BY Churned_Count DESC;

-- 3.2. العلاقة بين كثافة السكان ونسبة ال Churn
SELECT
    CASE
        WHEN p.Population < 20000 THEN 'Low Density'
        WHEN p.Population BETWEEN 20000 AND 50000 THEN 'Medium Density'
        ELSE 'High Density'
    END AS Population_Density,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_location l
JOIN Telco_customer_churn_population p ON l.Zip_Code = p.Zip_Code
JOIN Telco_customer_churn_status s ON l.Customer_ID = s.Customer_ID
GROUP BY
    CASE
        WHEN p.Population < 20000 THEN 'Low Density'
        WHEN p.Population BETWEEN 20000 AND 50000 THEN 'Medium Density'
        ELSE 'High Density'
    END
ORDER BY Churn_Rate_Percent DESC;

-- 4: ليه بيسيبوا؟
-- 4.1. نسبة ال Churn حسب نوع العقد
SELECT
    sv.Contract,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY sv.Contract
ORDER BY Churn_Rate_Percent DESC;

-- 4.2. نسبة ال Churn حسب طريقة الدفع
SELECT
    sv.Payment_Method,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY sv.Payment_Method
ORDER BY Churn_Rate_Percent DESC;

-- 4.3. نسبة ال Churn حسب نوع الانترنت
SELECT
    ISNULL(sv.Internet_Type, 'No Internet Service') AS Internet_Type,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY ISNULL(sv.Internet_Type, 'No Internet Service')
ORDER BY Churn_Rate_Percent DESC;

-- 4.4. تأثير Online Security و Tech Support على ال Churn
SELECT
    sv.Online_Security,
    sv.Premium_Tech_Support,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY sv.Online_Security, sv.Premium_Tech_Support
ORDER BY Churn_Rate_Percent DESC;

-- 4.5. متوسط عدد الخدمات المشترك فيها لل Churned مقابل ال Stayed
SELECT
    s.Customer_Status,
    AVG(
        CAST(CASE WHEN sv.Online_Security = 'Yes' THEN 1 ELSE 0 END
           + CASE WHEN sv.Online_Backup = 'Yes' THEN 1 ELSE 0 END
           + CASE WHEN sv.Device_Protection_Plan = 'Yes' THEN 1 ELSE 0 END
           + CASE WHEN sv.Premium_Tech_Support = 'Yes' THEN 1 ELSE 0 END
           + CASE WHEN sv.Streaming_TV = 'Yes' THEN 1 ELSE 0 END
           + CASE WHEN sv.Streaming_Movies = 'Yes' THEN 1 ELSE 0 END
           + CASE WHEN sv.Streaming_Music = 'Yes' THEN 1 ELSE 0 END
           + CASE WHEN sv.Unlimited_Data = 'Yes' THEN 1 ELSE 0 END
        AS FLOAT)
    ) AS Avg_Services_Subscribed
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY s.Customer_Status;

-- 4.6. اهم 5 اسباب لترك الخدمة
SELECT TOP 5
    Churn_Reason,
    COUNT(*) AS Reason_Count
FROM Telco_customer_churn_status
WHERE Churn_Reason IS NOT NULL
GROUP BY Churn_Reason
ORDER BY Reason_Count DESC;

-- 4.7. اهم فئة من اسباب الترك
SELECT
    Churn_Category,
    COUNT(*) AS Category_Count,
    CAST(COUNT(*) AS FLOAT) * 100 / SUM(COUNT(*)) OVER() AS Percentage
FROM Telco_customer_churn_status
WHERE Churn_Category IS NOT NULL
GROUP BY Churn_Category
ORDER BY Category_Count DESC;

-- 5: العلاقة بين الرضا والقيمة وال Churn
-- 5.1. العلاقة بين ال Tenure ونسبة ال Churn
SELECT
    CASE
        WHEN sv.Tenure_in_Months <= 12 THEN '0-1 Year'
        WHEN sv.Tenure_in_Months BETWEEN 13 AND 24 THEN '1-2 Years'
        WHEN sv.Tenure_in_Months BETWEEN 25 AND 48 THEN '2-4 Years'
        ELSE '4+ Years'
    END AS Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY
    CASE
        WHEN sv.Tenure_in_Months <= 12 THEN '0-1 Year'
        WHEN sv.Tenure_in_Months BETWEEN 13 AND 24 THEN '1-2 Years'
        WHEN sv.Tenure_in_Months BETWEEN 25 AND 48 THEN '2-4 Years'
        ELSE '4+ Years'
    END
ORDER BY Churn_Rate_Percent DESC;

-- 5.2. متوسط ال Monthly Charge لل Churned مقابل ال Stayed
SELECT
    s.Customer_Status,
    AVG(sv.Monthly_Charge) AS Avg_Monthly_Charge
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY s.Customer_Status;

-- 5.3. اعلى 10 عملاء من ناحية CLTV سابو فعلا
SELECT TOP 10
    Customer_ID,
    CLTV,
    Churn_Reason
FROM Telco_customer_churn_status
WHERE Customer_Status = 'Churned'
ORDER BY CLTV DESC;

-- 5.4. هل قلة الخدمات بتزود احتمال الترك؟
SELECT
    CASE
        WHEN sv.Internet_Service = 'No' AND sv.Phone_Service = 'No' THEN 'No Services'
        WHEN sv.Internet_Service = 'No' OR sv.Phone_Service = 'No' THEN 'Single Service Only'
        ELSE 'Full Bundle (Phone + Internet)'
    END AS Service_Bundle_Type,
    COUNT(*) AS Total_Customers,
    SUM(s.Churn_Value) AS Churned_Count,
    CAST(SUM(s.Churn_Value) AS FLOAT) * 100 / COUNT(*) AS Churn_Rate_Percent
FROM Telco_customer_churn_services sv
JOIN Telco_customer_churn_status s ON sv.Customer_ID = s.Customer_ID
GROUP BY
    CASE
        WHEN sv.Internet_Service = 'No' AND sv.Phone_Service = 'No' THEN 'No Services'
        WHEN sv.Internet_Service = 'No' OR sv.Phone_Service = 'No' THEN 'Single Service Only'
        ELSE 'Full Bundle (Phone + Internet)'
    END
ORDER BY Churn_Rate_Percent DESC;