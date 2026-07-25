# Tableau

`IBM_Telco_Churn_Dashboards.twbx` — packaged workbook containing:

| Sheet | Contents |
| :--- | :--- |
| **Overview** | KPIs, Churn Risk Matrix, churn by contract / city / tenure / internet type |
| **Why They Churn** | contract, payment method, internet type, security & support bundle |
| **Where They Churn** | California map, top churn cities, population density |
| **Recommendations** | five findings paired with recommendations and expected impact |
| **Churn Story** | a guided story that walks the four dashboards in order |

The workbook connects to the SQL Server database `IBM_Telco` and combines the five tables
with **Relationships** (not physical joins), so each table keeps its own level of detail.

Open with Tableau Desktop or Tableau Public.
