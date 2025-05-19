
  -- Question 2: Transaction Frequency Analysis

SELECT
  CASE
    WHEN AVG(tx_count_per_month) >= 10 THEN 'High Frequency'
    WHEN AVG(tx_count_per_month) BETWEEN 3 AND 9 THEN 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(tx_count_per_month), 1) AS avg_transactions_per_month
FROM (
  SELECT
    u.id AS customer_id,
    COUNT(s.id) / PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) AS tx_count_per_month
  FROM users_customuser u
  JOIN savings_savingsaccount s ON s.owner_id = u.id
  WHERE s.transaction_status = 'success'
  GROUP BY u.id
) sub;
