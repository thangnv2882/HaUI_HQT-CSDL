use master
go

create database MarkManagement22
go

use MarkManagement22
go

DROP TABLE IF EXISTS dbo.students
create table students (
	studentid nvarchar(12) not null primary key,
	studentname nvarchar(25) not null,
	dateofbirth datetime not null,
	Email nvarchar(40),
	Phone nvarchar(12),
	class nvarchar(10)
)
insert into students values
('AV0807005', N'Mai Trung Hiếu', '1989-10-11', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
('AV0807006', N'Nguyễn Quý Hùng', '1988-12-02', 'quyhung@yahoo.com', '0955667787', 'AV2'),
('AV0807007', N'Đỗ Đắc Huỳnh', '1990-01-02', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
('AV0807009', N'An Đăng Khuê', '1986-03-06', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
('AV0807010', N'Nguyễn T. Tuyết Lan', '1989-07-12', 'tuyetlan@yahoo.com', '', 'AV2'),
('AV0807011', N'Đinh Phụng Long', '1990-12-02', 'phunglong@yahoo.com', '', 'AV1'),
('AV0807012', N'Nguyễn Tuấn Nam', '1990-03-02', 'tuannam@yahoo.com', '', 'AV1')



DROP TABLE IF EXISTS dbo.subjects
create table subjects (
	subjectid nvarchar(10) not null primary key,
	subjectname nvarchar(25) not null
)
insert into subjects values
('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page')


DROP TABLE IF EXISTS dbo.mark
create table mark (
	studentid nvarchar(12) not null,
	subjectid nvarchar(10) not null,
	date datetime,
	theory tinyint,
	practical tinyint,
	constraint pk_mark primary key(studentid, subjectid),
	constraint fk_mark_students foreign key(studentid)
	references students(studentid),
	constraint fk_mark_subjects foreign key(subjectid)
	references subjects(subjectid)
)
insert into mark values
('AV0807005', 'S001', '2008-05-06', 8, 25),
('AV0807006', 'S002', '2008-05-06', 16, 30),
('AV0807007', 'S001', '2008-05-06', 10, 25),
('AV0807009', 'S003', '2008-05-06', 7, 13),
('AV0807010', 'S003', '2008-05-06', 9, 16),
('AV0807011', 'S002', '2008-05-06', 8, 30),
('AV0807012', 'S001', '2008-05-06', 7, 31),
('AV0807005', 'S002', '2008-06-06', 12, 11),
('AV0807009', 'S002', '2008-06-06', 12, 11),
('AV0807010', 'S001', '2008-06-06', 7, 6)

select * from students
select * from subjects
select * from mark

-- 1. Hiển thị nội dung bảng students
select * from students

-- 2. Hiển thị nội dung danh sách sinh viên lớp AV1
select * 
from students
where class like 'AV1'

-- 3. Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
update students
set class= 'AV2'
where studentid like 'AV0807012'

-- 4. Tính tổng số sinh viên của từng lớp
select class, count(*) as 'Count SV'
from students
group by class

-- 5. Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
select *
from students
where class like 'AV2'
order by studentname asc

-- 6. Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
select * 
from students s
inner join mark m on s.studentid=m.studentid
where theory < 10 and Year(date) = 2008 
		and month(date) = 5 and day(date) = 6

-- 7. Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10)
select count(*) as 'Count'
from students s
inner join mark m on s.studentid=m.studentid
where theory < 10 and subjectid like 'S001'

-- 8. Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
select *
from students s
inner join mark m on s.studentid = m.studentid
where class like 'AV1' and date > '1/1/1980'

-- 9. Xoá sinh viên có mã AV0807011
delete 
from mark
where studentid like 'AV0807011'
delete 
from students
where studentid like 'AV0807011'

-- 10. Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
select s.studentid, studentname, subjectname, theory, practical, date
from students s
inner join mark m on s.studentid = m.studentid
inner join subjects sub on m.subjectid = sub.subjectid
where sub.subjectid = 'S001' and Year(date) = 2008 
		and month(date) = 5 and day(date) = 6










