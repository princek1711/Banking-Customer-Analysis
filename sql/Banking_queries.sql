-- ============================================================
-- BANKING CUSTOMER ANALYSIS — SQL QUERIES
-- Author  : Prince Kumar
-- Tool    : MySQL 8.0
-- Dataset : 3,000 banking customers
-- ============================================================


-- Create Database
CREATE DATABASE IF NOT EXISTS Banking_case;

-- Verify it was Created
SHOW DATABASES;

USE Banking_case;
SELECT COUNT(*) FROM customer;

-- ============================================================
-- BASIC QUERIES 
-- ============================================================

-- Q1: Total number of customers
SELECT COUNT(*) AS Total_Customers 
FROM customer;

-- Q2: Average income, loan and deposit of all customers
SELECT 
    ROUND(AVG(Estimated_Income), 2) AS Avg_Income,
    ROUND(AVG(Bank_Loans), 2) AS Avg_Loan,
    ROUND(AVG(Bank_Deposits), 2) AS Avg_Deposit
FROM customer;

-- Q3: Count customers by Loyalty Classification
SELECT 
    Loyalty_Classification,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Estimated_Income), 2) AS Avg_Income
FROM customer
GROUP BY Loyalty_Classification
ORDER BY Avg_Income DESC;

-- Q4: Count customers by Nationality (Top 10)
SELECT 
    Nationality,
    COUNT(*) AS Total_Customers
FROM customer
GROUP BY Nationality
ORDER BY Total_Customers DESC
LIMIT 10;

-- Q5: Customers with more than 2 credit cards
SELECT 
    COUNT(*) AS Customers_With_2Plus_Cards
FROM customer
WHERE Amount_of_Credit_Cards > 2;

-- ============================================================
-- INTERMEDIATE QUERIES (What interviews test)
-- ============================================================

-- Q6: Total loans and deposits grouped by Loyalty tier
-- Business use: Which tier generates most business?
SELECT 
    Loyalty_Classification,
    COUNT(*) AS Total_Customers,
    ROUND(SUM(Bank_Loans), 2) AS Total_Loans,
    ROUND(SUM(Bank_Deposits), 2) AS Total_Deposits,
    ROUND(AVG(Bank_Loans), 2) AS Avg_Loan_Per_Customer,
    ROUND(AVG(Bank_Deposits), 2) AS Avg_Deposit_Per_Customer
FROM customer
GROUP BY Loyalty_Classification
ORDER BY Total_Loans DESC;

-- Q7: Top 10 customers by total assets
-- Business use: Identify VIP customers for premium services
SELECT 
    Client_ID,
    Name,
    Nationality,
    Occupation,
    ROUND(Estimated_Income, 2) AS Income,
    ROUND(
        Bank_Deposits + 
        Checking_Accounts + 
        Saving_Accounts + 
        Foreign_Currency_Account + 
        Superannuation_Savings, 2
    ) AS Total_Assets
FROM customer
ORDER BY Total_Assets DESC
LIMIT 10;

-- Q8: High risk customers with low income
-- Business use: Flag customers who may default on loans
SELECT 
    Client_ID,
    Name,
    Occupation,
    ROUND(Estimated_Income, 2)   AS Income,
    ROUND(Bank_Loans, 2) AS Loans,
    Risk_Weighting,
    ROUND(Bank_Loans / 
          NULLIF(Estimated_Income, 0), 3) AS Loan_to_Income_Ratio
FROM customer
WHERE Risk_Weighting >= 4
  AND Estimated_Income < 75000
ORDER BY Loan_to_Income_Ratio DESC
LIMIT 15;

-- Q9: Average income by occupation (top 10)
-- Business use: Occupation-based product targeting
SELECT 
    Occupation,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Estimated_Income), 2) AS Avg_Income,
    ROUND(AVG(Bank_Loans), 2) AS Avg_Loans,
    ROUND(AVG(Bank_Deposits), 2) AS Avg_Deposits
FROM customer
GROUP BY Occupation
ORDER BY Avg_Income DESC
LIMIT 10;

-- Q10: Customers who have loans BUT no deposits
-- Business use: Cross-sell deposit products to loan customers
SELECT 
    COUNT(*) AS Loan_Only_Customers
FROM customer
WHERE Bank_Loans > 0 
  AND Bank_Deposits = 0;

-- Detailed list
SELECT 
    Client_ID,
    Name,
    Occupation,
    ROUND(Bank_Loans, 2)         AS Bank_Loans,
    ROUND(Estimated_Income, 2)   AS Income
FROM customer
WHERE Bank_Loans > 0 
  AND Bank_Deposits = 0
ORDER BY Bank_Loans DESC
LIMIT 10;

-- ============================================================
-- ADVANCED QUERIES (Stands out in interviews)
-- ============================================================

-- Q11: Running total of customers who joined each year
-- Business use: Track bank growth over time
SELECT 
    YEAR(STR_TO_DATE(Joined_Bank, '%d-%m-%Y'))  AS Join_Year,
    COUNT(*) AS New_Customers,
    SUM(COUNT(*)) OVER (
        ORDER BY YEAR(STR_TO_DATE(Joined_Bank, '%d-%m-%Y'))
    ) AS Running_Total
FROM customer
GROUP BY Join_Year
ORDER BY Join_Year;

-- Q12: Rank customers by loan amount within each loyalty tier
-- Business use: Find top borrowers in each loyalty segment
SELECT 
    Client_ID,
    Name,
    Loyalty_Classification,
    ROUND(Bank_Loans, 2)  AS Bank_Loans,
    RANK() OVER (
        PARTITION BY Loyalty_Classification 
        ORDER BY Bank_Loans DESC
    ) AS Rank_Within_Tier
FROM customer
WHERE Bank_Loans > 0
ORDER BY Loyalty_Classification, Rank_Within_Tier
LIMIT 20;

-- Q13: CTE — Find customers above average income in their loyalty tier
-- Business use: Premium customer identification per segment
WITH Tier_Avg AS (
    SELECT 
        Loyalty_Classification,
        AVG(Estimated_Income) AS Avg_Tier_Income
    FROM customer
    GROUP BY Loyalty_Classification
)
SELECT 
    c.Client_ID,
    c.Name,
    c.Loyalty_Classification,
    ROUND(c.Estimated_Income, 2) AS Customer_Income,
    ROUND(t.Avg_Tier_Income, 2) AS Tier_Average,
    ROUND(c.Estimated_Income - 
          t.Avg_Tier_Income, 2) AS Above_Average_By
FROM customer c
JOIN Tier_Avg t 
    ON c.Loyalty_Classification = t.Loyalty_Classification
WHERE c.Estimated_Income > t.Avg_Tier_Income
ORDER BY Above_Average_By DESC
LIMIT 15;

-- Q14: CTE — Customer segments based on total assets
-- Business use: Full customer value segmentation
WITH Customer_Assets AS (
    SELECT 
        Client_ID,
        Name,
        Loyalty_Classification,
        Estimated_Income,
        ROUND(
            Bank_Deposits + Checking_Accounts + 
            Saving_Accounts + Foreign_Currency_Account + 
            Superannuation_Savings, 2
        ) AS Total_Assets
    FROM customer
),
Segmented AS (
    SELECT *,
        CASE 
            WHEN Total_Assets >= 3000000 THEN 'Platinum Tier'
            WHEN Total_Assets >= 1500000 THEN 'Gold Tier'
            WHEN Total_Assets >= 500000  THEN 'Silver Tier'
            ELSE                              'Bronze Tier'
        END AS Asset_Segment
    FROM Customer_Assets
)
SELECT 
    Asset_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Total_Assets), 2) AS Avg_Assets,
    ROUND(AVG(Estimated_Income), 2) AS Avg_Income
FROM Segmented
GROUP BY Asset_Segment
ORDER BY Avg_Assets DESC;

-- Q15: Month-wise new customer acquisition trend
-- Business use: Identify which months have highest growth
SELECT 
    YEAR(STR_TO_DATE(Joined_Bank, '%d-%m-%Y')) AS Year,
    MONTH(STR_TO_DATE(Joined_Bank, '%d-%m-%Y')) AS Month,
    MONTHNAME(STR_TO_DATE(Joined_Bank, '%d-%m-%Y')) AS Month_Name,
    COUNT(*) AS New_Customers,
    ROUND(AVG(Estimated_Income), 2) AS Avg_Income_New_Customers
FROM customer
GROUP BY Year, Month, Month_Name
ORDER BY Year, Month
LIMIT 24;
