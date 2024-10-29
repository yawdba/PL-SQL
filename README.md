# Employee Management System

## Overview
The **Employee Management System** project provides a set of stored procedures, functions, and triggers to facilitate efficient employee data management and enforce database integrity. Key features include updating employee information, tracking job status changes, calculating tenure, checking promotion eligibility, and ensuring data validation through custom triggers.

## Project Structure

### Stored Procedures
1. **`UPDATE_JOB_TITLE`**
   - Updates an employee’s job title.
   - **Parameters**:
     - `p_emp_id`: Employee ID
     - `p_new_job_title`: New job title


2. **`MARK_EMPLOYEE_EXIT`**
   - Updates an employee's exit date and changes their status to "Not Active."
   - **Parameters**:
     - `p_emp_id`: Employee ID
     - `p_exit_date`: Exit date


3. **`ASSIGN_SUPERVISOR`**
   - Assigns or updates a supervisor for an employee.
   - **Parameters**:
     - `p_emp_id`: Employee ID
     - `p_supervisor`: Supervisor name


4. **`UPDATE_PERFORMANCE_SCORE`**
   - Updates an employee’s performance score.
   - **Parameters**:
     - `p_emp_id`: Employee ID
     - `p_ps`: New performance score


### Functions
1. **`CALCULATE_TENURE`**
   - Calculates the tenure of an employee in years based on their start date.
   - **Parameter**:
     - `p_emp_id`: Employee ID
   - **Returns**: Integer (number of years)


2. **`CHECK_PROMOTION_ELIGIBILITY`**
   - Checks if an employee is eligible for promotion based on years of service and performance score.
   - **Parameter**:
     - `p_emp_id`: Employee ID
   - **Returns**: 1 if eligible, 0 if not


3. **`GET_EMPLOYEE_AGE`**
   - Calculates the current age of an employee based on their date of birth.
   - **Parameter**:
     - `p_emp_id`: Employee ID
   - **Returns**: Integer (age in years)


### Triggers
1. **Employee Status Change Audit (`trg_employee_status_audit`)**
   - Logs changes to the `EmployeeStatus` field in the `employee_status_audit` table whenever an update occurs.
   - **Fields Logged**: Employee ID, old status, new status, date of change, and user name.


2. **Prevent Duplicate Emails (`trg_prevent_duplicate_email`)**
   - Prevents duplicate email addresses by raising an error if the `ADEmail` field already exists in the table.


3. **Prevent Backdating Start Date (`trg_check_startdate`)**
   - Ensures the `StartDate` of a new employee is not set in the future by raising an error if `StartDate` exceeds the current date.


### Audit Table
The **`employee_status_audit`** table records changes to employee status fields.
- **Fields**:
  - `empid`: Employee ID
  - `old_status`: Previous status
  - `new_status`: Updated status
  - `change_date`: Date of change
  - `user_name`: User who made the change

## Getting Started

### Prerequisites
- Oracle SQL.

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/EmployeeManagementSystem.git
