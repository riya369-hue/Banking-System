CREATE TABLE CustomerPhone (
    CustomerID      INT,
    PhoneNumber     VARCHAR(15),
    PRIMARY KEY (CustomerID, PhoneNumber),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
)

CREATE TABLE Customer (
    CustomerID      INT PRIMARY KEY,
    FirstName       VARCHAR(100),
    LastName        VARCHAR(100),
    DOB             DATE,
    Email           VARCHAR(100),
    IDNumber        VARCHAR(50),
    Street          VARCHAR(100),
    City            VARCHAR(100),
    State           VARCHAR(100),
    PostalCode      VARCHAR(20),
    CreatedDate     DATE
)

CREATE TABLE Branch (
    BranchID        INT PRIMARY KEY,
    BranchName      VARCHAR(100),
    Street          VARCHAR(100),
    City            VARCHAR(100),
    State           VARCHAR(100),
    PostalCode      VARCHAR(20),
    Phone           VARCHAR(15)
)


CREATE TABLE Employee (
    EmployeeID      INT PRIMARY KEY,
    FirstName       VARCHAR(100),
    LastName        VARCHAR(100),
    Position        VARCHAR(100),
    Salary          DECIMAL(10,2),
    HireDate        DATE,
    Email           VARCHAR(100),
    BranchID        INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
)

CREATE TABLE Account (
    AccountNumber   INT PRIMARY KEY,
    CustomerID      INT,
    BranchID        INT,
    AccountType     VARCHAR(50),
    Balance         DECIMAL(15,2),
    DateOpened      DATE,
    AccountStatus   VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
)

CREATE TABLE BankTransaction (
    TransactionID   INT PRIMARY KEY,
    AccountNumber   INT,
    TransactionType VARCHAR(50),
    Amount          DECIMAL(15,2),
    TransactionDate DATE,
    Description     VARCHAR(255),
    FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber)
)


CREATE TABLE Investment (
    InvestmentID    INT PRIMARY KEY,
    CustomerID      INT,
    BranchID        INT,
    InvestmentType  VARCHAR(50),
    Amount          DECIMAL(15,2),
    InterestRate    DECIMAL(5,2),
    StartDate       DATE,
    EndDate         DATE,
    Status          VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
)

CREATE TABLE Loan (
    LoanID        NUMBER PRIMARY KEY,
    CustomerID    NUMBER,
    BranchID      NUMBER,
    LoanType      VARCHAR2(50),
    LoanAmount    NUMBER,
    InterestRate  NUMBER,
    TermMonths    NUMBER,
    StartDate     DATE,
    EndDate       DATE,
    Status        VARCHAR2(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (BranchID)  REFERENCES Branch(BranchID)
)


