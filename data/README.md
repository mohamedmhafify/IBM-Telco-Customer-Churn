# Data

The five raw tables from the IBM sample **Telco Customer Churn** dataset:

- `Telco_customer_churn_demographics.xlsx`
- `Telco_customer_churn_location.xlsx`
- `Telco_customer_churn_population.xlsx`
- `Telco_customer_churn_services.xlsx`
- `Telco_customer_churn_status.xlsx`

**Grain:** the first four are one row per customer (7,043 customers) and join on `Customer_ID`.
`population` is one row per zip code and joins to `location` on `Zip_Code`.

A full column-by-column profile of every table — dtypes, null counts, value distributions —
is in [`../docs/dataset_inspection_report.txt`](../docs/dataset_inspection_report.txt).
