DataAnalytics-Assessment

This repository contains SQL solutions for the Data Analytics Assessment focusing on SQL proficiency and real-world business metrics. The queries demonstrate data extraction, transformation, and customer segmentation using MySQL.

Per-Question Explanations

Question 1: High-Value Customers with Multiple Products
Approach:

Joined users_customuser, plans_plan, and savings_savingsaccount to link users to their plans and confirmed transactions.
Used CASE WHEN logic to count savings and investment plans per customer.
Filtered for users having both product types using the HAVING clause.
Summed confirmed_amount (converted from kobo) to get total deposits.
Ordered customers by total deposits in descending order.

Solution Highlights:

Applied conditional aggregation using COUNT(DISTINCT CASE WHEN).
Handled currency conversion by dividing amounts by 100.
Ensured unique customer records with appropriate GROUP BY.


Question 2: Transaction Frequency Analysis
Approach:

Counted user transactions per year and month.
Calculated each customer's average number of monthly transactions.
Classified customers as High, Medium, or Low Frequency using thresholds.
Aggregated the customer count and average transactions per category.

Solution Highlights:

Nested subqueries provided clarity in separating monthly vs. customer-level logic.
Used CASE for frequency classification.
Applied FIELD() to maintain a custom sort order of frequency tiers.


Question 3: Account Inactivity Alert
Approach:

Created a CTE to fetch each plan's latest transaction date.
Calculated inactivity in days using DATEDIFF.
Tagged each plan as "Savings" or "Investment".
Filtered for plans with no transactions in the last 365 days or no transactions at all.

Solution Highlights:

Used MAX(s.created_on) to determine last activity per plan.
Included NULL checks for plans with zero transactions.
Enhanced business readability with plan type classification.


Question 4: Customer Lifetime Value (CLV) Estimation
Approach:

Created a CTE that summarized customer details, tenure in months, transaction count, and total deposits.
Simulated total profit as 0.1% of the deposit value.
Calculated estimated annual CLV using: (total_profit / tenure_months) * 12.
Filtered out customers with zero tenure to avoid divide-by-zero errors.

Solution Highlights:

Used TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()) for tenure.
Converted all monetary values from kobo to naira.
Rounded the final CLV for cleaner presentation.


Challenges Encountered

Kobo to Naira Conversion: All monetary values needed consistent division by 100.
Division by Zero: CLV calculations excluded users with 0-month tenure.
Complex Aggregations: Question 2 required precise separation of month-level aggregation from customer-level classification.
Join Accuracy: Ensured joins didn't inflate row counts, especially with many-to-one relationships.


Notes

All queries are formatted with readable indentation and comments where needed.
Results are grouped and ordered logically to support analytical insights.
Designed and tested for MySQL but can be adapted for other SQL engines with minor changes.
