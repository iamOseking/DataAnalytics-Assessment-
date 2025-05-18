# DataAnalytics-Assessment-






-- Q1: High-Value Customers with Multiple Products

-- Find customers with at least one funded savings plan (is_regular_savings = 1)
-- AND one funded investment plan (is_a_fund = 1), sorted by total deposits.

SELECT 
    uc.id AS owner_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) AS investment_count,
    SUM(s.confirmed_amount) AS total_deposits
FROM users_customuser uc
JOIN savings_savingsaccount s ON uc.id = s.owner_id
JOIN plans_plan p ON s.plan_id = p.id
WHERE s.confirmed_amount > 0
GROUP BY uc.id, name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;

-- Q2: Transaction Frequency Analysis
-- Categorize customers by how frequently they transact per month.

WITH transactions_per_customer AS (
    SELECT 
        uc.id AS customer_id,
        COUNT(s.id) AS total_transactions,
        DATEDIFF(MAX(s.transaction_date), MIN(s.transaction_date)) / 30.0 AS active_months
    FROM users_customuser u
    JOIN savings_savingsaccount s ON uc.id = s.owner_id
    GROUP BY uc.id
),
frequency_classification AS (
    SELECT 
        customer_id,
        total_transactions,
        active_months,
        CASE 
            WHEN active_months = 0 THEN total_transactions -- Avoid division by zero
            ELSE total_transactions / active_months
        END AS avg_txn_per_month
    FROM transactions_per_customer
),
categorized AS (
    SELECT 
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM frequency_classification
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;


-- Q3: Account Inactivity Alert
-- Find active plans (savings or investment) with no inflow in the last 1 year.

-- Savings Inactivity
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Savings' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE p.is_regular_savings = 1
  AND s.confirmed_amount > 0
  AND p.is_active = 1
GROUP BY p.id, p.owner_id
HAVING MAX(s.transaction_date) < CURRENT_DATE() - INTERVAL 365 DAY

UNION

-- Investment Inactivity
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE p.is_a_fund = 1
  AND s.confirmed_amount > 0
  AND p.is_active = 1
GROUP BY p.id, p.owner_id
HAVING MAX(s.transaction_date) < CURRENT_DATE() - INTERVAL 365 DAY;


-- Q4: Customer Lifetime Value Estimation

WITH transaction_stats AS (
    SELECT 
        uc.id AS customer_id,
        CONCAT(uc.first_name, ' ', uc.last_name) AS name,
        TIMESTAMPDIFF(MONTH, uc.date_joined, CURRENT_DATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        AVG(s.confirmed_amount * 0.001) AS avg_profit_per_transaction
    FROM users_customuser uc
    JOIN savings_savingsaccount s ON uc.id = s.owner_id
    WHERE s.confirmed_amount > 0
    GROUP BY uc.id
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND((total_transactions / tenure_months) * 12 * avg_profit_per_transaction, 2) AS estimated_clv
FROM transaction_stats
WHERE tenure_months > 0
ORDER BY estimated_clv DESC;
