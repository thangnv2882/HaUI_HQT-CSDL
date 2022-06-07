use master
go

create database QLBanHang6_2
go
use QLBanHang6_2
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

-- a (1đ). Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020,
-- gồm: SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
create view vw_cau1
as
select n.SoHDN, n.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
from Nhap n
inner join PNhap pn on n.SoHDN = pn.SoHDN
inner join SanPham sp on sp.MaSP = n.MaSP
inner join NhanVien nv on pn.MaNV = nv.MaNV
inner join HangSX hsx on hsx.MaHangSX = sp.MaHangSX
where TenHang = 'Samsung' and YEAR(NgayNhap) = 2020

select * from vw_cau1

-- b (1đ). Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng
--Samsung
create view vw_cau2
as
select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham 
inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
where TenHang = 'Samsung' And GiaBan Between 100000 And 500000

select * from vw_cau2

-- c (1đ). Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung
create view vw_cau3
as
select SUM(SoLuongN*DonGiaN) As N'Tổng tiền nhập'
from Nhap Inner join SanPham on Nhap.MaSP = SanPham.MaSP
Inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
Inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
where YEAR(NgayNhap)=2020 and TenHang = 'Samsung'

select * from vw_cau3

-- d (1đ). Thống kê tổng tiền đã xuất trong ngày 14/06/2020
create view vw_Cau4
as
Select Sum(SoLuongX*GiaBan) As N'Tổng tiền xuất'
From Xuat Inner join SanPham on Xuat.MaSP = SanPham.MaSP
Inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
Where NgayXuat = '2020-06-14'

select * from vw_cau4

-- e (1đ). Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020.
Create view vw_Cau5
as
Select Nhap.SoHDN,NgayNhap
From Nhap Inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
Where Year(NgayNhap)=2020 And SoLuongN*DonGiaN =
(Select Max(SoLuongN*DonGiaN)
From Nhap Inner join PNhap on
Nhap.SoHDN=PNhap.SoHDN
Where Year(NgayNhap)=2020
)
select * from vw_cau3

-- f (1đ). Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
Create view vw_Cau6
as
Select HangSX.MaHangSX, TenHang, Count(*) As N'Số lượng sp'
From SanPham Inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
Group by HangSX.MaHangSX, TenHang

select * from vw_cau3

-- g (1đ). Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020
Create view vw_Cau7
as
Select SanPham.MaSP,TenSP, sum(SoLuongN*DonGiaN) As N'Tổng tiền nhập'
From Nhap Inner join SanPham on Nhap.MaSP = SanPham.MaSP
Inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
Where Year(NgayNhap)=2020
Group by SanPham.MaSP,TenSP

select * from vw_cau3

-- h (1đ). Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung
Create view vw_Cau8
as
Select SanPham.MaSP,TenSP,sum(SoLuongX) As N'Tổng xuất'
From Xuat Inner join SanPham on Xuat.MaSP = SanPham.MaSP
Inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
Inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
Where Year(NgayXuat)=2018 And TenHang = 'Samsung'
Group by SanPham.MaSP,TenSP
Having sum(SoLuongX) >=10000

select * from vw_cau3


-- i (1đ). Thống kê số lượng nhân viên Nam của mỗi phòng ban.
create view vw_cau9
as
select TenPhong, COUNT(manv) as 'So nhan vien nam'
from NhanVien
where GioiTinh = 'Nam'
group by TenPhong

select * from vw_cau9

-- j (1đ). Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018
create view vw_cau10
as
select TenHang, SUM(SoLuongN) as 'So luong nhap'
from HangSX hsx
inner join SanPham sp on hsx.MaHangSX = sp.MaHangSX
inner join Nhap n on sp.MaSP = n.MaSP
group by TenHang

select * from vw_cau10

-- k (1đ). Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
create view vw_cau11
as
select tennv, sum(giaban*soluongx) as 'Tong tin xuat'
from NhanVien nv
inner join PXuat px on nv.MaNV = px.MaNV
inner join Xuat x on px.SoHDX = x.SoHDX
inner join SanPham sp on sp.MaSP = x.MaSP
where YEAR(NgayXuat) = 2018
group by TenNV

select * from vw_cau11








