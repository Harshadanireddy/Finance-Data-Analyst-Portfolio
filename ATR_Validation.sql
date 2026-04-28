 ================================================
-- Subscription Renewal Validation
-- Purpose: Identify and track pending renewal accounts
-- Author: HarshaVardhan Reddy
-- ================================================

-- Query 1: Pending renewals in next 30 days
SELECT 
    a.account_id,
    a.customer_name,
    a.region,
    s.renewal_date,
    s.subscription_amount,
    s.status
FROM accounts_table a
INNER JOIN subscription_table s
    ON a.account_id = s.account_id
WHERE s.status = 'pending'
AND s.renewal_date <= DATEADD(day, 30, CURRENT_DATE())
ORDER BY s.renewal_date ASC;

-- Query 2: Renewal amount summary by region
SELECT 
    a.region,
    COUNT(s.account_id) AS total_accounts,
    SUM(s.subscription_amount) AS total_renewal_amount
FROM accounts_table a
INNER JOIN subscription_table s
    ON a.account_id = s.account_id
WHERE s.status = 'pending'
GROUP BY a.region
ORDER BY total_renewal_amount DESC;

-- Query 3: Accounts expiring this month
SELECT
    a.account_id,
    a.customer_name,
    s.renewal_date,
    s.subscription_amount
FROM accounts_table a
LEFT JOIN subscription_table s
    ON a.account_id = s.account_id
WHERE MONTH(s.renewal_date) = MONTH(CURRENT_DATE())
AND YEAR(s.renewal_date) = YEAR(CURRENT_DATE())
ORDER BY s.renewal_date ASC;
