CREATE OR REPLACE VIEW Customer_Summary AS
SELECT 
    c.CustomerID,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    c.Email,
    c.City,
    c.State,
    (SELECT COUNT(*) FROM CustomerPhone cp WHERE cp.CustomerID = c.CustomerID) AS TotalPhones,
    (SELECT COUNT(*) FROM Account a WHERE a.CustomerID = c.CustomerID) AS TotalAccounts,
    (SELECT COUNT(*) FROM Loan l WHERE l.CustomerID = c.CustomerID) AS TotalLoans,
    (SELECT COUNT(*) FROM Investment i WHERE i.CustomerID = c.CustomerID) AS TotalInvestments
FROM Customer c;

-- ACCOUNT SUMMARY VIEW
CREATE OR REPLACE VIEW Account_Summary AS
SELECT 
    a.AccountNumber,
    a.AccountType,
    a.Balance,
    a.AccountStatus,
    a.DateOpened,
    c.CustomerID,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    b.BranchName
FROM Account a
JOIN Customer c ON a.CustomerID = c.CustomerID
JOIN Branch   b ON a.BranchID   = b.BranchID;

-- LOAN SUMMARY VIEW
CREATE OR REPLACE VIEW Loan_Summary AS
SELECT 
    l.LoanID,
    l.CustomerID,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    l.BranchID,
    b.BranchName,
    l.LoanAmount,
    l.InterestRate,
    l.TermMonths,
    l.StartDate,
    l.EndDate,
    l.Status
FROM Loan l
JOIN Customer c ON l.CustomerID = c.CustomerID
JOIN Branch   b ON l.BranchID   = b.BranchID;

-- INVESTMENT SUMMARY VIEW
CREATE OR REPLACE VIEW Investment_Summary AS
SELECT
    i.InvestmentID,
    i.CustomerID,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    i.BranchID,
    b.BranchName,
    i.InvestmentType,
    i.Amount,
    i.InterestRate,
    Investment_Interest(i.Amount, i.InterestRate) AS InterestEarned,
    Investment_Maturity(i.Amount, i.InterestRate) AS MaturityAmount,
    i.StartDate,
    i.EndDate,
    i.Status
FROM Investment i
JOIN Customer c ON i.CustomerID = c.CustomerID
JOIN Branch   b ON i.BranchID   = b.BranchID;

