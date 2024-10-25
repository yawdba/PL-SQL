select * from employees;

-- PROCEDURE

-- Update Employee Job Title
CREATE OR REPLACE PROCEDURE UPDATE_JOB_TITLE (
    p_emp_id IN employees.empid%TYPE,
    p_new_job_title IN employees.title%TYPE
) AS
BEGIN
    UPDATE employees
    SET title = p_new_job_title
    WHERE empid = p_emp_id;
END UPDATE_JOB_TITLE;
/

BEGIN
    UPDATE_JOB_TITLE(3427, 'Sr.Production Technician I'); 
END;
/


-- Update Employee Exit Date & Change their Employee Status to Not Active
CREATE OR REPLACE PROCEDURE MARK_EMPLOYEE_EXIT (
    p_emp_id IN employees.empid%TYPE,
    p_exit_date IN employees.exitdate%TYPE
) AS
BEGIN
    UPDATE employees
    SET exitdate = p_exit_date,
        EmployeeStatus = 'Not Active'
    WHERE empid = p_emp_id;
END MARK_EMPLOYEE_EXIT;
/

BEGIN
    MARK_EMPLOYEE_EXIT(3429, '11-Nov-21'); 
END;
/


-- Assign a New Supervisor to an Employee
CREATE OR REPLACE PROCEDURE ASSIGN_SUPERVISOR (
    p_emp_id IN employees.empid%TYPE,
    p_supervisor IN employees.supervisor%TYPE
) AS
BEGIN
    UPDATE employees
    SET supervisor = p_supervisor
    WHERE empid = p_emp_id;
END ASSIGN_SUPERVISOR;
/

BEGIN
    ASSIGN_SUPERVISOR(3431, 'John Evans'); 
END;
/


-- Update Employees Performance Score
CREATE OR REPLACE PROCEDURE UPDATE_PERFORMANCE_SCORE (
    p_emp_id IN employees.empid%TYPE,
    p_ps IN employees.performancescore%TYPE
) AS
BEGIN
    UPDATE employees
    SET performancescore = p_ps
    WHERE empid = p_emp_id;
END UPDATE_PERFORMANCE_SCORE;
/

BEGIN
    UPDATE_PERFORMANCE_SCORE(3454, 'Exceeds');
    UPDATE_PERFORMANCE_SCORE(3455, 'Fully Meets');
END;
/




--FUNCTIONS

-- Calculate Employee Tenure
CREATE OR REPLACE FUNCTION CALCULATE_TENURE(p_emp_id IN NUMBER)
RETURN NUMBER 
IS
  v_tenure NUMBER;
  v_startdate DATE;
BEGIN
  -- Retrieve the employee's start date
  SELECT STARTDATE INTO v_startdate
  FROM EMPLOYEES
  WHERE EMPID = p_emp_id;
  -- Calculate tenure in years
  v_tenure := FLOOR(MONTHS_BETWEEN(SYSDATE, v_startdate) / 12);
  RETURN v_tenure;
END;


SELECT CALCULATE_TENURE(3427) AS tenure FROM DUAL;


-- Check Employee Eligibility for Promotion 
CREATE OR REPLACE FUNCTION CHECK_PROMOTION_ELIGIBILITY(p_emp_id IN NUMBER)
RETURN NUMBER 
IS
  v_years_of_service NUMBER;
  v_performance_score VARCHAR2(26) ;
BEGIN
  -- Retrieve years of service and performance score
  SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, STARTDATE) / 12), PERFORMANCESCORE
  INTO v_years_of_service, v_performance_score
  FROM EMPLOYEES
  WHERE EMPID = p_emp_id;

  -- Check promotion eligibility criteria
  IF v_years_of_service >= 3 AND v_performance_score IN ('Exceeds', 'Fully Meets') THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END;


SELECT CHECK_PROMOTION_ELIGIBILITY(3456) AS is_eligible FROM DUAL;


-- Determine Employee Age
CREATE OR REPLACE FUNCTION GET_EMPLOYEE_AGE(p_emp_id IN NUMBER)
RETURN NUMBER 
IS
  v_birth_date DATE;
  v_age NUMBER;
BEGIN
  -- Retrieve the employee's birth date
  SELECT DOB INTO v_birth_date
  FROM EMPLOYEES
  WHERE EMPID = p_emp_id;

  -- Calculate age in years
  v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, v_birth_date) / 12);

  RETURN v_age;

END;


SELECT GET_EMPLOYEE_AGE(3457) AS employee_age FROM DUAL;



--TRIGGER

-- Audit Table
CREATE TABLE employee_status_audit (
    empid      NUMBER,
    old_status       VARCHAR2(50),
    new_status       VARCHAR2(50),
    change_date      DATE DEFAULT SYSDATE,
    user_name        VARCHAR2(50) 
);



-- Employee Status Change
CREATE OR REPLACE TRIGGER trg_employee_status_audit
AFTER UPDATE OF EmployeeStatus ON EMPLOYEES
FOR EACH ROW
BEGIN
        INSERT INTO employee_status_audit (empid, old_status, new_status, change_date, user_name)
        VALUES (:OLD.empid, :OLD.EmployeeStatus, :NEW.EmployeeStatus, SYSDATE, USER);
END;


UPDATE EMPLOYEES
SET EmployeeStatus = 'Not Active'
WHERE empid = 3427;

UPDATE EMPLOYEES
SET EmployeeStatus = 'Active'
WHERE empid = 3427;


select * from employee_status_audit;



-- Prevent Email Duplicates 
CREATE OR REPLACE TRIGGER trg_prevent_duplicate_email
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if ADEmail already exists in the table
    SELECT COUNT(*)
    INTO v_count
    FROM EMPLOYEES
    WHERE ADEmail = :NEW.ADEmail;

    -- If the email exists, raise an error
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'This email address already exists.');
    END IF;
END;


INSERT INTO EMPLOYEES (EmpID, FirstName, LastName, StartDate, ADEmail, EmployeeStatus)
VALUES (3527, 'John', 'Doe', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'uriah.bridges@bilearner.com', 'Active');


select * from employee_status_audit;



-- Prevent Backdating Start Date
CREATE OR REPLACE TRIGGER trg_check_startdate
BEFORE INSERT OR UPDATE OF StartDate ON EMPLOYEES
FOR EACH ROW
BEGIN
    -- Check if the StartDate is in the future
    IF :NEW.StartDate > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'StartDate cannot be set in the future.');
    END IF;
END;


INSERT INTO EMPLOYEES (EmpID, FirstName, LastName, StartDate, ADEmail, EmployeeStatus)
VALUES (3528, 'Jane', 'Smith', TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'jane.smith@bilearner.com', 'Active');


select * from employee_status_audit;