use master
go

create database QLBanHang4_1
go
use QLBanHang4_1
go

DROP TABLE IF EXISTS dbo.HangSX
create table HangSX (
	MaHangSX nchar(10) primary key not null,
	TenHang nvarchar(20),
	DiaChi nvarchar(30),
	SoDienThoai nvarchar(20),
	Email nvarchar(30)
)

DROP TABLE IF EXISTS dbo.SanPham
create table SanPham (
	MaSP nchar(10) primary key not null,
	MaHangSX nchar(10),
	TenSP nchar (20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan Money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)
	constraint fk_sp_hangsx Foreign Key(MaHangSX)
	references HangSX(MaHangSX)
)

DROP TABLE IF EXISTS dbo.NhanVien
create table NhanVien (
	MaNV nchar(10) primary key not null,
	TenNV nvarchar(20),
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)

DROP TABLE IF EXISTS dbo.PNhap
create table PNhap (
	SoHDN nchar(10) primary key not null,
	NgayNhap date,
	MaNV nchar(10),
	constraint fk_pnhap_nv Foreign Key(MaNV) references NhanVien(MaNV)
)

DROP TABLE IF EXISTS dbo.Nhap
create table Nhap (
	SoHDN nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongN int,
	DonGiaN money,
	constraint pk_nhap Primary Key(SoHDN, MaSP),
	constraint fk_nhap_pnhap Foreign Key(SoHDN) references PNhap(SoHDN),
	constraint fk_nhap_sp Foreign Key(MaSP) references SanPham(MaSP)
)

DROP TABLE IF EXISTS dbo.PXuat
create table PXuat(
	SoHDX nchar(10) primary key not null,
	NgayXuat date,
	MaNV nchar(10),
	constraint fk_pxuat_nv Foreign Key(MaNV) references NhanVien(MaNV)
)

DROP TABLE IF EXISTS dbo.Xuat
create table Xuat (
	SoHDX nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongX int,
	constraint pk_xuat Primary Key(SoHDX, MaSP),
	constraint fk_xuat_pxuat Foreign Key(SoHDX) references PXuat(SoHDX),
	constraint fk_xuat_sp Foreign Key(MaSP) references SanPham(MaSP)
)


insert into HangSX values
('H01', 'Samsung', 'Korea', '011-08271717', 'ss@gmail.com.kr'),
('H02', 'OPPO', 'China', '081-08626262', 'oppo@gmail.com.cn'),
('H03', 'Vinfone', N'Vi?t Nam', '084-098262626', 'vf@gmail.com.vn')

insert into NhanVien values
('NV01', N'Nguy?n Th? Thu', N'N?', N'Hà N?i', '0982626521', 'thu@gmail.com', N'K? toán'),
('NV02', N'Lê Vãn Nam', N'Nam', N'B?c Ninh', '0972525252', 'nam@gmail.com', N'V?t tý'),
('NV03', N'Tr?n Hoà B?nh', N'Nam', N'Hà N?i', '0328388388', 'hb@gmail.com', N'K? toán')

insert into SanPham values
('SP1', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chi?c', N'Hàng c?n cao c?p'),
('SP2', 'H01', 'Galaxy Note 11', 50, N'Ð?', 19000000, N'Chi?c', N'Hàng cao c?p'),
('SP3', 'H02', 'F3 Lite', 200, N'Nâu', 3000000, N'Chi?c', N'Hàng ph? thông'),
('SP4', 'H03', 'Vjoy3', 200, N'Xám', 1500000, N'Chi?c', N'Hàng ph? thông'),
('SP5', 'H01', 'Galaxy V21', 500, N'Nâu', 8000000, N'Chi?c', N'Hàng c?n cao c?p')


insert into PNhap values
('N01', '2019-02-05', 'NV01'),
('N02', '2020-04-07', 'NV02'),
('N03', '2020-05-17', 'NV02'),
('N04', '2020-03-22', 'NV03'),
('N05', '2020-07-01', 'NV01')

insert into Nhap values
('N01', 'SP2', 10, 17000000),
('N02', 'SP1', 30, 6000000),
('N03', 'SP4', 20, 1200000),
('N04', 'SP1', 10, 6200000),
('N05', 'SP5', 20, 7000000)

insert into PXuat values
('X01', '2019-02-05', 'NV01'),
('X02', '2020-04-07', 'NV02'),
('X03', '2020-05-17', 'NV02'),
('X04', '2020-03-22', 'NV03'),
('X05', '2020-07-01', 'NV01')

insert into Xuat values
('X01', 'SP2', 5),
('X02', 'SP1', 3),
('X03', 'SP4', 1),
('X04', 'SP1', 2),
('X05', 'SP5', 1)

-- a. Hi?n th? thông tin các b?ng d? li?u trên
select * from HangSX
select * from NhanVien
select * from SanPham
select * from PNhap
select * from Nhap
select * from PXuat
select * from Xuat

-- b. Ðýa ra thông tin MaSP, TenSP, TenHang,SoLuong, MauSac, GiaBan, DonViTinh, MoTa c?a các s?n ph?m s?p x?p theo chi?u gi?m d?n giá bán.
select MaSP, TenSP, TenHang,SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham sp
inner join HangSX hsx on sp.MaHangSX = hsx.MaHangSX 
order by GiaBan DESC

-- c. Ðýa ra thông tin các s?n ph?m có trong c?a hàng do công ty có tên h?ng là Samsung s?n xu?t.
select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham sp
inner join HangSX hsx on sp.MaHangSX = hsx.MaHangSX 
where TenHang = 'Samsung'

-- d. Ðýa ra thông tin các nhân viên N? ? ph?ng ‘K? toán’.
select * 
from NhanVien
where GioiTinh = N'N?' AND TenPhong = N'K? Toán'

-- e.  Ðýa ra thông tin phi?u nh?p g?m: SoHDN, MaSP, TenSP, TenHang, SoLuongN, DonGiaN, TienNhap=SoLuongN*DonGiaN, 
-- MauSac, DonViTinh, NgayNhap, TenNV, TenPhong, s?p x?p theo chi?u tãng d?n c?a hóa ðõn nh?p
select pn.SoHDN, sp.MaSP, TenSP, TenHang, SoLuongN, DonGiaN, SoLuongN*DonGiaN As 'TienNhap', MauSac, DonViTinh, NgayNhap, TenNV, TenPhong
from PNhap pn
inner join nhap n on pn.SoHDN = n.SoHDN
inner join SanPham sp on n.MaSP = sp.MaSP
inner join HangSX hsx on sp.MaHangSX = sp.MaHangSX
inner join NhanVien nv on pn.MaNV = nv.MaNV
order by SoHDN asc


-- f. Ðýa ra thông tin phi?u xu?t g?m: SoHDX, MaSP, TenSP, TenHang, SoLuongX, GiaBan, tienxuat=SoLuongX*GiaBan, MauSac, 
-- DonViTinh, NgayXuat, TenNV, TenPhong trong tháng 06 nãm 2020, s?p x?p theo chi?u tãng d?n c?a SoHDX.
select px.SoHDX, sp.MaSP, TenSP, TenHang, SoLuongX, GiaBan, SoLuongX*GiaBan as 'TienXuat', MauSac, DonViTinh, NgayXuat, TenNV, TenPhong
from PXuat px
inner join xuat x on px.SoHDX = x.SoHDX
inner join SanPham sp on x.MaSP = sp.MaSP
inner join HangSX hsx on sp.MaHangSX = hsx.MaHangSX
inner join NhanVien nv on px.MaNV = nv.MaNV
where MONTH(NgayXuat) = 6 and YEAR(NgayXuat) = 2020
order by SoHDX asc
