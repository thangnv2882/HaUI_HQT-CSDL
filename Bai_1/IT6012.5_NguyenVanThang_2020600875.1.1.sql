create database qlnv
on primary (
	name = 'qlnv_dat',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_1\qlnv1.1.mdf',
	size=10mb,
	maxsize=50mb,
	filegrowth=10mb
)
log on (
	name = 'qlnv_datt',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_1\qlnv1.1.ldf',
	size=1mb,
	maxsize=5mb,
	filegrowth=20%
)
go
use qlnv
go

create table sv(
	MaSV nvarchar(15) primary key,
	TenSV nvarchar(30), 
	Que nvarchar(30)
)
create table mon(
	MaMH nvarchar(15) primary key,
	TenMH nvarchar(30),
	Sotc int default 3,
	constraint chk_sotc check(Sotc >= 2 and Sotc <= 5),
	constraint unique_tenmh unique(TenMH)
)
create table kq(
	MaSV nvarchar(15),
	MaMH nvarchar(15),
	Diem float,
	constraint chk_diem check(diem >=0 and diem <=10),
	constraint pk primary key(MaSV, MaMH),
	constraint fk_kq_sv foreign key(MaSV)
	references sv(MaSV),
	constraint fk_kq_mon foreign key(MaMH)
	references mon(MaMH)
)

insert into sv values
('sv1', N'Nguyễn Văn 1', N'Hà Nội'),
('sv2', N'Nguyễn Văn 2', N'Hà Nam'),
('sv3', N'Nguyễn Văn 3', N'Thái Bình')

insert into mon values
('mh1', N'Hệ QTCSDL', 2),
('mh2', N'CSDL', 3),
('mh3', N'Cấu trúc DLGT', 4)

insert into kq values
('sv1', 'mh1', 8.8),
('sv1', 'mh2', 9.2),
('sv2', 'mh1', 9.6),
('sv2', 'mh2', 7),
('sv3', 'mh2', 8.5),
('sv3', 'mh3', 9)


select * from sv
select * from mon
select * from kq











