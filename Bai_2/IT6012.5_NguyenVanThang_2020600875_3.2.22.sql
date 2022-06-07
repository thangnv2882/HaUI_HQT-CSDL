use master
go

create database DeptEmp
on primary (
	name = 'deptemp_dat_3.2.22',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_2\deptemp_3.2.11.mdf',
	size=10mb,
	maxsize=50mb,
	filegrowth=10mb
)
log on (
	name = 'deptemp_log_3.2.22',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_2\deptemp_3.2.11.ldf',
	size=1mb,
	maxsize=5mb,
	filegrowth=20%
)
go
use DeptEmp

create table department(
	departmentno Integer not null primary key,
	departmentname char(25) not null,
	location char(25) not null
)

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

insert into department values
(10, 'Accounting', 'Melbourne'),
(20, 'Research', 'Adealide'),
(30, 'Sales', 'Sydney'),
(40, 'Operations', 'Perth')

insert into employee values
(1, 'John', 'Smith', 'Clerk', '1980-12-17', 800, null, 20),
(2, 'Peter', 'Allen', 'Salesman', '1981-02-20', 1600, 300, 30),
(3, 'Kate', 'Ward', 'Salesman', '1981-02-22', 1250, 500, 30),
(4, 'Jack', 'Jones', 'Manager', '1981-04-02', 2975, null, 20),
(5, 'Joe', 'Martin', 'Salesman', '1981-09-28', 1250, 1400, 30)


select * from department
select * from employee