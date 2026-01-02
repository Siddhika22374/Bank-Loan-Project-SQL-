-- 1. KPI’s:
-- 1) Number of Applications
USE financial_db;
SELECT * FROM financial_loan;


-- a) Total Loan Applications
SELECT COUNT(*) FROM financial_loan;

-- b) MTD Loan Applications(Month-To-Date i.e. Current Month)
SELECT COUNT(*) FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE());

-- c) PMTD Loan Applications(Previous Month)
SELECT COUNT(*) FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE()) - 1 ;

-- 2) Funded Amount (Total Loan Amount approved)
-- a) Total Funded Amount
SELECT * FROM financial_loan;
SELECT SUM(loan_amount) FROM financial_loan;

-- b) MTD Total Funded Amount
SELECT SUM(loan_amount) FROM financial_loan
WHERE MONTH(issue_date) = MONTH(current_date());

-- c) PMTD Total Funded Amount
SELECT SUM(loan_amount) FROM financial_loan
WHERE MONTH(issue_date) = MONTH(current_date()) - 1;

-- 3) Amount Received(Loan Amount paid)
-- a) Total Amount Received
SELECT * FROM financial_loan;
SELECT SUM(total_payment) Total_Amount_Received FROM financial_loan;

-- b) MTD Total Amount Received
SELECT SUM(total_payment) MTD_Total_Amount_Received FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE());

-- c) PMTD Total Amount Received
SELECT SUM(total_payment) PMTD_Total_Amount_Received FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE()) - 1;

-- 4) Interest Rate
-- a) Average Interest Rate
SELECT * FROM financial_loan;
SELECT ROUND(AVG(int_rate),2) AS 'Average Interest Rate' FROM financial_loan;

-- b) MTD Average Interest
SELECT ROUND(AVG(int_rate),2) AS 'MTD Average Interest Rate' FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE());

-- c) PMTD Average Interest
SELECT ROUND(AVG(int_rate),2) AS 'MTD Average Interest Rate' FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE()) - 1;

-- 5) DTI (Debt to Income ratio)
-- a) Avg DTI
SELECT * FROM financial_loan;
SELECT ROUND(AVG(dti),2) FROM financial_loan;

-- b) MTD Avg DTI
SELECT ROUND(AVG(dti),2) FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE());

-- c) PMTD Avg DTI
SELECT ROUND(AVG(dti),2) FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE())-1;

     -- 2. GOOD LOAN ISSUED
-- 1. Good Loan Percentage
-- 2. Good Loan Applications
-- 3. Good Loan Funded Amount
-- 4. Good Loan Amount Received
             
             -- 3. BAD LOAN ISSUED
-- 1. Bad Loan Percentage
-- 2. Bad Loan Applications
-- 3. Bad Loan Funded Amount
-- 4. Bad Loan Amount Received
			
            -- 4. LOAN STATUS
-- 1. Complete Loan Status Summary
-- 2. MTD Loan Status Summary

SELECT * FROM financial_loan;

SELECT DISTINCT(loan_status) from financial_loan;

-- 1. Good Loan Percentage
SELECT COUNT(id) FROM financial_loan;
SELECT COUNT(id) FROM financial_loan
WHERE loan_status IN ('Fully paid','Current');
SELECT ((SELECT COUNT(id) FROM financial_loan
WHERE loan_status IN ('Fully paid','Current'))*100/(SELECT COUNT(id) FROM financial_loan)) percentage;

-- 2. Good Loan Applications
SELECT COUNT(id) FROM financial_loan
WHERE loan_status IN ('Fully paid','Current');

-- 3. Good Loan Funded Amount
SELECT SUM(loan_amount) FROM financial_loan
WHERE loan_status IN ('Fully paid','Current');

-- 4. Good Loan Amount Received
SELECT SUM(total_payment) FROM financial_loan
WHERE loan_status IN ('Fully paid','Current');

             -- 3. BAD LOAN ISSUED
-- 1. Bad Loan Percentage
SELECT ((SELECT COUNT(id) FROM financial_loan
WHERE loan_status = 'charged off')*100/(SELECT COUNT(id) FROM financial_loan)) percentage;

-- 2. Bad Loan Applications
SELECT COUNT(id) FROM financial_loan
WHERE loan_status = 'charged off';

-- 3. Bad Loan Funded Amount
SELECT SUM(loan_amount) FROM financial_loan
WHERE loan_status = 'charged off';

-- 4. Bad Loan Amount Received
SELECT SUM(total_payment) FROM financial_loan
WHERE loan_status = 'charged off';

-- 4. LOAN STATUS
SELECT * FROM financial_loan;
            
-- 1. Complete Loan Status Summary
SELECT loan_status,COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`,
ROUND(AVG(dti),2) AS `AVERAGE DTI`,
ROUND(AVG(int_Rate),2) AS `AVERAGE INTEREST RATE`
FROM financial_loan
GROUP BY loan_status;

-- 2. MTD Loan Status Summary
SELECT loan_status,COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`,
ROUND(AVG(dti),2) AS `AVERAGE DTI`,
ROUND(AVG(int_Rate),2) AS `AVERAGE INTEREST RATE`
FROM financial_loan
WHERE MONTH(issue_date) = MONTH(CURRENT_DATE())
GROUP BY loan_status;

-- B. BANK LOAN REPORT | OVERVIEW
-- Showcase total number of applications, total loan amount and total amount received for the
-- following parameters.

-- a. MONTH
SELECT MONTHNAME(issue_date) 'MONTHS',COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`
FROM financial_loan
GROUP BY MONTHS
ORDER BY MONTHS;

-- b. STATE
SELECT address_state States,COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`
FROM financial_loan
GROUP BY States;

-- c. TERM
SELECT Term,COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`
FROM financial_loan
GROUP BY Term;

-- d. EMPLOYEE LENGTH
SELECT emp_length 'EMPLOYEE LENGTH',COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`
FROM financial_loan
GROUP BY emp_length;

-- e. PURPOSE
SELECT purpose,COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`
FROM financial_loan
GROUP BY purpose;

-- f. HOME OWNERSHIP
SELECT home_ownership,COUNT(id) AS 'TOTAL LOAN',
SUM(loan_amount) AS `FUNDED AMOUNT`,
SUM(total_payment) AS `AMOUNT RECEIVED`
FROM financial_loan
GROUP BY home_ownership;
SELECT * FROM financial_loan;

     -- C. Miscellaneous | OVERVIEW
     
-- 1. MoM Loan Application growth rate
WITH Monthly AS(
SELECT DATE_FORMAT(issue_date,'%Y-%m-%M') AS months,
COUNT(id) Total_application
FROM financial_loan
GROUP BY DATE_FORMAT(issue_date,'%Y-%m-%M')
ORDER BY DATE_FORMAT(issue_date,'%Y-%m-%M')
)
SELECT months,Total_application,
ROUND(
(Total_application-LAG(Total_application)OVER(ORDER BY months))/LAG(Total_application)OVER(ORDER BY months) *100,2) AS Monthly_Growth_percentage
FROM Monthly
ORDER BY months;

-- 2. Mom Loan Amount Disbursed growth rate
WITH Monthly_loan AS(
SELECT DATE_FORMAT(issue_date,'%Y-%m-%M') AS months,
SUM(loan_amount) AS amount_disbursed
FROM financial_loan
GROUP BY DATE_FORMAT(issue_date,'%Y-%m-%M')
)
SELECT months,amount_disbursed,
ROUND(
(amount_disbursed - LAG(amount_disbursed)OVER(ORDER BY months))/LAG(amount_disbursed) OVER(ORDER BY months) *100,2) AS monthly_growth
FROM Monthly_loan
ORDER BY months;

-- 3. Interest rate for various subgrade and grade loan type.
SELECT * FROM financial_loan;

SELECT 
    grade,
    ROUND(AVG(int_rate), 2) AS grade_interest,
    sub_grade,
    ROUND(AVG(int_rate), 2) AS sub_grade_interest
FROM financial_loan
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;
