
CREATE DATABASE	D08062021
GO

USE D08062021
GO

CREATE TABLE SANPHAM (
	MaSP CHAR(15) PRIMARY KEY, 
	TenSP NVARCHAR(30) NOT NULL, 
	MauSac NVARCHAR(30) NOT NULL, 
	SoLuong INT NOT NULL, 
	GiaBan MONEY NOT NULL
)

CREATE TABLE Nhap (
	SoHDN CHAR(15) PRIMARY KEY, 
	MaSP CHAR(15),
	SoLuongN INT NOT NULL, 
	NgayN DATE NOT NULL, 
	CONSTRAINT fk_nhap_sanPham FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)
)

CREATE TABLE Xuat (
	SoHDX CHAR (15) PRIMARY KEY, 
	MaSP CHAR(15), 
	SoLuongX INT NOT NULL, 
	NgayX DATE NOT NULL, 
	CONSTRAINT fk_XUAT_sanPham FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)
)

INSERT INTO SANPHAM VALUES 
('SP01', N'Sản phẩm 1', N'Đỏ', 10, 20000),
('SP02', N'Sản phẩm 2', N'Xanh', 20, 30000),
('SP03', N'Sản phẩm 3', N'Tím', 30, 40000)

INSERT INTO Nhap VALUES
('N01', 'SP01', 15, '2021-01-01'), 
('N02', 'SP01', 16, '2020-01-01'), 
('N03', 'SP02', 17, '2019-01-01')

INSERT INTO Xuat VALUES
('X01', 'SP01', 18, '2019-02-01'),
('X02', 'SP02', 19, '2019-02-02')

--thực thi
SELECT * FROM SANPHAM
SELECT * FROM Nhap
SELECT * FROM Xuat

-- cau 2
create function cau2(@tensp nvarchar(30))
returns money
as
begin
	declare @tong money
	set @tong = (select sum(soluongN * giaban)
				from nhap n
				inner join sanpham sp on n.MaSP = sp.MaSP
				where TenSP = @tensp)
	return @tong
end

select dbo.cau2(N'Sản phẩm 1')

-- cau 3
alter proc cau3
(
	@MaSP CHAR(15), 
	@TenSP NVARCHAR(30), 
	@MauSac NVARCHAR(30), 
	@SoLuong INT, 
	@GiaBan MONEY,
	@kq int output
)
as
begin
	if(exists(select * from sanpham where TenSP = @TenSP))
		set @kq = 1
	else
		set @kq = 0
		INSERT INTO SANPHAM VALUES(@maSP, @tenSP, @mauSac, @soLuong, @giaBan)

	return @kq
end

-- thuc thi

-- insert loi
declare @output int
exec cau3 'SP00', N'Sản phẩm 1', N'Đỏ', 10, 20000, @output output
select @output
select * from SANPHAM

-- insert thanh cong
declare @output int
exec cau3 'SP00', N'Sản phẩm 5', N'Đỏ', 10, 20000, @output output
select @output
select * from SANPHAM

-- CAU 4

alter trigger cau4
on xuat
for insert 
as
begin
	declare @soluongx int = (select soluongx from inserted)
	declare @soluong int = (select soluong from sanpham INNER JOIN inserted ON SANPHAM.MaSP = inserted.MaSP)
	if(@soluongx > @soluong) 
		begin
			raiserror('Loi', 16, 1)
			rollback transaction
		end
	else
		begin
			update sanpham
			set soluong = soluong - @soluongx
			where MaSP = (select MaSP from inserted)
		end
end

-- thuc thi loi
insert into xuat values
('X10', 'SP01', 18, '2019-02-01')

-- thuc thi thanh cong
insert into xuat values
('X10', 'SP01', 5, '2019-02-01')
select * from xuat
select * from sanpham
