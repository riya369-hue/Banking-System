This project is a Banking and Finance Management System developed using Oracle SQL and PL/SQL.
It demonstrates practical implementation of core DBMS concepts such as table design, normalization, relationships, stored procedures, functions, triggers, cursors, views, sequences, and exception handling.

The system automates major banking operations including customer management, account handling, transactions, loans, investments, branch and employee management, while ensuring data integrity and business rule enforcement at the database level.

Objectives

To design a normalized relational database for a banking system

To implement business logic using PL/SQL

To demonstrate use of procedures, functions, triggers, cursors, views, and exception handling

To ensure data consistency, validation, and security

To simulate real-world banking operations using SQL

🗂️ Database Entities

The system consists of 8 main tables:

Customer

CustomerPhone

Branch

Employee

Account

BankTransaction

Loan

Investment

Each table is connected through primary keys and foreign keys, representing real banking relationships.

🧱 Normalization

Database is normalized up to Third Normal Form (3NF)

Eliminates redundancy and ensures data integrity

Multi-valued attributes (e.g., phone numbers) are handled using separate tables

Before normalization: 7 tables

After normalization: 8 tables

⚙️ Features Implemented
🔹 Customer Management

Add customer with phone number

Add multiple phone numbers for a customer

Update customer details

Delete customer with dependency checks

🔹 Account Management

Open new bank account

Close account

Freeze / unfreeze account

Monthly interest posting

Automatic account number generation

🔹 Transactions

Deposit & withdrawal

Fund transfer between accounts

Transaction validation using triggers

Prevention of transactions on frozen accounts

🔹 Loan Management

Create loan

Automatic loan ID generation

Update loan status

Auto-close loan on end date

EMI and total payable calculation (functions)

🔹 Investment Management

Create investment

Update investment status

Interest and maturity calculation using functions

Investment summary using views

🔹 Employee & Branch

Assign employees to branches

Transfer employee between branches

🧠 PL/SQL Concepts Used

Stored Procedures – business logic implementation

Functions – calculations (EMI, interest, maturity)

Triggers – automation & validation

Cursors – processing multiple rows

Views – summarized and virtual data representation

Sequences – automatic primary key generation

Exception Handling – error handling using RAISE_APPLICATION_ERROR

📁 Project Structure
📦 Banking-DBMS-Project
 ┣ 📜 tables.sql        → All CREATE TABLE statements
 ┣ 📜 sequences.sql     → Sequences for primary keys
 ┣ 📜 triggers.sql      → All BEFORE/AFTER triggers
 ┣ 📜 procedures.sql    → Stored procedures
 ┣ 📜 functions.sql     → User-defined functions
 ┣ 📜 cursors.sql       → Cursor programs with exception handling
 ┣ 📜 views.sql         → Database views
 ┣ 📜 inserts.sql       → Sample data insertion
 ┣ 📄 Project_Report.pdf
 ┗ 📄 README.md

🛠️ Technologies Used

Oracle Live SQL

SQL

PL/SQL

▶️ How to Run the Project

Open Oracle Live SQL

Execute files in the following order:

tables.sql

sequences.sql

triggers.sql

procedures.sql

functions.sql

views.sql

inserts.sql

cursors.sql

Enable output:

SET SERVEROUTPUT ON;


Execute procedures/functions to test functionality

📊 Key Highlights

Fully DBMS-oriented project (no UI dependency)

Real-world banking logic implemented at database level

Strong use of automation, validation, and exception handling

Suitable for college viva and academic submission

👩‍🎓 Author

Riya Bisht
MCA | DBMS Project

📜 License

This project is for academic and learning purposes only.
