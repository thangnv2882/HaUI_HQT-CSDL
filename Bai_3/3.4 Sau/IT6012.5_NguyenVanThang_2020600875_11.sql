use master
go

create database DeptEmp1
go

use DeptEmp1

DROP TABLE IF EXISTS dbo.department
create table department(
	departmentno Integer not null primary key,
	departmentname char(25) not null,
	location char(25) not null
)
insert into department values
(10, 'Accounting', 'Melbourne'),
(20, 'Research', 'Adealide'),
(30, 'Sales', 'Sydney'),
(40, 'Operations', 'Perth')

DROP TABLE IF EXISTS dbo.employee
create table employee(
	empno integer not null primary key,
	fname varchar(15) not null,
	lname varchar(15) not null,
	job varchar(25) not null,
	hiredate datetime not null,
	salary numeric not null,
	commision numeric,
	departmentno Integer,
	constraint fk_employee_department foreign key(departmentno)
	references department(departmentno)
)
insert into employee values
(1, 'John', 'Smith', 'Clerk', '1980-12-17', 800, null, 20),
(2, 'Peter', 'Allen', 'Salesman', '1981-02-20', 1600, 300, 30),
(3, 'Kate', 'Ward', 'Salesman', '1981-02-22', 1250, 500, 30),
(4, 'Jack', 'Jones', 'Manager', '1981-04-02', 2975, null, 20),
(5, 'Joe', 'Martin', 'Salesman', '1981-09-28', 1250, 1400, 30)


-- 1. Hiển thị nội dung bảng department
select * from department

-- 2. Hiển thị nội dung bảng employee
select * from employee

-- 3. Hiển thị employee number, employee first name và employee last name từ bảng Employee mà employee first name có tên là ‘Kate’.
select empno, fname, lname
from employee
where fname like 'Kate'

-- 4. Hiển thị ghép 2 trường Fname và Lname thành Full Name, Salary, 10%Salary (tăng 10% so với lương ban đầu).
select CONCAT(fname, ' ', lname) as 'Full Name', salary, salary+salary/10 as '10% salary'
from employee

-- 5. Hiển thị Fname, Lname, HireDate cho tất cả các Employee có HireDate là năm 1981 và sắp xếp theo thứ tự tăng dần của Lname.
select fname, lname, hiredate
from employee
where year(hiredate) = 1981

-- 6. Hiển thị trung bình(average), lớn nhất (max) và nhỏ nhất(min) của lương(salary) cho từng phòng ban trong bảng Employee.
select departmentno, AVG(salary) as 'Average', max(salary) as 'Max', min(salary) as 'Min'
from employee
group by departmentno

-- 7. Hiển thị DepartmentNo và số người có trong từng phòng ban có trong bảng Employee.
select departmentno, count(*) as 'Count'
from employee
group by departmentno

-- 8. Hiển thị DepartmentNo, DepartmentName, FullName (Fname và Lname), Job, Salary trong bảng Department và bảng Employee.
select d.departmentno, departmentname, concat(fname, ' ', lname), job, salary
from department d
inner join employee e on d.departmentno = e.departmentno 

-- 9. Hiển thị DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee.
select d.departmentno, departmentname, location, count(*) as 'Count'
from department d
inner join employee e on d.departmentno = e.departmentno 
group by d.departmentno, departmentname, location

-- 10. Hiển thị tất cả DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee
select d.departmentno, departmentname, location, count(*) as 'Count'
from department d
inner join employee e on d.departmentno = e.departmentno 
group by d.departmentno, departmentname, location
