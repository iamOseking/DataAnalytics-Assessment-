-- Question 4: Customer Lifetime Value (CLV) Estimation
SELECT
  u.id AS customer_id,
  u.name,
  PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) AS tenure_months,
  COUNT(s.id) AS total_transactions,
  ROUND(((COUNT(s.id) / NULLIF(PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')), 0)) * 12 * 0.001), 2) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.transaction_status = 'success'
GROUP BY u.id, u.name
ORDER BY estimated_clv DESC;
