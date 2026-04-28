 ================================================
-- MIS Report Queries
-- Purpose: Daily and weekly finance reporting
-- Author: HarshaVardhan Reddy
-- ================================================

-- Query 1: Daily subscription status summary
SELECT
    status,
    COUNT(*) AS total_count,
    SUM(subscription_amount) AS total_amount
FROM subscription_table
WHERE report_date = CURRENT_DATE()
GROUP BY status
ORDER BY total_count DESC;

-- Query 2: Weekly revenue tracking
SELECT
    DATE_TRUNC('week', renewal_date) AS week_start,
    COUNT(*) AS renewals_count,
    SUM(subscription_amount) AS weekly_revenue
FROM subscription_table
WHERE status = 'renewed'
AND renewal_date >= DATEADD(day, -30, CURRENT_DATE())
GROUP BY DATE_TRUNC('week', renewal_date)
ORDER BY week_start DESC;

-- Query 3: Monthly revenue comparison
SELECT
    MONTH(renewal_date) AS month_number,
    COUNT(*) AS total_renewals,
    SUM(subscription_amount) AS monthly_revenue,
    AVG(subscription_amount) AS avg_deal_size
FROM subscription_table
WHERE status = 'renewed'
AND YEAR(renewal_date) = YEAR(CURRENT_DATE())
GROUP BY MONTH(renewal_date)
ORDER BY month_number ASC;

-- Query 4: Daily exception report
-- Accounts with missing or null data
SELECT
    account_id,
    customer_name,
    renewal_date,
    status
FROM subscription_table
WHERE subscription_amount IS NULL
OR renewal_date IS NULL
OR status IS NULL
ORDER BY account_id ASC;
