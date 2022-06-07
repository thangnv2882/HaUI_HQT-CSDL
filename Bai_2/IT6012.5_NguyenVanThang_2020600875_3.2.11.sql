use master
go

create database MarkManagement
on primary (
	name = 'mark_dat_3.2.11',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_2\mark_3.2.11.mdf',
	size=10mb,
	maxsize=50mb,
	filegrowth=10mb
)
log on (
	name = 'mark_log_3.2.11',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_2\mark_3.2.11.ldf',
	size=1mb,
	maxsize=5mb,
	filegrowth=20%
)
go

use MarkManagement
go

create table students (
	studentid nvarchar(12) not null primary key,
	studentname nvarchar(25) not null,
	dateofbirth datetime not null,
	Email nvarchar(40),
	Phone nvarchar(12),
	class nvarchar(10)
)

create table subjects (
	subjectid nvarchar(10) not null primary key,
	subjectname nvarchar(25) not null
)

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

insert into students values
('AV0807005', N'Mai Trung Hiếu', '1989-10-11', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
('AV0807006', N'Nguyễn Quý Hùng', '1988-12-02', 'quyhung@yahoo.com', '0955667787', 'AV2'),
('AV0807007', N'Đỗ Đắc Huỳnh', '1990-01-02', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
('AV0807009', N'An Đăng Khuê', '1986-03-06', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
('AV0807010', N'Nguyễn T. Tuyết Lan', '1989-07-12', 'tuyetlan@yahoo.com', '', 'AV2'),
('AV0807011', N'Đinh Phụng Long', '1990-12-02', 'phunglong@yahoo.com', '', 'AV1'),
('AV0807012', N'Nguyễn Tuấn Nam', '1990-03-02', 'tuannam@yahoo.com', '', 'AV1')


insert into subjects values
('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page')

insert into mark values
('AV0807005', 'S001', '2008-05-06', 8, 25),
('AV0807006', 'S002', '2008-05-06', 16, 30),
('AV0807007', 'S001', '2008-05-06', 10, 25),
('AV0807009', 'S003', '2008-05-06', 7, 13),
('AV0807010', 'S003', '2008-05-06', 9, 16),
('AV0807011', 'S002', '2008-05-06', 8, 30),
('AV0807012', 'S001', '2008-05-06', 7, 31),
('AV0807005', 'S002', '2008-05-06', 12, 11),
('AV0807010', 'S001', '2008-05-06', 7, 6)

select * from students
select * from subjects
select * from mark