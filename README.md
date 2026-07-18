EMPLOYEE MANAGEMENT SYSTEM

A Bash-based employee management system built for Linux that simulates common IT administration tasks such as employee onboarding, offboarding, permission management, department management and audit logging.

The project was created to demonstrate practical Linux administration and Bash scripting skills without relying on external databases or third-party software.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ABOUT THE PROJECT

The Employee Management System stores employee records as text files and manages them through an interactive menu.

Instead of simulating permissions, the application uses real Linux file permissions (chmod) to demonstrate how employee files and department folders can be secured within a Linux environment.

The aim of the project is to showcase practical scripting techniques.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FEATURES

Create one or multiple employee records

Automatically generate unique employee IDs

Search employees by ID or name

Disable employee accounts

Remove employee records

List all employees

Change employee departments

View employee file permissions

Change employee file permissions

View department permissions

Change department permissions

Display employee statistics

Record administrative actions in an audit log

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TECHNOLOGIES USED

Bash

Linux

Shell scripting

GNU utilities:
grep
sed
awk
stat
chmod
ln

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PROJECT STRUCTURE

Employee-Management-System/
employee_manager.sh
employees/
departments/
logs/

The required directories are created automatically the first time the application is run.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

LINUX PERMISSIONS

One of the main goals of this project was to work with real Linux permissions rather than simulated ones.

Employee files and department folders use standard Linux permissions such as:

600 - Owner read/write
640 - Owner read/write, group read
700 - Owner full access
750 - Owner full access, group read/execute
755 - Owner full access, group and others read/execute

Permission changes are validated to help prevent accidental removal of the owner's access.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

EMPLOYEE RECORDS

Each employee is stored as an individual text file containing:

Employee ID

Name

Department

Role

Status

Date Created

Using individual text files keeps the project simple while demonstrating file handling and directory management within Bash.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RUNNING THE PROGRAM

Clone the repository:
git clone https://github.com/RoseStef/Employee-Management-System.git

Open the project:
cd Employee-Management-System

Make the script executable:
chmod +x employee_manager.sh

Run the program:
./employee_manager.sh

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

WHAT THIS PROJECT DEMONSTRATES

This project demonstrates practical experience with:

Bash scripting

Linux file management

File permissions

User input validation

Error handling

Logging

Functions

Loops

Conditional statements

Shell automation

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FUTURE IMPROVEMENTS

Possible future enhancements include:

User authentication

Role-based access control

Employee editing

CSV import/export

Backup and restore functionality

Reporting features

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AUTHOR 

Stefan Rose
GitHub: https://github.com/RoseStef

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

LICENSE

This project is available for educational and portfolio purposes.
