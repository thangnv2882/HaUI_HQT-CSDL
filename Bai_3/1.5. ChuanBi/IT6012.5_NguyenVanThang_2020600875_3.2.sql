use master
go
create database ThucTap2
go
use ThucTap2
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
(111, 'Tran son', 10.4, 'MK1'),
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
(23456, 'Nguyen Van 2', 'MK6', 1999, 'Ha Nam'),
(34567, 'Nguyen Van 3', 'MK1', 2000, 'Bac Giang'),
(45678, 'Nguyen Van 4', 'MK1', 2003, 'Nam Dinh'),
(56789, 'Nguyen Van 5', 'MK2', 2001, 'Ca Mau'),
(67890, 'Nguyen Van 6', 'MK8', 2002, 'Ha Noi'),
(78901, 'Le van son', 'MK7', 2002, 'Ha Noi')


DROP TABLE IF EXISTS dbo.detai
create table detai (
	madt char(10) not null primary key,
	tendt char(30), 
	kinhphi int, 
	noithuctap char(30)
)
insert into detai values
('DT1', 'De tai 1', 123, 'Ha Noi'),
('DT2', 'De tai 2', 234, 'Ha Nam'),
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
(23456, 'DT2', 111, 0),
(45678, 'DT3', 111, 8.5)


-- 1. Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
select hd.madt, tendt
from huongdan hd
inner join detai dt on hd.madt = dt.madt
inner join giangvien gv on hd.magv = gv.magv
where hotengv like 'Tran son'

-- 2. Cho biết tên đề tài không có sinh viên nào thực tập
select tendt
from detai
where not exists(
select huongdan.madt
from huongdan
where huongdan.madt = detai.madt
)

--3. Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
select magv, hotengv, tenkhoa
from giangvien 
inner join khoa on giangvien.makhoa = khoa.makhoa
where magv in (select magv from huongdan 
				group by magv
				having count(masv) > 3)

-- 4. Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
select madt, tendt
from detai
where kinhphi in (select max(kinhphi) from detai)

-- 5. Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
select madt, tendt
from detai
where madt in (select madt from huongdan
				group by madt
				having count(masv) > 2)

-- 6. Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN'
select sinhvien.masv, hotensv, ketqua
from sinhvien
inner join huongdan on sinhvien.masv = huongdan.masv
where makhoa in (select makhoa from khoa
				where tenkhoa in ('DIA LY', 'QLTN'))


-- 7. Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
select tenkhoa, count(masv)
from khoa
inner join sinhvien on khoa.makhoa = sinhvien.makhoa
group by tenkhoa

-- 8. Cho biết thông tin về các sinh viên thực tập tại quê nhà
select * 
from sinhvien sv
inner join huongdan hd on sv.masv = hd.masv
inner join detai dt on hd.madt = dt.madt
where quequan = noithuctap 

-- 9. Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
select * 
from sinhvien
where masv not in (select masv from huongdan)

-- 10. Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
select masv, hotensv
from sinhvien
where masv in (select masv from huongdan
				where ketqua = 0)


select * from khoa
select * from giangvien
select * from sinhvien
select * from detai
select * from huongdan