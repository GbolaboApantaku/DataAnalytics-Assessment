-- Identify plans that have been inactive for over a year
-- or have never had a transaction

WITH last_transaction AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,

        -- Determine the type of plan
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,

        -- Get the most recent transaction date for each plan
        MAX(s.created_on) AS last_transaction_date,

        -- Calculate inactivity in days since the last transaction
        DATEDIFF(CURRENT_DATE(), MAX(s.created_on)) AS inactivity_days

    FROM 
        plans_plan p
    LEFT JOIN 
        savings_savingsaccount s ON p.id = s.plan_id
    GROUP BY 
        p.id, p.owner_id, type
)

-- Filter for inactive or never-used plans
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM 
    last_transaction
WHERE 
    inactivity_days > 365 OR last_transaction_date IS NULL
ORDER BY 
    inactivity_days DESC;
