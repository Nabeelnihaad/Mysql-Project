CREATE DATABASE Library_Project;
USE Library_Project;

CREATE TABLE Branch_Project
(
  Branch_no INT PRIMARY KEY,
  Manager_Id INT,
  Branch_address VARCHAR(50),
  Contact_no INT
);

INSERT INTO Branch_Project (Branch_no, Manager_Id, Branch_address, Contact_no) VALUES
(1, 001, 'Main Street, City', 1234567890),
(2, 002, 'First Avenue, Town', 9876543210),
(3, 003, 'Park Road, Village', 4567890123),
(4, 004, 'Garden Lane, Suburb', 7890123456),
(5, 005, 'Ocean Drive, Coastal', 2345678901);

CREATE TABLE Employee_Project
(
  Emp_Id INT PRIMARY KEY,
  Emp_name VARCHAR(30),
  Position VARCHAR(30),
  Salary DECIMAL(10, 2)
);

INSERT INTO Employee_Project (Emp_Id, Emp_name, Position, Salary) VALUES
(001, 'John Doe', 'Assistant', 12000.00),
(002, 'Jane Smith', 'Manager', 15000.00),
(003, 'David Johnson', 'Librarian', 10000.00),
(004, 'Emily Davis', 'Assistant', 12000.00),
(005, 'Michael Brown', 'Director', 14000.00);

CREATE TABLE Customer_Project
(
  Customer_Id INT PRIMARY KEY,
  Customer_name VARCHAR(30),
  Customer_address VARCHAR(50),
  Reg_date DATE
);

INSERT INTO Customer_Project (Customer_Id, Customer_name, Customer_address, Reg_date) VALUES
(1, 'Alice Thompson', '123 ABC Street', '2022-10-12'),
(2, 'Bob Wilson', '456 XYZ Avenue', '2022-09-22'),
(3, 'Charlie Davis', '789 DEF Road', '2023-01-02'),
(4, 'David Johnson', '321 GHI Lane', '2022-12-15'),
(5, 'Eve Anderson', '654 JKL Drive', '2022-11-18');

CREATE TABLE Books_Project
(
  ISBN VARCHAR(50) PRIMARY KEY,
  Book_title VARCHAR(50),
  Category VARCHAR(50),
  Rental_Price DECIMAL(10, 2),
  Status VARCHAR(10),
  Author VARCHAR(50),
  Publisher VARCHAR(50)
);

INSERT INTO Books_Project (ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher) VALUES
('ISBN001', 'The Great Gatsby', 'Fiction', 9.99, 'Available', 'F. Scott Fitzgerald', 'Penguin Books'),
('ISBN002', 'To Kill a Mockingbird', 'Fiction', 8.99, 'Available', 'Harper Lee', 'Harper Perennial'),
('ISBN003', '1984', 'Science Fiction', 10.99, 'Unavailable', 'George Orwell', 'Signet Classics'),
('ISBN004', 'Pride and Prejudice', 'Romance', 7.99, 'Unavailable', 'Jane Austen', 'Wordsworth Classics'),
('ISBN005', 'The Hobbit', 'Fantasy', 11.99, 'Available', 'J.R.R. Tolkien', 'Mariner Books');

CREATE TABLE IssueStatus_Project
(
  Issue_Id INT PRIMARY KEY,
  Issued_cust INT,
  Issued_book_name VARCHAR(30),
  Issue_date DATE,
  Isbn_book VARCHAR(30),
  FOREIGN KEY (Issued_cust) REFERENCES Customer_Project(Customer_Id),
  FOREIGN KEY (Isbn_book) REFERENCES Books_Project(ISBN)
);

INSERT INTO IssueStatus_Project (Issue_Id, Issued_cust, Issued_book_name, Issue_date, Isbn_book) VALUES
(1, 1, 'The Great Gatsby', '2023-01-12', 'ISBN001'),
(2, 2, 'To Kill a Mockingbird', '2023-02-09', 'ISBN002'),
(3, 3, '1984', '2023-02-22', 'ISBN003'),
(4, 4, 'Pride and Prejudice', '2023-03-02', 'ISBN004'),
(5, 5, 'The Hobbit', '2023-04-18', 'ISBN005');

CREATE TABLE ReturnStatus_Project
(
  Return_Id INT PRIMARY KEY,
  Return_cust INT,
  Return_book_name VARCHAR(30),
  Return_date DATE,
  Isbn_book2 VARCHAR(30),
  FOREIGN KEY (Return_cust) REFERENCES Customer_Project(Customer_Id),
  FOREIGN KEY (Isbn_book2) REFERENCES Books_Project(ISBN)
);

INSERT INTO ReturnStatus_Project (Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2) VALUES
(1, 1, 'The Great Gatsby', '2023-01-29', 'ISBN001'),
(2, 2, 'To Kill a Mockingbird', '2023-03-01', 'ISBN002'),
(3, 3, '1984', '2023-03-20', 'ISBN003'),
(4, 4, 'Pride and Prejudice', '2023-03-28', 'ISBN004'),
(5, 5, 'The Hobbit', '2023-05-02', 'ISBN005');

SELECT * FROM Branch_Project;
SELECT * FROM Employee_Project;
SELECT * FROM Customer_Project;
SELECT * FROM Books_Project;
SELECT * FROM IssueStatus_Project;
SELECT * FROM ReturnStatus_Project;

/* 1. Retrieve the book title, category, and rental price of all available books. */

SELECT Book_title, Category, Rental_Price FROM Books_Project WHERE Status = 'Available';

/* 2. List the employee names and their respective salaries in descending order of salary. */

SELECT Emp_name, Salary FROM Employee_Project ORDER BY Salary DESC;

/* 3. Retrieve the book titles and the corresponding customers who have issued those books. */

SELECT i.Issued_book_name, c.Customer_name FROM IssueStatus_Project i
JOIN Customer_Project c ON i.Issued_cust = c.Customer_Id;

/* 4. Display the total count of books in each category. */

SELECT Category, COUNT(*) AS Total_count_of_books FROM Books_Project GROUP BY Category;

/* 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.12,000. */

SELECT Emp_name, Position, Salary FROM Employee_Project WHERE Salary > 12000.00;

/* 6. List the customer names who registered before 2022-01-01 and have not issued any books yet. */

SELECT Customer_name FROM Customer_Project
WHERE Reg_date < '2022-01-01' AND Customer_Id NOT IN (SELECT Issued_cust FROM IssueStatus_Project);

/* 7. Display the branch numbers and the total count of employees in each branch. */

SELECT b.Branch_no, COUNT(*) AS Total_Employees FROM Branch_Project b
JOIN Employee_Project e ON b.Manager_Id = e.Emp_Id GROUP BY b.Branch_no;

/* 8. Display the names of customers who have issued books in the month of June 2023. */

SELECT c.Customer_name FROM Customer_Project c
JOIN IssueStatus_Project i ON c.Customer_Id = i.Issued_cust WHERE i.Issue_date >= '2023-06-01' AND i.Issue_date < '2023-07-01';

/* 9. Retrieve book_title from book table containing 'history'. */

SELECT Book_title FROM Books_Project WHERE Category LIKE '%history%';

/* 10. Retrieve the branch numbers along with the count of employees for branches having more than 5 employees. */

SELECT b.Branch_no, COUNT(*) AS Total_Employees FROM Branch_Project b
JOIN Employee_Project e ON b.Manager_Id = e.Emp_Id GROUP BY b.Branch_no HAVING COUNT(*) > 5;
