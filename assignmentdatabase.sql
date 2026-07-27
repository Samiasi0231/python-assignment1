CREATE TABLE instructors (
    instructor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    department VARCHAR(100) NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    year INT NOT NULL,
    grade CHAR(2),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);
INSERT INTO students
(student_id, first_name, last_name, date_of_birth, enrollment_date, major)
VALUES
(1,'John','Doe','2002-01-15','2023-09-01','Computer Science'),
(2,'Mary','Smith','2001-05-20','2022-09-01','Mathematics'),
(3,'David','Brown','2003-07-11','2024-09-01','Physics'),
(4,'Grace','Wilson','2002-09-10','2023-09-01','Chemistry'),
(5,'James','Johnson','2001-12-05','2022-09-01','Economics'),
(6,'Sarah','Taylor','2003-04-22','2024-09-01','Computer Science'),
(7,'Daniel','White','2002-06-18','2023-09-01','Accounting'),
(8,'Linda','Green','2001-08-09','2022-09-01','Biology'),
(9,'Michael','Hall','2003-03-30','2024-09-01','Mathematics'),
(10,'Sophia','King','2002-11-25','2023-09-01','Physics');

INSERT INTO courses
(course_name, credits, department)
VALUES
('Database Systems',4,'Computer Science'),
('Programming I',3,'Computer Science'),
('Calculus I',4,'Mathematics'),
('Linear Algebra',3,'Mathematics'),
('Organic Chemistry',4,'Chemistry'),
('Microeconomics',3,'Economics'),
('Financial Accounting',4,'Accounting'),
('General Biology',3,'Biology');

INSERT INTO instructors
(first_name, last_name, hire_date, department)
VALUES
('Robert','Miller','2019-08-01','Computer Science'),
('Patricia','Clark','2018-07-15','Mathematics'),
('Andrew','Lewis','2020-01-10','Chemistry'),
('Nancy','Walker','2021-09-05','Economics'),
('Charles','Young','2017-03-12','Accounting');

INSERT INTO enrollments
(student_id, course_id, semester, year, grade)
VALUES
(1,1,'First',2024,'A'),
(1,2,'First',2024,'B'),
(2,3,'First',2024,'A'),
(2,4,'Second',2024,'B'),
(3,5,'First',2024,'A'),
(3,1,'Second',2024,'B'),
(4,5,'First',2024,'A'),
(4,3,'Second',2024,'B'),
(5,6,'First',2024,'C'),
(5,7,'Second',2024,'B'),
(6,2,'First',2024,'A'),
(6,1,'Second',2024,'A'),
(7,7,'First',2024,'B'),
(7,3,'Second',2024,'C'),
(8,8,'First',2024,'A'),
(8,4,'Second',2024,'B'),
(9,3,'First',2024,'A'),
(9,2,'Second',2024,'A'),
(10,5,'First',2024,'B'),
(10,1,'Second',2024,'A');

SELECT *
FROM students;

SELECT *
FROM courses
WHERE credits > 3;

SELECT *
FROM instructors
WHERE department = 'Computer Science';