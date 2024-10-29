# Employee Management System

## Overview
The **Employee Management System** project is designed to handle common tasks related to employee management within an organization, focusing on data integrity, employee status tracking, and job-related updates. It includes a set of stored procedures, functions, and triggers to streamline employee information management, enforce rules, and maintain audit logs.

## Project Structure

### Stored Procedures
1. **`UPDATE_JOB_TITLE`**
   - Updates an employee’s job title.
   - **Parameters**: `emp_id` (Employee ID), `new_job_title` (String)

2. **`MARK_EMPLOYEE_EXIT`**
   - Marks an employee's exit by setting the exit date and updating status to "Inactive."
   - **Parameters**: `emp_id` (Employee ID), `exit_date` (Date)

3. **`ASSIGN_SUPERVISOR`**
   - Assigns or updates a supervisor for an employee.
   - **Parameters**: `emp_id` (Employee ID), `supervisor_name` (String)

4. **`UPDATE_PERFORMANCE_SCORE`**
   - Updates an employee’s performance score.
   - **Parameters**: `emp_id` (Employee ID), `performance_score` (Integer)

### Functions
1. **`CALCULATE_TENURE`**
   - Calculates the employee's tenure based on the start date.
   - **Parameter**: `emp_id` (Employee ID)
   - **Returns**: Integer (number of years)

2. **`CHECK_PROMOTION_ELIGIBILITY`**
   - Checks if an employee is eligible for promotion based on years of service and performance score.
   - **Parameter**: `emp_id` (Employee ID)
   - **Returns**: Boolean (true if eligible)

3. **`GET_EMPLOYEE_AGE`**
   - Calculates the current age of an employee.
   - **Parameter**: `emp_id` (Employee ID)
   - **Returns**: Integer (age in years)

### Triggers
1. **Log Employee Status Changes**
   - Logs changes to the employee’s status in an audit table.
   - **Details Logged**: Employee ID, old status, new status, date of change.

2. **Prevent Duplicates in Email**
   - Prevents duplicate email addresses by blocking inserts with an existing email in the table.

3. **Prevent Backdating Start Date**
   - Ensures the employee’s `StartDate` is not set to a future date.

## Getting Started

### Prerequisites
- Oracle SQL
  
### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/EmployeeManagementSystem.git
