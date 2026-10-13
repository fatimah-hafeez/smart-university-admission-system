-- ================================================================
-- PROJECT 1: SMART UNIVERSITY ADMISSION SYSTEM
-- Complete SQL Script (MySQL 8.0+)
-- ================================================================

CREATE DATABASE IF NOT EXISTS university_admission;
USE university_admission;

-- ================================================================
-- SECTION 1: CREATE TABLES
-- ================================================================

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50)
);

select * from departments; 

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male','Female','Other'),
    phone VARCHAR(20),
    department_id INT,
    admission_status ENUM('Completed','Pending') DEFAULT 'Pending',
    fax_number VARCHAR(20),                       -- will be dropped later (unnecessary column)
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

SELECT * from students;

CREATE TABLE admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    admission_date DATE NOT NULL,
    gpa DECIMAL(3,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

select * from admissions ;

CREATE TABLE scholarships (
    scholarship_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    amount DECIMAL(10,2),
    scholarship_type VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

select * from scholarships;

-- Extra table needed so we can demonstrate the SET operator requirement
-- (students enrolled in BOTH scholarship and hostel programs)
CREATE TABLE hostel_enrollment (
    hostel_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    room_no VARCHAR(10),
    enrolled_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

select * from hostel_enrollment;
-- ================================================================
-- SECTION 2: MODIFY SCHEMA (ALTER TABLE)
-- ================================================================

ALTER TABLE students ADD COLUMN blood_group VARCHAR(5);
ALTER TABLE students ADD COLUMN emergency_contact VARCHAR(20);
ALTER TABLE students ADD COLUMN guardian_name VARCHAR(100);

select * from students ;
-- After discussion, fax_number was deemed unnecessary (no one uses fax anymore)
ALTER TABLE students DROP COLUMN fax_number;

select * from students; 
-- ================================================================
-- SECTION 3: INSERT DATA
-- ================================================================

INSERT INTO departments (department_name, building) VALUES
('Computer Science', 'Block A'),
('Electrical Engineering', 'Block B'),
('Business Administration', 'Block C'),
('Mathematics', 'Block D'),
('Physics', 'Block E');

select * from departments;
-- 30 student records (5 have admission_status = 'Pending' = never completed admission)
INSERT INTO students
(first_name, last_name, date_of_birth, gender, phone, department_id, admission_status, blood_group, emergency_contact, guardian_name)
VALUES
('Ahmed','Khan','2002-03-14','Male','03001234501',1,'Completed','A+','03009876501','Tariq Khan'),
('Ayesha','Malik','2003-07-22','Female','03001234502',2,'Completed','B+','03009876502','Naveed Malik'),
('Bilal','Ahmed','2001-11-05','Male','03001234503',3,'Completed','O+','03009876503','Rashid Ahmed'),
('Sara','Iqbal','2002-01-19','Female','03001234504',4,'Completed','A-','03009876504','Iqbal Hussain'),
('Ali','Raza','2000-09-30','Male','03001234505',5,'Completed','B-','03009876505','Raza Mehmood'),
('Amna','Sheikh','2003-05-02','Female','03001234506',1,'Completed','O-','03009876506','Anwar Sheikh'),
('Usman','Tariq','2001-12-11','Male','03001234507',2,'Pending','AB+','03009876507','Tariq Mahmood'),
('Hina','Aslam','2002-08-08','Female','03001234508',3,'Completed','AB-','03009876508','Nazir Aslam'),
('Zain','Abbas','1999-04-17','Male','03001234509',4,'Completed','A+','03009876509','Ali Abbas'),
('Mariam','Yousuf','2003-10-25','Female','03001234510',5,'Completed','B+','03009876510','Yousuf Khan'),
('Adeel','Nawaz','2001-06-13','Male','03001234511',1,'Completed','O+','03009876511','Ahmed Nawaz'),
('Sana','Farooq','2002-02-28','Female','03001234512',2,'Completed','A-','03009876512','Iqbal Farooq'),
('Hamza','Siddiqui','2000-03-09','Male','03001234513',3,'Completed','B-','03009876513','Anwar Siddiqui'),
('Iqra','Batool','2001-07-07','Female','03001234514',4,'Pending','O-','03009876514','Rehman Batool'),
('Arslan','Javed','2002-09-16','Male','03001234515',5,'Completed','AB+','03009876515','Akhtar Javed'),
('Nida','Rafique','2003-01-01','Female','03001234516',1,'Completed','AB-','03009876516','Anwar Rafique'),
('Asad','Mehmood','1998-05-05','Male','03001234517',2,'Completed','A+','03009876517','Sarwar Mehmood'),
('Rabia','Shahid','2002-12-20','Female','03001234518',3,'Completed','B+','03009876518','Iqbal Shahid'),
('Faisal','Hussain','2001-04-04','Male','03001234519',4,'Pending','O+','03009876519','Ali Hussain'),
('Amina','Zafar','2003-03-11','Female','03001234520',5,'Completed','A-','03009876520','Mehmood Zafar'),
('Kamran','Aziz','2000-10-10','Male','03001234521',1,'Completed','B-','03009876521','Khan Aziz'),
('Tehmina','Waseem','2002-06-06','Female','03001234522',2,'Completed','O-','03009876522','Anwar Waseem'),
('Adnan','Qureshi','2001-08-19','Male','03001234523',3,'Completed','AB+','03009876523','Nadeem Qureshi'),
('Sadia','Rehman','2002-11-11','Female','03001234524',4,'Pending','AB-','03009876524','Fareed Rehman'),
('Anas','Bhatti','1999-09-09','Male','03001234525',5,'Completed','A+','03009876525','Aslam Bhatti'),
('Farah','Naeem','2003-02-14','Female','03001234526',1,'Completed','B+','03009876526','Iqbal Naeem'),
('Aslam','Ghani','2000-01-30','Male','03001234527',2,'Completed','O+','03009876527','Sarwar Ghani'),
('Wajiha','Noor','2002-04-23','Female','03001234528',3,'Completed','A-','03009876528','Muhammad Noor'),
('Ahsan','Ilyas','2001-05-15','Male','03001234529',4,'Pending','B-','03009876529','Ahmed Ilyas'),
('Zara','Fatima','2003-08-08','Female','03001234530',5,'Completed','O-','03009876530','Bibi Fatima');

select * from students;

-- Admissions only exist for students who actually completed admission
-- (student_ids 7, 14, 19, 24, 29 are Pending, so they have NO row here)
INSERT INTO admissions (student_id, admission_date, gpa) VALUES
(1,'2024-08-15',3.85),
(2,'2024-08-16',3.42),
(3,'2024-08-17',2.95),
(4,'2024-08-18',3.75),
(5,'2024-08-19',3.10),
(6, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 3.92),
(8,'2024-08-21',2.80),
(9,'2024-08-22',3.65),
(10,'2024-08-23',3.55),
(11,'2024-08-24',3.71),
(12,'2024-08-25',3.20),
(13,'2024-08-26',2.99),
(15,'2024-08-27',3.88),
(16, DATE_SUB(CURDATE(), INTERVAL 12 DAY), 3.05),
(17,'2024-08-29',3.77),
(18,'2024-08-30',3.15),
(20,'2024-09-01',3.60),
(21,'2024-09-02',3.30),
(22,'2024-09-03',3.95),
(23,'2024-09-04',2.75),
(25,'2024-09-05',3.45),
(26, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 3.72),
(27,'2024-09-07',3.08),
(28,'2024-09-08',3.90),
(30, DATE_SUB(CURDATE(), INTERVAL 28 DAY), 3.25);

select * from admissions;
-- Scholarships (only completed/admitted students can have one)
INSERT INTO scholarships (student_id, amount, scholarship_type) VALUES
(1,85000,'Merit'),
(2,45000,'Need-based'),
(4,92000,'Merit'),
(6,110000,'Merit'),
(9,30000,'Need-based'),
(10,15000,'Need-based'),
(11,60000,'Merit'),
(15,95000,'Merit'),
(17,40000,'Merit'),
(18,25000,'Need-based'),
(20,70000,'Merit'),
(22,130000,'Merit'),
(26,55000,'Need-based'),
(27,20000,'Need-based'),
(28,100000,'Merit');

select * from scholarships ;
-- Hostel enrollment (some overlap with scholarship students, some don't)
INSERT INTO hostel_enrollment (student_id, room_no, enrolled_date) VALUES
(1,'H-101','2024-08-20'),
(4,'H-102','2024-08-21'),
(6,'H-103','2024-08-22'),
(9,'H-104','2024-08-23'),
(11,'H-105','2024-08-24'),
(15,'H-106','2024-08-25'),
(20,'H-107','2024-08-26'),
(26,'H-108','2024-08-27'),
(28,'H-109','2024-08-28'),
(3,'H-110','2024-08-29'),
(8,'H-111','2024-08-30'),
(13,'H-112','2024-09-01'),
(21,'H-113','2024-09-02'),
(25,'H-114','2024-09-03');

select * from hostel_enrollment;

-- ================================================================
-- SECTION 4: DISPLAY / AGGREGATE QUERIES
-- ================================================================

-- Average GPA
SELECT AVG(gpa) AS average_gpa FROM admissions;

-- Maximum scholarship
SELECT MAX(amount) AS max_scholarship FROM scholarships;

-- Oldest student (earliest date_of_birth)

SELECT student_id, first_name, last_name, date_of_birth
FROM students
ORDER BY date_of_birth ASC
LIMIT 1;

-- Total students in each department
SELECT d.department_name, COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_name;

-- ================================================================
-- SECTION 5: STRING / DATE FUNCTIONS
-- ================================================================

-- Convert student names into uppercase
SELECT student_id, UPPER(CONCAT(first_name,' ',last_name)) AS full_name_uppercase
FROM students;

-- Display admission year separately from admission date
SELECT a.student_id, a.admission_date, YEAR(a.admission_date) AS admission_year
FROM admissions a;

-- ================================================================
-- SECTION 6: FILTER QUERIES
-- ================================================================

-- Students whose names start with "A"
SELECT student_id, first_name, last_name
FROM students
WHERE first_name LIKE 'A%';

-- Students admitted within the last 30 days
SELECT s.student_id, s.first_name, s.last_name, a.admission_date
FROM students s
JOIN admissions a ON s.student_id = a.student_id
WHERE a.admission_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Students receiving scholarships between Rs.20,000 and Rs.100,000
SELECT s.student_id, s.first_name, s.last_name, sc.amount
FROM students s
JOIN scholarships sc ON s.student_id = sc.student_id
WHERE sc.amount BETWEEN 20000 AND 100000;

-- ================================================================
-- SECTION 7: SET OPERATOR
-- Students enrolled in BOTH scholarship AND hostel programs
-- (MySQL 8.0.31+ supports INTERSECT natively)
-- ================================================================

SELECT student_id FROM scholarships
INTERSECT
SELECT student_id FROM hostel_enrollment;

-- If your MySQL version is older than 8.0.31, use this equivalent instead:
-- SELECT DISTINCT sc.student_id
-- FROM scholarships sc
-- WHERE sc.student_id IN (SELECT student_id FROM hostel_enrollment);