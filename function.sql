CREATE OR REPLACE FUNCTION Calculate_EMI(
    p_Principal IN NUMBER,
    p_Rate      IN NUMBER,
    p_Months    IN NUMBER
) RETURN NUMBER
AS
    r   NUMBER;
    n   NUMBER;
    emi NUMBER;
BEGIN
    r := p_Rate / 100 / 12;
    n := p_Months;

    emi := p_Principal * r * POWER(1 + r, n) / (POWER(1 + r, n) - 1);

    RETURN ROUND(emi, 2);
END;
/
CREATE OR REPLACE FUNCTION Loan_Total_Payable(
    p_Principal IN NUMBER,
    p_Rate      IN NUMBER,
    p_Months    IN NUMBER
) RETURN NUMBER
AS
    v_emi NUMBER;
BEGIN
    v_emi := Calculate_EMI(p_Principal, p_Rate, p_Months);
    RETURN ROUND(v_emi * p_Months, 2);
END;
/

CREATE OR REPLACE FUNCTION Investment_Interest(
    p_Amount      IN NUMBER,
    p_RatePercent IN NUMBER
) RETURN NUMBER
AS
    v_interest NUMBER;
BEGIN
    v_interest := p_Amount * (p_RatePercent / 100);
    RETURN ROUND(v_interest, 2);
END;
/

CREATE OR REPLACE FUNCTION Investment_Maturity(
    p_Amount      IN NUMBER,
    p_RatePercent IN NUMBER
) RETURN NUMBER
AS
    v_maturity NUMBER;
BEGIN
    v_maturity := p_Amount * (1 + (p_RatePercent / 100));
    RETURN ROUND(v_maturity, 2);
END;
/
