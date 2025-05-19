-- Question 3: Account Inactivity Alert
SELECT
  p.id AS plan_id,
  p.owner_id,
  CASE
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund = 1 THEN 'Investment'
    ELSE 'Other'
  END AS type,
  MAX(s.transaction_date) AS last_transaction_date,
  DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s ON s.plan_id = p.id AND s.transaction_status = 'success'
WHERE p.is_deleted = 0
GROUP BY p.id, p.owner_id, type
HAVING last_transaction_date IS NOT NULL AND inactivity_days > 365;
