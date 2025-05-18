-- Categorize customers based on their average transaction frequency per month
-- and count how many fall into each category (High, Medium, Low)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    
    -- Average number of transactions per month for customers in each category
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month

FROM (
    -- Calculate each customer's average monthly transactions and assign a frequency category
    SELECT 
        customer_id,
        AVG(transactions_count) AS avg_transactions_per_month,

        -- Define frequency category based on average monthly transactions
        CASE 
            WHEN AVG(transactions_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transactions_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM (
        -- Count monthly transactions for each customer
        SELECT 
            u.id AS customer_id,
            COUNT(s.id) AS transactions_count,
            YEAR(s.created_on) AS txn_year,
            MONTH(s.created_on) AS txn_month
        FROM 
            users_customuser u
        JOIN 
            plans_plan p ON u.id = p.owner_id
        JOIN 
            savings_savingsaccount s ON p.id = s.plan_id
        GROUP BY 
            u.id, YEAR(s.created_on), MONTH(s.created_on)
    ) AS monthly_transactions
    GROUP BY customer_id
) AS customer_avg

-- Group final output by frequency category
GROUP BY frequency_category

-- Order the output in logical frequency order
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency')

LIMIT 0, 1000;
