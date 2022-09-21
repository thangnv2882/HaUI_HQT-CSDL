

CREATE DATABASE QLKho1
GO

USE QLKho1
GO

CREATE TABLE Ton (
	MaVT CHAR(5) PRIMARY KEY,
	TenVT NVARCHAR(30),
	MauSac NVARCHAR(30),
	SoLuong INT,
	GiaBan MONEY,
	SoLuongT INT
)

CREATE TABLE Nhap (
	SoHDN CHAR(5),
	MaVT CHAR(5),
	SoLuongN INT,
	DonGiaN MONEY,
	NgayN DATE, 
	PRIMARY KEY(SoHDN, MaVT), 
	CONSTRAINT fk_nhap_ton FOREIGN KEY(MaVT) REFERENCES Ton (MaVT)
)

CREATE TABLE Xuat (
	SoHDX CHAR(5),
	MaVT CHAR(5),
	SoLuongX INT,
	NgayX DATE, 
	PRIMARY KEY(SoHDX, MaVT), 
	CONSTRAINT fk_xuat_ton FOREIGN KEY(MaVT) REFERENCES Ton (MaVT)
)

INSERT INTO Ton VALUES
('VT01', N'Vật tư 1', N'Xanh', 13, 120000, 4), 
('VT02', N'Vật tư 2', N'Đỏ', 14, 220000, 5), 
('VT03', N'Vật tư 3', N'Xanh', 15, 320000, 6), 
('VT04', N'Vật tư 4', N'Tím', 16, 420000, 7), 
('VT05', N'Vật tư 5', N'Vàng', 17, 520000, 8)

INSERT INTO Nhap VALUES 
('HDN01', 'VT01', 5, 120000, '2021-01-01'), 
('HDN02', 'VT02', 6, 220000, '2020-01-01'), 
('HDN03', 'VT03', 7, 320000, '2019-01-01') 

INSERT INTO Xuat VALUES
('HDX01', 'VT01', 1, '2021-01-02'),
('HDX02', 'VT02', 2, '2020-01-02'),
('HDX03', 'VT03', 3, '2019-01-02')

--Xem dữ liệu
SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Ton

-- cau 2
create function cau2(@ngayX )


-- cau 4
create trigger cau4
on nhap
for insert
as
begin 
	declare @mavt char(5) = (select mavt from inserted)
	if(not exists(select * from ton where mavt = @mavt)) 
		begin
			raiserror('Ma VT chua co trong bang ton', 16, 1)
			rollback transaction
		end
	else 
		begin
			declare @slmoi int = (select soluongn from inserted)
			update ton
			set soluong = soluong + @slmoi
			where MaVT = (select mavt from inserted)
		end
end

ALTER TABLE Nhap NOCHECK CONSTRAINT ALL
INSERT INTO Nhap VALUES ('HDN04', 'VT00', 5, 120000, '2021-01-01')
SELECT * FROM Nhap
SELECT * FROM Ton


ALTER TABLE Nhap NOCHECK CONSTRAINT ALL
INSERT INTO Nhap VALUES ('H111', 'VT01', 5, 120000, '2021-01-01')
SELECT * FROM Nhap
SELECT * FROM Ton