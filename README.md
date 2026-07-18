Employee Management System

A Bash-based employee management system designed for Linux environments, demonstrating practical IT administration workflows such as onboarding, offboarding, permission management, departmental organisation and audit logging. This project showcases applied knowledge of shell scripting, Linux permissions, file handling and automation.

1. Overview
This system provides a structured, file-based approach to managing employee records and departmental permissions. It uses real Linux file permissions and groups, offering a realistic simulation of administrative tasks commonly performed in IT support, service desk and junior sysadmin roles.
The project is intentionally built without external dependencies or databases, highlighting the ability to design functional tooling using only Bash and core Linux utilities.

2. Key Features

2.1 Create one or multiple employee records

2.2 Automatically generate unique Employee IDs

2.3 Search employees by Employee ID or Name

2.4 Disable employee accounts

2.5 Remove employee records

2.6 View all employees in a formatted table

2.7 Change employee departments

2.8 View and modify Linux file permissions

2.9 View and modify department (group) permissions

2.10 Generate basic employee statistics

2.11 Audit logging of administrative actions


3. Technical Skills Demonstrated

3.1 Bash scripting and automation

3.1 Linux file and directory management

3.2 User input validation and error handling

3.3 Use of core GNU utilities (grep, sed, awk, stat, chmod, ln)

3.4 Permission and group management

3.5 Modular script design

3.6 Logging and audit trail creation

3.7 Structured data handling using the filesystem


4. Project Structure

Employee-Management-System/
│
├── employee_manager.sh
├── employees/
├── departments/
└── logs/
Directories are automatically created at runtime if missing.


5. Main Menu
   
1. Add Employee(s)
2. Disable An Employee From The System
3. Remove Employee(s)
4. Search Employee
5. List Employee
6. List Employee Permissions
7. Change Employee Permissions
8. Change Employee Department
9. List Group Permissions
10. Change Group Permissions
11. Statistics
12. Exit


6. Linux Permission Management
   
The system interacts with real Linux permissions using chmod, providing a practical demonstration of permission handling rather than simulated behaviour.

Examples:

+-----------+----------------------------------------------+
| Permission| Description                                  |
+-----------+----------------------------------------------+
| 600       | Owner read/write                             |
| 640       | Owner read/write, Group read                 |
| 700       | Owner full access                            |
| 750       | Owner full access, Group read/execute        |
| 755       | Owner full access, Others read/execute       |
+-----------+----------------------------------------------+

Permission changes are validated to prevent accidental removal of essential access.


7. Employee Records

Each employee is stored as an individual text file containing:

7.1 Employee ID
7.2 Name
7.3 Department
7.4 Role
7.5 Status
7.6 Date Created

This approach demonstrates simple, transparent data storage without requiring a database.


8. Running the Program

Prerequisites:
- Linux environment
- Bash shell
- Git installed

Steps:
8.1 Clone the repository:
   git clone https://github.com/RoseStef/Employee-Management-System.git

8.2 Enter the project directory:
    cd Employee-Management-System

8.3 Make the script executable:
    chmod +x employee_manager.sh

8.4 Run the application:
    ./employee_manager.sh



9. This project highlights the ability to:

9.1 Automate repetitive tasks

9.2 Work confidently in a Linux environment

9.3 Manage permissions and groups

9.4 Structure scripts for maintainability

9.5 Create tools that support operational workflows

Author
Stefan Rose  
GitHub: https://github.com/RoseStef

License
This project is provided for portfolio purposes. 
