
/**
 * Smart University Admission System
 * Backend server connecting the frontend to the MySQL database.
 * Handles HTTP requests and returns query results as JSON.
 */


const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());          // Enable cross-origin requests from the frontend.
app.use(express.json());  // Parse incoming JSON request bodies.

// ================================================================
// DATABASE CONNECTION
// ================================================================
const pool = mysql.createPool({

  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || 'university_admission',
  waitForConnections: true,
  connectionLimit: 10
});

// Test the database connection on server startup

pool.getConnection()
  .then(conn => {
    console.log('Database connection established successfully.');
    conn.release();
  })
  .catch(err => {
    console.error(' Database connection failed:', err.message);
    console.error('Check your MySQL credentials and database configuration in the .env file.');
  });

// Fetch departments for the student form dropdown.
app.get('/api/departments', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM departments');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ================================================================
// STUDENTS - INSERT & RETRIEVE
// ================================================================

// Retrieve all students along with their department names 
app.get('/api/students', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT s.student_id, s.first_name, s.last_name, s.date_of_birth, s.gender,
             s.phone, d.department_name, s.admission_status, s.blood_group,
             s.emergency_contact, s.guardian_name
      FROM students s
      LEFT JOIN departments d ON s.department_id = d.department_id
      ORDER BY s.student_id
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Insert a new student record
app.post('/api/students', async (req, res) => {
  const {
    first_name, last_name, date_of_birth, gender, phone,
    department_id, admission_status, blood_group,
    emergency_contact, guardian_name
  } = req.body;

  try {
    const [result] = await pool.query(
      `INSERT INTO students
       (first_name, last_name, date_of_birth, gender, phone, department_id,
        admission_status, blood_group, emergency_contact, guardian_name)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [first_name, last_name, date_of_birth, gender, phone, department_id,
       admission_status, blood_group, emergency_contact, guardian_name]
    );
    res.json({ success: true, student_id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ================================================================
// ADMISSIONS - INSERT & RETRIEVE
// ================================================================

app.get('/api/admissions', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT a.admission_id, a.student_id,
             CONCAT(s.first_name, ' ', s.last_name) AS student_name,
             a.admission_date, a.gpa
      FROM admissions a
      JOIN students s ON a.student_id = s.student_id
      ORDER BY a.admission_id
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/admissions', async (req, res) => {
  const { student_id, admission_date, gpa } = req.body;
  try {
    const [result] = await pool.query(
      `INSERT INTO admissions (student_id, admission_date, gpa) VALUES (?, ?, ?)`,
      [student_id, admission_date, gpa]
    );
    res.json({ success: true, admission_id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ================================================================
// QUERIES AND REPORTS
// ================================================================

app.get('/api/queries/average-gpa', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT AVG(gpa) AS average_gpa FROM admissions');
    res.json(rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/max-scholarship', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT MAX(amount) AS max_scholarship FROM scholarships');
    res.json(rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/oldest-student', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT student_id, first_name, last_name, date_of_birth
      FROM students ORDER BY date_of_birth ASC LIMIT 1
    `);
    res.json(rows[0] || {});
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/department-totals', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT d.department_name, COUNT(s.student_id) AS total_students
      FROM departments d
      LEFT JOIN students s ON d.department_id = s.department_id
      GROUP BY d.department_name
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/uppercase-names', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT student_id, UPPER(CONCAT(first_name,' ',last_name)) AS full_name_uppercase
      FROM students
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/admission-years', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT student_id, admission_date, YEAR(admission_date) AS admission_year
      FROM admissions
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/starts-with-a', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT student_id, first_name, last_name
      FROM students WHERE first_name LIKE 'A%'
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/recent-admissions', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT s.student_id, s.first_name, s.last_name, a.admission_date
      FROM students s
      JOIN admissions a ON s.student_id = a.student_id
      WHERE a.admission_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/scholarship-range', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT s.student_id, s.first_name, s.last_name, sc.amount
      FROM students s
      JOIN scholarships sc ON s.student_id = sc.student_id
      WHERE sc.amount BETWEEN 20000 AND 100000
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/queries/scholarship-and-hostel', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT student_id FROM scholarships
      INTERSECT
      SELECT student_id FROM hostel_enrollment
    `);
    res.json(rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// ================================================================

app.listen(PORT, () => {
  console.log(` Server is running at http://localhost:${PORT}`);
});

