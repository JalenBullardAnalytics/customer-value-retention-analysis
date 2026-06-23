
/* Confirm row count */
SELECT COUNT(*) AS total_rows
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`;

/* Checks for column types and NULLS */
SELECT
  COUNT(*) AS total_customers,
  COUNTIF(Industry IS NULL) AS missing_industry_count,
  COUNTIF(Customer_Status IS NULL) AS missing_status_count,
  COUNTIF(Customer_Lifetime_Value IS NULL) AS missing_clv_count
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`;

/* 1. Identify our top 5 customers by Customer Lifetime Value and determine the segments that contribute the most value to our business. */

/* Identify our top 5 customers */
SELECT
  Customer_Name,
  ROUND(SUM(Customer_Lifetime_Value), 2) AS total_clv
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`
WHERE Customer_Lifetime_Value IS NOT NULL
GROUP BY Customer_Name
ORDER BY total_clv DESC
LIMIT 5;


/* Identify our top customer segments */
SELECT
  Customer_Segment,
  ROUND(SUM(Customer_Lifetime_Value), 2) AS total_clv
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`
WHERE Customer_Lifetime_Value IS NOT NULL
GROUP BY Customer_Segment
ORDER BY total_clv DESC


/* 2. Analyze Customer Lifetime Value across industries and regions to identify which groups generate the highest value for our business. */

/* Top performing industries */
SELECT 
  Industry, 
  ROUND(SUM(Customer_Lifetime_Value), 2) AS total_clv 
FROM round-device-457618-t0.customer_clv_analysis.customer_dimension_clean 
WHERE Customer_Lifetime_Value IS NOT NULL 
GROUP BY Industry 
ORDER BY total_clv DESC

/* Highest performing region across industries */
SELECT
    Industry,
    Region,
    ROUND(SUM(Customer_Lifetime_Value), 2) AS regional_clv
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`
WHERE Customer_Lifetime_Value IS NOT NULL
  AND Industry IS NOT NULL
GROUP BY Industry, Region
ORDER BY Industry, regional_clv DESC;


/* 3. Analyze customer inactivity across customer segments, industries, and regions to identify where retention issues are occurring. */

/* Inactive Customers by Segment */
SELECT
    Customer_Segment,
    COUNT(*) AS inactive_customers
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`
WHERE Customer_Status = 'Inactive'
GROUP BY Customer_Segment
ORDER BY inactive_customers DESC;

/* Inactive Customers by Industry */
SELECT
    Industry,
    COUNT(*) AS inactive_customers
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`
WHERE Customer_Status = 'Inactive'
AND Industry IS NOT NULL
GROUP BY Industry
ORDER BY inactive_customers DESC;

/* Inactive Customers by Region */
SELECT
    Region,
    COUNT(*) AS inactive_customers
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`
WHERE Customer_Status = 'Inactive'
GROUP BY Region
ORDER BY inactive_customers DESC;

/* Retention Rate by Segment */
SELECT
    Customer_Segment,
    COUNT(*) AS total_customers,
    COUNTIF(Customer_Status = 'Active') AS active_customers,
    ROUND(
        COUNTIF(Customer_Status = 'Active')
        / COUNT(*) * 100, 2
    ) AS retention_rate
FROM `round-device-457618-t0.customer_clv_analysis.customer_dimension_clean`
GROUP BY Customer_Segment
ORDER BY retention_rate DESC;
