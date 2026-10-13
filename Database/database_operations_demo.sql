-- Demonstration DML operations
-- Review each statement before executing it.

USE university_admission;

-- 1. Scholarship update
UPDATE scholarships s
JOIN admissions a ON s.student_id = a.student_id
SET s.amount = s.amount * 1.10
WHERE a.gpa > 3.70;

select * from scholarships;
.

-- 2. Pending-student deletion
-- WARNING: Related records may also be deleted.

SET SQL_SAFE_UPDATES = 0;
DELETE FROM students
WHERE admission_status = 'Pending';
select * from students ;