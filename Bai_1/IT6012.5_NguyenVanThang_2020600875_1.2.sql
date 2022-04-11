create database qlbh
on primary (
	name = 'qlbh_dat_1.2',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_1\qlbh1.2.mdf',
	size=10mb,
	maxsize=50mb,
	filegrowth=10mb
)
log on (
	name = 'qlbh_datt_1.2',
	filename='D:\Fighting\Ky_4\3. HeQT-CSDL\Bai_1\qlbh1.2.ldf',
	size=1mb,
	maxsize=5mb,
	filegrowth=20%
)
go
use qlbh
go

create table CongTy(
	MaCT nvarchar(15) primary key,
	Tenct nvarchar(30), 
	TrangThai nvarchar(15),
	ThanhPho nvarchar(15)
)
create table SanPham(
	MaSP nvarchar(15) primary key,
	TenSP nvarchar(30),
	MauSac nvarchar(15) default N'Đỏ',
	Gia float,
	SoLuongCo int, 
	constraint unique_tensp unique(TenSP)
)
create table CungUng(
	MaCT nvarchar(15),
	MaSP nvarchar(15),
	SoLuongBan int,
	constraint chk_slban check(SoLuongBan > 0),
	constraint pk primary key(MaCT, MaSP),
	constraint fk_cu_ct foreign key(MaCT)
	references CongTy(MaCT),
	constraint fk_cu_sp foreign key(MaSP)
	references SanPham(MaSP)
)

insert into CongTy values
('ct1', N'Công ty 1', N'Tốt', N'Hà Nội'),
('ct2', N'Công ty 2', N'Khá', N'Hà Nam'),
('ct3', N'Công ty 3', N'Tốt', N'Thái Bình')

insert into SanPham values
('sp1', N'Kẹo', N'Đỏ', 123.4, 20),
('sp2', N'Gạo', N'Xanh', 12.3, 21),
('sp3', N'Bánh', N'Đen', 14.2, 15)

insert into CungUng values
('ct1', 'sp1', 8),
('ct1', 'sp2', 9),
('ct2', 'sp1', 9),
('ct2', 'sp2', 7),
('ct3', 'sp2', 8),
('ct3', 'sp3', 9)


select * from CongTy
select * from SanPham
select * from CungUng











