================================================
-- Subscription Lifecycle Analysis
-- Purpose: Revenue tracking and renewal trends
-- Author: HarshaVardhan Reddy
-- ================================================

-- Query 1: Renewal rate by region
SELECT
    region,
    COUNT(CASE WHEN status = 'renewed' THEN 1 END) AS renewed,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) AS pending,
    COUNT(CASE WHEN status = 'lapsed' THEN 1 END) AS lapsed,
    ROUND(COUNT(CASE WHEN status = 'renewed' THEN 1 END) * 100.0
        / COUNT(*), 2) AS renewal_rate_pct
FROM subscription_table
GROUP BY region
ORDER BY renewal_rate_pct DESC;

-- Query 2: Revenue trend last 6 months
SELECT
    DATE_TRUNC('month', renewal_date) AS month,
    SUM(subscription_amount) AS monthly_revenue,
    COUNT(*) AS total_accounts,
    AVG(subscription_amount) AS avg_revenue_per_account
FROM subscription_table
WHERE status = 'renewed'
AND renewal_date >= DATEADD(month, -6, CURRENT_DATE())
GROUP BY DATE_TRUNC('month', renewal_date)
ORDER BY month ASC;

-- Query 3: Top accounts by subscription value
SELECT
    a.account_id,
    a.customer_name,
    a.region,
    SUM(s.subscription_amount) AS total_value,
    COUNT(s.subscription_id) AS total_subscriptions
FROM accounts_table a
INNER JOIN subscription_table s
    ON a.account_id = s.account_id
GROUP BY 
    a.account_id,
    a.customer_name,
    a.region
ORDER BY total_value DESC
LIMIT 10;

-- Query 4: Lapsed accounts analysis
-- Accounts that did not renew
SELECT
    a.region,
    COUNT(*) AS lapsed_count,
    SUM(s.subscription_amount) AS lost_revenue
FROM accounts_table a
INNER JOIN subscription_table s
    ON a.account_id = s.account_id
WHERE s.status = 'lapsed'
AND s.renewal_date >= DATEADD(month, -3, CURRENT_DATE())
GROUP BY a.region
ORDER BY lost_revenue DESC;
