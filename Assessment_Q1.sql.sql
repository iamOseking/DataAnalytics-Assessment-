-- Question 1: High-Value Customers with Multiple Products
SELECT 
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    SUM(s.amount) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON p.owner_id = u.id
JOIN savings_savingsaccount s ON s.plan_id = p.id AND s.transaction_status = 'success'
WHERE p.is_deleted = 0
GROUP BY u.id, u.name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;
