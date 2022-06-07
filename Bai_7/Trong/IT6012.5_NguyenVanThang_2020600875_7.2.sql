use master
go

create database QLBanHang7_2
go
use QLBanHang7_2
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
('H03', 'Vinfone', N'Việt Nam', '084-098262626', 'vf@gmail.com.vn')

insert into NhanVien values
('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kê toán'),
('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư'),
('NV03', N'Trần Hoà Bình', N'Nam', N'Hà Nội', '0328388388', 'hb@gmail.com', N'Kế toán')

insert into SanPham values
('SP1', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chi?c', N'Hàng c?n cao c?p'),
('SP2', 'H01', 'Galaxy Note 11', 50, N'Đ?', 19000000, N'Chi?c', N'Hàng cao c?p'),
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

-- Bài 1. Scalar valued function
-- a. Hãy xây dựng hàm Đưa ra tên HangSX khi nhập vào MaSP từ bàn phím
create function cau1a (@masp nchar(10))
returns nvarchar(20) 
as 
begin
	declare @tenhang nvarchar(20)
	Set @tenhang = (Select TenHang From HangSX 
				inner join SanPham on HangSX.MaHangSX = SanPham.MaHangSX
				where MaSP = @MaSP)
	Return @tenhang
end

select dbo.cau1a('SP2')

-- b. Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến năm nhập y, với x, y được
-- nhập vào từ bàn phím.
create function cau1b(@x int, @y int)
returns int
as 
begin
	declare @tongTien int
	Set @tongTien = (select SUM(SoLuongN*DonGiaN)
					from Nhap n
					inner join PNhap pn on n.SoHDN = pn.SoHDN
					where YEAR(NgayNhap) Between @x and @y)
	Return @tongTien
end

select dbo.cau1b(2017,2022)

create function cau1c(@x nchar(20), @y int)
returns int
as 
begin
	declare @tongNhap int
	Set @tongNhap = (select SUM(SoLuongN)
					from Nhap n
					inner join PNhap pn on n.SoHDN = pn.SoHDN
					inner join SanPham sp on n.MaSP = sp.MaSP
					where TenSP = @x and YEAR(NgayNhap) = @y)
	declare @tongXuat int
	Set @tongXuat = (select SUM(SoLuongX)
					from Xuat x
					inner join PXuat px on x.SoHDX = px.SoHDX
					inner join SanPham sp on x.MaSP = sp.MaSP
					where TenSP = @x and YEAR(NgayXuat) = @y)
	declare @thayDoi int
	set @thayDoi = @tongNhap - @tongXuat

	Return @thayDoi
end

select dbo.cau1c('Galaxy Note 11', 2019)

-- d. Hãy xây dựng hàm Đưa ra tổng giá trị nhập từ ngày nhập x đến ngày nhập y, với x, y
-- được nhập vào từ bàn phím.
create function cau1d(@x date , @y date)
returns int
as 
begin
	declare @tongNhap int
	Set @tongNhap = (select SUM(SoLuongN*DonGiaN)
					from Nhap n
					inner join PNhap pn on n.SoHDN = pn.SoHDN
					where NgayNhap between @x and @y)
	Return @tongNhap
end

select dbo.cau1d('2019-02-05', '2020-07-01')

-- Bài 2. Table Valued Function
-- a. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím.
create function cau2a(@hangsx nvarchar(20))
returns @bang Table (
	MaSP nchar(10),
	MaHangSX nchar(10),
	TenSP nchar (20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan Money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)
)
as
begin
insert into @bang
select MaSP, sp.MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham sp
inner join HangSX hsx on sp.MaHangSX = hsx.MaHangSX
where TenHang = @hangsx
return
end

select * from cau2a('Samsung')

-- b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập
-- từ ngày x đến ngày y, với x,y nhập từ bàn phím.
create function cau2b(@x date, @y date)
returns @bang Table (
	MaHangSX nchar(10),
	TenHang nvarchar(20),
	MaSP nchar(10),
	TenSP nchar (20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan Money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)
)
as
begin
insert into @bang
select sp.MaHangSX, TenHang, sp.MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham sp
inner join HangSX hsx on sp.MaHangSX = hsx.MaHangSX
inner join Nhap n on sp.MaSP = n.MaSP
inner join PNhap pn on n.SoHDN = pn.SoHDN
where NgayNhap between @x and @y
return
end

select * from cau2b('2019-02-05', '2020-07-01')

-- c. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn,
-- nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong = 0, ngược lại lựa chọn
-- =1 thì Đưa ra danh sách các sản phẩm có SoLuong >0.
create function cau2c(@tenHang nvarchar(20), @flag int)
returns @bang Table (
	MaSP nchar(10),
	TenSP nchar (20),
	TenHang nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan Money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)
)
as
begin
	if(@flag = 0)
		insert into @bang
		select sp.MaSP, TenSP, TenHang, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
		from SanPham sp
		inner join HangSX hsx on sp.MaHangSX = hsx.MaHangSX
		where TenHang = @tenHang and SoLuong = 0	
	else 
		if(@flag = 1)
			insert into @bang
			select sp.MaSP, TenSP, TenHang, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
			from SanPham sp
			inner join HangSX hsx on sp.MaHangSX = hsx.MaHangSX
			where TenHang = @tenHang and SoLuong > 0	
return
end

select * from cau2c('Samsung', 1)

-- d. Hãy xây dựng hàm Đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.
create function cau2d(@tenPhong nvarchar(30))
returns @bang Table (
	MaNV nchar(10) primary key not null,
	TenNV nvarchar(20),
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)
as
begin
insert into @bang
select MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong
from NhanVien nv
where TenPhong = @tenPhong
return
end

select * from cau2d(N'Vật Tư')




