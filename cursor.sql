DECLARE
 CURSOR cur_invest IS
        SELECT InvestmentID, CustomerID, Amount, Status
        FROM Investment;

    v_InvID   Investment.InvestmentID%TYPE;
    v_CustID  Investment.CustomerID%TYPE;
    v_Amount  Investment.Amount%TYPE;
    v_Status  Investment.Status%TYPE;
BEGIN
    OPEN cur_invest;
    LOOP
        FETCH cur_invest INTO v_InvID, v_CustID, v_Amount, v_Status;
        EXIT WHEN cur_invest%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'InvestmentID: ' || v_InvID ||
            ', CustomerID: ' || v_CustID ||
            ', Amount: ' || v_Amount ||
            ', Status: ' || v_Status
        );
    END LOOP;
    CLOSE cur_invest;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cursor cur_invest Error: ' || SQLERRM);
END;
/

DECLARE
    CURSOR cur_loan IS
        SELECT LoanID, CustomerID, LoanAmount, InterestRate, Status
        FROM Loan;

    v_LoanID Loan.LoanID%TYPE;
    v_CustID Loan.CustomerID%TYPE;
    v_Amount Loan.LoanAmount%TYPE;
    v_Rate   Loan.InterestRate%TYPE;
    v_Status Loan.Status%TYPE;
BEGIN
    OPEN cur_loan;
    LOOP
        FETCH cur_loan INTO v_LoanID, v_CustID, v_Amount, v_Rate, v_Status;
        EXIT WHEN cur_loan%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'LoanID: ' || v_LoanID ||
            ' | CustomerID: ' || v_CustID ||
            ' | Amount: ' || v_Amount ||
            ' | Rate: ' || v_Rate ||
            ' | Status: ' || v_Status
        );
    END LOOP;
    CLOSE cur_loan;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cursor cur_loan Error: ' || SQLERRM);
END;
/

SET SERVEROUTPUT ON;

DECLARE
    CURSOR cur_trans IS
        SELECT TransactionID, AccountNumber, TransactionType, Amount, TransactionDate
        FROM BankTransaction
        ORDER BY TransactionDate DESC;

    v_TID  BankTransaction.TransactionID%TYPE;
    v_Acc  BankTransaction.AccountNumber%TYPE;
    v_Type BankTransaction.TransactionType%TYPE;
    v_Amt  BankTransaction.Amount%TYPE;
    v_Date BankTransaction.TransactionDate%TYPE;
BEGIN
    OPEN cur_trans;
    LOOP
        FETCH cur_trans INTO v_TID, v_Acc, v_Type, v_Amt, v_Date;
        EXIT WHEN cur_trans%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'TxnID: ' || v_TID ||
            ' | AccNo: ' || v_Acc ||
            ' | Type: ' || v_Type ||
            ' | Amount: ' || v_Amt ||
            ' | Date: ' || v_Date
        );
    END LOOP;
    CLOSE cur_trans;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cursor cur_trans Error: ' || SQLERRM);
END;
/
