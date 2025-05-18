-- Estimate Customer Lifetime Value (CLV) based on deposit history and tenure

WITH customer_data AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,

        -- Calculate the number of months since the customer joined
        TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()) AS tenure_months,

        -- Count total transactions for the customer
        COUNT(s.id) AS total_transactions,

        -- Sum of confirmed deposits (converted from kobo to Naira)
        SUM(s.confirmed_amount) / 100.0 AS total_deposit_amount,

        -- Simulated total profit (0.1% of total confirmed deposits)
        (SUM(s.confirmed_amount) * 0.001) / 100.0 AS total_profit

    FROM 
        users_customuser u
    JOIN 
        plans_plan p ON u.id = p.owner_id
    JOIN 
        savings_savingsaccount s ON p.id = s.plan_id
    GROUP BY 
        u.id, u.first_name, u.last_name, u.created_on
)

-- Calculate and rank customers by estimated CLV
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,

    -- Estimated annualized profit per customer
    ROUND((total_profit / tenure_months) * 12, 2) AS estimated_clv

FROM 
    customer_data
WHERE 
    tenure_months > 0
ORDER BY 
    estimated_clv DESC;
