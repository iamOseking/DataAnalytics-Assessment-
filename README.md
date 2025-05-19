# DataAnalytics-Assessment-

Project Overview: SQL Solutions to Data Analyst Assessment

This project showcases my SQL solutions to a Data Analyst assessment with analysis of real-world banking data to uncover actionable insights into customer behavior.

Each problem was given in the scenario of a real business situation. For every problem, I have provided a clean and efficient SQL query, along with comments for better understanding wherever necessary. Below is a brief idea of how I have done each task, along with the issues that came up while analyzing.


CHALLENGES:

1. Handling Conditional Aggregation (Q1: High-Value Customers)
One challenge was counting product types conditionally—identifying customers with both funded savings and investment plans. This required using CASE WHEN inside aggregation functions (COUNT) to differentiate between plan types.

Ensuring no double-counting of transactions or accounts was essential, especially when customers had multiple plans of the same type.

Query complexity increased due to the need to filter only confirmed deposits while grouping data per customer.

2. Preventing Division Errors in Time-Based Metrics (Q2: Transaction Frequency)
A major challenge was avoiding division by zero when calculating average transactions per month. Some customers had activity only within the same month, resulting in a 0-month tenure from DATEDIFF.

I had to introduce logic to safely handle edge cases, assigning total transaction count directly when active_months = 0.

The classification logic required balancing business logic clarity with SQL efficiency, particularly while defining frequency buckets.

3. Identifying Inactivity in Active Accounts (Q3: Inactivity Alert)
It was tricky to isolate accounts that are still active but have seen no inflows for over a year. This required joining transaction and plan data while applying both temporal and status-based filters.

Since savings and investment accounts are structurally similar but distinguished by flags (is_regular_savings, is_a_fund), separate queries with a UNION were necessary.

Calculating inactivity duration using DATEDIFF and filtering based on the maximum transaction date involved careful use of GROUP BY and HAVING.

4. Estimating Customer Lifetime Value (Q4: CLV Estimation)
One challenge was designing a simplified CLV formula that balances accuracy and feasibility without complex revenue/profit breakdowns.

Again, division by zero had to be handled by excluding customers with 0-month tenure.

Applying the profit margin as a factor (0.001) across average transaction amounts required a thoughtful assumption since detailed margin data wasn’t available.



