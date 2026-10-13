# Smart University Admission System

A database-driven university admission management application built with **MySQL, Node.js, Express, and JavaScript**. The system manages student records, admissions, department information, scholarships, and hostel enrollment, with a REST API connecting the database to a web-based interface.

## Features

- **Student Management:** Add and retrieve student records.
- **Admission Management:** Record and retrieve student admission information.
- **Department Information:** Retrieve departments for the application interface.
- **SQL Reporting:** Run queries for average GPA, maximum scholarship, department-wise student totals, admission years, and other report requirements.
- **Relational Database:** Uses primary keys, foreign keys, joins, aggregate functions, and other SQL operations.
- **REST API:** Exposes endpoints through an Express server.
- **Web Interface:** Provides forms, data tables, and report views.

## Technology Stack

- **Database:** MySQL
- **Backend:** Node.js, Express
- **Database Driver:** `mysql2`
- **Middleware:** CORS, dotenv
- **Frontend:** HTML, CSS, JavaScript

## Database Structure

The database includes the following tables:

| Table | Purpose |
|---|---|
| `departments` | Stores department names and building information |
| `students` | Stores student details and admission status |
| `admissions` | Stores admission dates and GPA records |
| `scholarships` | Stores scholarship amounts and types |
| `hostel_enrollment` | Stores hostel enrollment records |

Foreign-key relationships maintain links between students and related records.

## API Endpoints

The backend runs locally on port `5000` by default.

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/departments` | Retrieve departments |
| GET | `/api/students` | Retrieve student records |
| POST | `/api/students` | Add a student |
| GET | `/api/admissions` | Retrieve admissions |
| POST | `/api/admissions` | Add an admission |
| GET | `/api/queries/average-gpa` | Calculate average GPA |
| GET | `/api/queries/max-scholarship` | Retrieve maximum scholarship |
| GET | `/api/queries/oldest-student` | Retrieve the oldest student record |
| GET | `/api/queries/department-totals` | Count students by department |
| GET | `/api/queries/uppercase-names` | Return uppercase student names |
| GET | `/api/queries/admission-years` | Extract admission years |
| GET | `/api/queries/starts-with-a` | Filter first names beginning with A |
| GET | `/api/queries/recent-admissions` | Retrieve recent admissions |
| GET | `/api/queries/scholarship-range` | Filter scholarship amounts |
| GET | `/api/queries/scholarship-and-hostel` | Find students in both programs |

## Setup and Installation

### Prerequisites

- Node.js and npm
- MySQL Server
- A MySQL client, such as MySQL Workbench

### 1. Create the database

Run `Database/university_admission.sql` in your MySQL client to create the database, tables, sample records, and reporting queries.

Review the SQL script before executing it against any database containing important data.

### 2. Configure the backend

Open a terminal in the `Backend` directory and install the dependencies:

```bash
npm install
```

Create a local `.env` file in `Backend` using `.env.example` as a template:

```dotenv
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=university_admission
PORT=5000
```

Replace the placeholder password with your own MySQL credentials. Do not commit `.env` to version control.

### 3. Start the backend

From the `Backend` directory, run:

```bash
npm start
```

The API should be available at `http://localhost:5000`.

For example, open `http://localhost:5000/api/departments` to retrieve department records.

### 4. Open the frontend

Open `Frontend/index.html` in a browser while the backend and MySQL server are running. The frontend communicates with the local API at `http://localhost:5000/api`.

## SQL Demonstrations

The separate `Database/database_operations_demo.sql` file contains demonstration `UPDATE` and `DELETE` statements. Review these statements carefully before executing them because they modify or delete records.

## Project Focus

This project demonstrates relational database design, SQL querying, REST API development, and integration between a web interface and a MySQL-backed backend.
