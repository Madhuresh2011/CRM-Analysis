-- Opportunity

USE crm;

-- Expected Amount

select sum(`Expected Amount`) as Expected_Amount from opportuninty;

select count(`Expected Amount`) as Expected_Amount from opportuninty;
select sum(`Expected Amount`) from opportuninty;

SELECT SUM(CAST(REPLACE(REPLACE(`Expected Amount`, ',', ''), '$', '') AS DECIMAL(20, 2))) AS Expected_Amount
FROM opportuninty;

--  Active Opportunities - changed
select Count(Closed) as Active_Opportunities
from opportuninty
where Closed = 'False'; 

-- Conversion Rate
select count(`Created by Lead Conversion1`) as Active_Opportunities
from opportuninty
where `Created by Lead Conversion1`=1;

select
(SUM(CASE WHEN `Created by Lead Conversion1` = '1' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS Conversion_Rate_Percentage
from opportuninty;

-- Win Rate
select
(SUM(CASE WHEN `Winrate` = '1' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS Conversion_Rate_Percentage
from opportuninty;

select count(`Winrate`) as Active_Opportunities
from opportuninty
where `Winrate`=1;

-- Loss Rate
select
(SUM(CASE WHEN `Lossrate` = '1' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS Conversion_Rate_Percentage
from opportuninty;

select count(`Lossrate`) as Active_Opportunities
from opportunintytable
where `Lossrate`=1;

-- trend anyalysis

-- amount generated by Opportunity Type
SELECT `Opportunity Type`, sum(Amount) AS Amount_genrated
FROM opportuninty
GROUP BY `Opportunity Type`;

-- expected amount have to be generated by Opportunity Type
SELECT `Opportunity Type`, sum(`Expected Amount`) AS Expected_Amount,sum(Amount) AS Amount_genrated
FROM opportuninty
GROUP BY `Opportunity Type`;

-- actual diffrence between expexted amount and Actual amount is
SELECT 
    `Opportunity Type`, 
    SUM(`Expected Amount`) AS Expected_Amount,
    SUM(Amount) AS Amount_generated,
    SUM(`Expected Amount`) - SUM(Amount) AS difference
FROM 
    opportuninty
GROUP BY 
    `Opportunity Type`;
    
-- Opportunities by Industry
SELECT `Industry`, count(CASE WHEN `Active Opp` = '1' THEN 1 ELSE 0 END) AS total_opp
FROM opportuninty
GROUP BY `Industry`
ORDER BY total_opp DESC ;


-- Running Total Expected Vs Commit Forecast Amount over Time
SELECT 
    `Fiscal Year`, 
    `Expected Amount`, 
    SUM(`Expected Amount`) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Expected,
    SUM(`Forecast Q Commit1`) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Commit_Forecast
FROM 
    opportuninty
ORDER BY 
    `Fiscal Year` ASC;


-- Running Total Active Vs Total Opportunities over Time
SELECT 
    `Fiscal Year`, 
    COUNT(*) AS Total_Opportunities,
    SUM(`Active Opp`) AS Active_Opportunities,
    SUM(COUNT(*)) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Opportunities,
    SUM(SUM(`Active Opp`)) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Active_Opportunities
FROM 
    opportuninty
GROUP BY 
    `Fiscal Year`
ORDER BY 
    `Fiscal Year` ASC;

-- Closed Won Vs Total Opportunities over Time

SELECT 
    `Fiscal Year`, 
    COUNT(*) AS Total_Opportunities,
    SUM(CASE WHEN `stage` = 'Closed Won' THEN 1 ELSE 0 END) AS Closed_Won_Opportunities,
    SUM(COUNT(*)) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Opportunities,
    SUM(SUM(CASE WHEN `stage` = 'Closed Won' THEN 1 ELSE 0 END)) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Closed_Won
FROM 
    opportuninty
GROUP BY 
    `Fiscal Year`
ORDER BY 
    `Fiscal Year` ASC;

-- Closed Won vs Total Closed over Time

SELECT 
    `Fiscal Year`, 
    SUM(CASE WHEN `Closed` = 'True' THEN 1 ELSE 0 END) AS Total_Closed_Opportunities,
    SUM(CASE WHEN `Stage` = 'Closed Won' THEN 1 ELSE 0 END) AS Closed_Won_Opportunities,
    SUM(SUM(CASE WHEN `Closed` = 'True' THEN 1 ELSE 0 END)) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Closed_Opportunities,
    SUM(SUM(CASE WHEN `Stage` = 'Closed Won' THEN 1 ELSE 0 END)) OVER (ORDER BY `Fiscal Year` ASC) AS Running_Total_Closed_Won
FROM 
    opportuninty
GROUP BY 
    `Fiscal Year`
ORDER BY 
    `Fiscal Year` ASC;