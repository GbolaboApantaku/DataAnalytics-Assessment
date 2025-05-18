-- Get users who have at least one savings and one investment plan
-- and calculate their total confirmed deposits

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Count of distinct savings plans
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,

    -- Count of distinct investment plans
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,

    -- Total confirmed deposit amount (converted from kobo to naira)
    SUM(COALESCE(s.confirmed_amount, 0)) / 100.0 AS total_deposits

FROM 
    users_customuser u
JOIN 
    plans_plan p ON u.id = p.owner_id
JOIN 
    savings_savingsaccount s ON s.plan_id = p.id AND s.confirmed_amount > 0

GROUP BY 
    u.id, name

-- Only include users with both savings and investment plans
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1

ORDER BY 
    total_deposits DESC;
