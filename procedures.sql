
CREATE OR REPLACE PROCEDURE Add_Customer(
    p_FirstName      IN VARCHAR2,
    p_LastName       IN VARCHAR2,
    p_DOB            IN DATE,
    p_Email          IN VARCHAR2,
    p_IDNumber       IN VARCHAR2,
    p_Street         IN VARCHAR2,
    p_City           IN VARCHAR2,
    p_State          IN VARCHAR2,
    p_PostalCode     IN VARCHAR2,
    p_PhoneNumber    IN VARCHAR2
)
AS
    v_CustomerID NUMBER;
BEGIN
    INSERT INTO Customer(FirstName, LastName, DOB, Email, IDNumber,
                         Street, City, State, PostalCode, CreatedDate)
    VALUES (p_FirstName, p_LastName, p_DOB, p_Email, p_IDNumber,
            p_Street, p_City, p_State, p_PostalCode, SYSDATE)
    RETURNING CustomerID INTO v_CustomerID;

    INSERT INTO CustomerPhone(CustomerID, PhoneNumber)
    VALUES (v_CustomerID, p_PhoneNumber);

    DBMS_OUTPUT.PUT_LINE('Customer added with ID = ' || v_CustomerID);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Duplicate Email or IDNumber.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Add_Customer Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Add_CustomerPhone(
    p_CustomerID   IN NUMBER,
    p_PhoneNumber  IN VARCHAR2
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE CustomerID = p_CustomerID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer does not exist.');
    END IF;

    INSERT INTO CustomerPhone(CustomerID, PhoneNumber)
    VALUES (p_CustomerID, p_PhoneNumber);

    DBMS_OUTPUT.PUT_LINE('Phone added for CustomerID = ' || p_CustomerID);
END;
/

CREATE OR REPLACE PROCEDURE Update_Customer(
    p_CustomerID IN NUMBER,
    p_FirstName  IN VARCHAR2,
    p_LastName   IN VARCHAR2,
    p_Email      IN VARCHAR2,
    p_Street     IN VARCHAR2,
    p_City       IN VARCHAR2,
    p_State      IN VARCHAR2,
    p_PostCode   IN VARCHAR2
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE CustomerID = p_CustomerID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer does not exist.');
    END IF;

    UPDATE Customer
    SET FirstName = p_FirstName,
        LastName  = p_LastName,
        Email     = p_Email,
        Street    = p_Street,
        City      = p_City,
        State     = p_State,
        PostalCode = p_PostCode
    WHERE CustomerID = p_CustomerID;

    DBMS_OUTPUT.PUT_LINE('Customer updated: ' || p_CustomerID);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Update_Customer Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Delete_Customer(
    p_CustomerID IN NUMBER
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE CustomerID = p_CustomerID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM Account
    WHERE CustomerID = p_CustomerID;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Customer has active accounts. Cannot delete.');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM Loan
    WHERE CustomerID = p_CustomerID;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Customer has loans. Cannot delete.');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM Investment
    WHERE CustomerID = p_CustomerID;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Customer has investments. Cannot delete.');
    END IF;

    DELETE FROM CustomerPhone WHERE CustomerID = p_CustomerID;
    DELETE FROM Customer WHERE CustomerID = p_CustomerID;

    DBMS_OUTPUT.PUT_LINE('Customer deleted: ' || p_CustomerID);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Delete_Customer Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Open_New_Account(
    p_CustomerID     IN NUMBER,
    p_BranchID       IN NUMBER,
    p_AccountType    IN VARCHAR2,
    p_OpeningBalance IN NUMBER,
    p_Status         IN VARCHAR2 DEFAULT 'Active'
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE CustomerID = p_CustomerID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM Branch
    WHERE BranchID = p_BranchID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Branch does not exist.');
    END IF;

    INSERT INTO Account(CustomerID, BranchID, AccountType, Balance, DateOpened, AccountStatus)
    VALUES (p_CustomerID, p_BranchID, p_AccountType, p_OpeningBalance, SYSDATE, p_Status);

    DBMS_OUTPUT.PUT_LINE('Account opened for CustomerID = ' || p_CustomerID);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Open_New_Account Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Do_Transaction(
    p_AccountNumber   IN NUMBER,
    p_TransactionType IN VARCHAR2,
    p_Amount          IN NUMBER,
    p_Description     IN VARCHAR2 DEFAULT NULL
)
AS
    v_balance NUMBER;
    v_count   NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Account
    WHERE AccountNumber = p_AccountNumber;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Account does not exist.');
    END IF;

    SELECT Balance INTO v_balance
    FROM Account
    WHERE AccountNumber = p_AccountNumber;

    IF UPPER(p_TransactionType) = 'DEPOSIT' THEN
        UPDATE Account
        SET Balance = Balance + p_Amount
        WHERE AccountNumber = p_AccountNumber;

    ELSIF UPPER(p_TransactionType) = 'WITHDRAWAL' THEN
        IF v_balance < p_Amount THEN
            RAISE_APPLICATION_ERROR(-20002, 'Insufficient balance.');
        END IF;

        UPDATE Account
        SET Balance = Balance - p_Amount
        WHERE AccountNumber = p_AccountNumber;

    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'Invalid Transaction Type. Use DEPOSIT or WITHDRAWAL.');
    END IF;

    INSERT INTO BankTransaction(AccountNumber, TransactionType, Amount, TransactionDate, Description)
    VALUES (p_AccountNumber, p_TransactionType, p_Amount, SYSDATE, p_Description);

    DBMS_OUTPUT.PUT_LINE('Transaction completed for AccNo = ' || p_AccountNumber);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Do_Transaction Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Transfer_Amount(
    p_FromAccount    IN NUMBER,
    p_ToAccount      IN NUMBER,
    p_Amount         IN NUMBER,
    p_Description    IN VARCHAR2 DEFAULT 'Fund Transfer'
)
AS
    v_fromBalance NUMBER;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Account
    WHERE AccountNumber = p_FromAccount;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Sender account does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM Account
    WHERE AccountNumber = p_ToAccount;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Receiver account does not exist.');
    END IF;

    SELECT Balance INTO v_fromBalance
    FROM Account
    WHERE AccountNumber = p_FromAccount;

    IF v_fromBalance < p_Amount THEN
        RAISE_APPLICATION_ERROR(-20003, 'Insufficient balance for transfer.');
    END IF;

    UPDATE Account
    SET Balance = Balance - p_Amount
    WHERE AccountNumber = p_FromAccount;

    UPDATE Account
    SET Balance = Balance + p_Amount
    WHERE AccountNumber = p_ToAccount;

    INSERT INTO BankTransaction(AccountNumber, TransactionType, Amount, TransactionDate, Description)
    VALUES (p_FromAccount, 'Transfer Out', p_Amount, SYSDATE, p_Description);

    INSERT INTO BankTransaction(AccountNumber, TransactionType, Amount, TransactionDate, Description)
    VALUES (p_ToAccount, 'Transfer In', p_Amount, SYSDATE, p_Description);

    DBMS_OUTPUT.PUT_LINE('Transfer completed: ' || p_Amount || ' from ' || p_FromAccount || ' to ' || p_ToAccount);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Transfer_Amount Error: ' || SQLERRM);
END;
/
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Close_Account(
    p_AccountNumber IN NUMBER
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Account
    WHERE AccountNumber = p_AccountNumber;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Account does not exist.');
    END IF;

    UPDATE Account
    SET AccountStatus = 'Closed'
    WHERE AccountNumber = p_AccountNumber;

    DBMS_OUTPUT.PUT_LINE('Account closed: ' || p_AccountNumber);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Close_Account Error: ' || SQLERRM);
END;
/
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Update_Account_Status(
    p_AccountNumber IN NUMBER,
    p_NewStatus     IN VARCHAR2
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Account
    WHERE AccountNumber = p_AccountNumber;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Account does not exist.');
    END IF;

    UPDATE Account
    SET AccountStatus = p_NewStatus
    WHERE AccountNumber = p_AccountNumber;

    DBMS_OUTPUT.PUT_LINE('Account status updated: ' || p_AccountNumber || ' -> ' || p_NewStatus);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Update_Account_Status Error: ' || SQLERRM);
END;
/
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Post_Monthly_Interest(
    p_RatePercent IN NUMBER
)
AS
BEGIN
    UPDATE Account
    SET Balance = Balance + (Balance * (p_RatePercent / 100))
    WHERE AccountType = 'Savings'
      AND AccountStatus = 'Active';

    DBMS_OUTPUT.PUT_LINE('Monthly interest posted to all active savings accounts.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Post_Monthly_Interest Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Create_Loan(
    p_CustomerID    IN NUMBER,
    p_BranchID      IN NUMBER,
    p_LoanType      IN VARCHAR2,
    p_LoanAmount    IN NUMBER,
    p_InterestRate  IN NUMBER,
    p_TermMonths    IN NUMBER,
    p_StartDate     IN DATE,
    p_EndDate       IN DATE,
    p_Status        IN VARCHAR2 DEFAULT 'Active'
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE CustomerID = p_CustomerID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM Branch
    WHERE BranchID = p_BranchID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Branch does not exist.');
    END IF;

    INSERT INTO Loan (CustomerID, BranchID, LoanType, LoanAmount, 
                      InterestRate, TermMonths, StartDate, EndDate, Status)
    VALUES (p_CustomerID, p_BranchID, p_LoanType, p_LoanAmount,
            p_InterestRate, p_TermMonths, p_StartDate, p_EndDate, p_Status);

    DBMS_OUTPUT.PUT_LINE('Loan created for CustomerID = ' || p_CustomerID);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Create_Loan Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Manage_Loan_Status(
    p_LoanID    IN NUMBER,
    p_NewStatus IN VARCHAR2
)
AS
    v_count     NUMBER;
    v_enddate   DATE;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Loan
    WHERE LoanID = p_LoanID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Loan does not exist.');
    END IF;

    SELECT EndDate INTO v_enddate
    FROM Loan
    WHERE LoanID = p_LoanID;

    IF SYSDATE >= v_enddate THEN
        UPDATE Loan
        SET Status  = 'Closed',
            EndDate = SYSDATE
        WHERE LoanID = p_LoanID;

        DBMS_OUTPUT.PUT_LINE('Loan auto-closed: ' || p_LoanID);
        RETURN;
    END IF;

    UPDATE Loan
    SET Status = p_NewStatus
    WHERE LoanID = p_LoanID;

    DBMS_OUTPUT.PUT_LINE('Loan status updated: ' || p_LoanID || ' -> ' || p_NewStatus);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Manage_Loan_Status Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Create_Investment(
    p_CustomerID     IN NUMBER,
    p_BranchID       IN NUMBER,
    p_InvestmentType IN VARCHAR2,
    p_Amount         IN NUMBER,
    p_InterestRate   IN NUMBER,
    p_StartDate      IN DATE,
    p_EndDate        IN DATE,
    p_Status         IN VARCHAR2 DEFAULT 'Active'
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE CustomerID = p_CustomerID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM Branch
    WHERE BranchID = p_BranchID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Branch does not exist.');
    END IF;

    INSERT INTO Investment (CustomerID, BranchID, InvestmentType, Amount,
                            InterestRate, StartDate, EndDate, Status)
    VALUES (p_CustomerID, p_BranchID, p_InvestmentType, p_Amount,
            p_InterestRate, p_StartDate, p_EndDate, p_Status);

    DBMS_OUTPUT.PUT_LINE('Investment created for CustomerID = ' || p_CustomerID);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Create_Investment Error: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE Update_Investment_Status(
    p_InvestmentID IN NUMBER,
    p_NewStatus    IN VARCHAR2
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Investment
    WHERE InvestmentID = p_InvestmentID;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Investment does not exist.');
    END IF;

    UPDATE Investment
    SET Status = p_NewStatus
    WHERE InvestmentID = p_InvestmentID;

    DBMS_OUTPUT.PUT_LINE('Investment status updated: ' || p_InvestmentID || ' -> ' || p_NewStatus);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Update_Investment_Status Error: ' || SQLERRM);
END;
/
