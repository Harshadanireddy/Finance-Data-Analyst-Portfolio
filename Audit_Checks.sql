================================================
-- Audit and Compliance Check Queries
-- Purpose: Data variance analysis and compliance
-- Author: HarshaVardhan Reddy
-- ================================================

-- Query 1: Find amount mismatches between systems
SELECT
    a.account_id,
    a.customer_name,
    a.subscription_amount AS system1_amount,
    b.subscription_amount AS system2_amount,
    a.subscription_amount - b.subscription_amount AS variance
FROM finance_table_1 a
INNER JOIN finance_table_2 b
    ON a.account_id = b.account_id
WHERE a.subscription_amount <> b.subscription_amount
ORDER BY variance DESC;

-- Query 2: Missing renewal records
-- Accounts in master but no subscription record
SELECT
    a.account_id,
    a.customer_name,
    a.region,
    a.renewal_date
FROM accounts_table a
LEFT JOIN subscription_table s
    ON a.account_id = s.account_id
WHERE s.account_id IS NULL
ORDER BY a.renewal_date ASC;

-- Query 3: Duplicate account check
SELECT
    account_id,
    COUNT(*) AS duplicate_count
FROM subscription_table
GROUP BY account_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Query 4: Compliance check
-- Accounts renewed without proper status update
SELECT
    a.account_id,
    a.customer_name,
    s.renewal_date,
    s.status,
    s.last_updated
FROM accounts_table a
INNER JOIN subscription_table s
    ON a.account_id = s.account_id
WHERE s.renewal_date < CURRENT_DATE()
AND s.status = 'pending'
ORDER BY s.renewal_date ASC;
