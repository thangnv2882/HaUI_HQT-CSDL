use master
go
create database ThucTap
go
use ThucTap
go

DROP TABLE IF EXISTS dbo.khoa
create table khoa (
	makhoa char(10) not null primary key,
	tenkhoa char(30),
	dienthoai char(10)
)
insert into khoa values
('MK1', 'Khoa 1', '011111'),
('MK2', 'Khoa 2', '022222'),
('MK3', 'Khoa 3', '033333'),
('MK4', 'Khoa 4', '044444'),
('MK5', 'Khoa 5', '055555'),
('MK6', 'DIA LY', '055555'),
('MK7', 'QLTN', '055555'),
('MK8', 'CONG NGHE SINH HOC', '09283738'),
('MK9', 'CONG NGHE SINH HOC', '09283738')


DROP TABLE IF EXISTS dbo.giangvien
create table giangvien(
	magv int not null primary key,
	hotengv char (30),
	luong decimal(5,2),
	makhoa char(10),
	constraint fk_giangvien_khoa foreign key(makhoa)
	references khoa(makhoa)
)
insert into giangvien values
(111, 'Nguyen Thi 1', 10.4, 'MK1'),
(222, 'Nguyen Thi 2', 9.4, 'MK2'),
(333, 'Nguyen Thi 3', 5.4, 'MK3'),
(444, 'Nguyen Thi 4', 15.1, 'MK1'),
(555, 'Nguyen Thi 5', 9.7, 'MK2'),
(666, 'Nguyen Thi 6', 11.7, 'MK6'),
(777, 'Nguyen Thi 7', 9.9, 'MK7'),
(888, 'Nguyen Thi 8', 9.5, 'MK8')

DROP TABLE IF EXISTS dbo.sinhvien
create table sinhvien(
	masv int not null primary key,
	hotensv char(30),
	makhoa char(10), 
	namsinh int,
	quequan char(30),
	constraint fk_sinhvien_khoa foreign key(makhoa)
	references khoa(makhoa)
)
insert into sinhvien values
(12345, 'Nguyen Van 1', 'MK1', 2002, 'Ha Noi'),
(23456, 'Nguyen Van 2', 'MK2', 1999, 'Ha Nam'),
(34567, 'Nguyen Van 3', 'MK1', 2000, 'Bac Giang'),
(45678, 'Nguyen Van 4', 'MK1', 2003, 'Nam Dinh'),
(56789, 'Nguyen Van 5', 'MK2', 2001, 'Ca Mau'),
(67890, 'Nguyen Van 6', 'MK8', 2002, 'Ha Noi'),
(78901, 'Le van son', 'MK3', 2002, 'Ha Noi')


DROP TABLE IF EXISTS dbo.detai
create table detai (
	madt char(10) not null primary key,
	tendt char(30), 
	kinhphi int, 
	noithuctap char(30)
)
insert into detai values
('DT1', 'De tai 1', 123, 'Cong ty 1'),
('DT2', 'De tai 2', 234, 'Cong ty 5'),
('DT3', 'De tai 3', 345, 'Cong ty 2'),
('DT4', 'De tai 4', 456, 'Cong ty 2'),
('DT5', 'De tai 5', 567, 'Cong ty 1')


DROP TABLE IF EXISTS dbo.huongdan
create table huongdan (
	masv int not null primary key,
	madt char(10), 
	magv int, 
	ketqua decimal(5,2),
	constraint fk_huongdan_detai foreign key(madt)
	references detai(madt)
)
insert into huongdan values
(12345, 'DT1', 333, 9.5),
(23456, 'DT2', 111, 9.2),
(45678, 'DT3', 111, 8.5)


-- 1. Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên
select magv, hotengv, tenkhoa 
from giangvien
inner join khoa on giangvien.makhoa = khoa.makhoa

-- 2. Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
select magv, hotengv, tenkhoa 
from giangvien
inner join khoa on giangvien.makhoa = khoa.makhoa
where tenkhoa in ('DIA LY', 'QLTN')

-- 3. Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
select COUNT(masv) AS 'Count'
from sinhvien
inner join khoa on sinhvien.makhoa = khoa.makhoa
where tenkhoa like 'CONG NGHE SINH HOC'

-- 4. Đưa ra danh sách gồm mã số, họ tênvà tuổi của các sinh viên khoa ‘TOAN’
select masv, hotensv, DATENAME(YEAR, GETDATE())-namsinh AS 'Tuoi'
from sinhvien

-- 5. Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
select count(magv) as 'Count'
from giangvien
inner join khoa on giangvien.makhoa = khoa.makhoa
where tenkhoa like 'CONG NGHE SINH HOC'

-- 6. Cho biết thông tin về sinh viên không tham gia thực tập
select *
from sinhvien
where masv not in (select masv from huongdan)

-- 7. Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
select khoa.makhoa, tenkhoa, count(khoa.makhoa) as 'Count'
from giangvien
inner join khoa on giangvien.makhoa = khoa.makhoa
group by khoa.makhoa, khoa.tenkhoa

-- 8. Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
select dienthoai 
from khoa 
inner join sinhvien on khoa.makhoa = sinhvien.makhoa
where hotensv like 'Le van son'














