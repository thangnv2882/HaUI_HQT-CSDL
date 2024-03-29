CREATE DATABASE QLKHO
GO

USE QLKHO
GO

CREATE TABLE ton(
	MaVT char(15) PRIMARY KEY NOT NULL,
	TenVT nvarchar(30) NULL,
	SoLuongVT int NULL
)

CREATE TABLE nhap(
	SoHDN int NOT NULL,
	MaVT char(15),
	SoLuongN int NULL,
	DonGiaN float NULL,
	NgayN datetime NULL,
	CONSTRAINT pk_nhap PRIMARY KEY (SoHDN, MaVT),
	CONSTRAINT fk_nhap_ton FOREIGN KEY(MaVT)
	REFERENCES ton(MaVT)
)

CREATE TABLE xuat(
	SoHDX int NOT NULL,
	MaVT char(15) NOT NULL,
	SoLuongX int NULL,
	DonGiaX float NULL,
	NgayX datetime NULL,
	CONSTRAINT pk_xuat PRIMARY KEY (SoHDX, MaVT),
	CONSTRAINT fk_xuat_ton FOREIGN KEY(MaVT)
	REFERENCES ton(MaVT)
)

insert into ton values
('vt1', N'Vật tư 1', 10),
('vt2', N'Vật tư 2', 20),
('vt3', N'Vật tư 3', 30),
('vt4', N'Vật tư 4', 40),
('vt5', N'Vật tư 5', 50)

insert into nhap values
(123, 'vt1', 11, 11.1, '2022/04/10'),
(234, 'vt2', 22, 22.2, '2022-04-11'),
(345, 'vt3', 33, 33.3, '2022-04-12')

insert into xuat values
(123, 'vt1', 111, 111.1, '2022-04-20'),
(234, 'vt2', 222, 222.2, '2022-04-21')

-- Bài 2 (2đ). Thống kê tiền bán theo mã vật tư gồm MaVT, TenVT, TienBan (TienBan=SoLuongX*DonGiaX)
CREATE VIEW BAI2
AS
SELECT XUAT.MaVT, TenVT, SUM(SoLuongX*DonGiaX) as 'TienBan'
FROM XUAT
INNER JOIN TON ON XUAT.MaVT = TON.MaVT
GROUP BY XUAT.MaVT, TenVT

SELECT * FROM BAI2

-- Bài 3 (2đ). Thống kê soluongxuat theo tên vattu
CREATE VIEW BAI3
AS
SELECT TON.TenVT, SUM(SoLuongX) as 'Tong SL Xuat'
FROM XUAT 
INNER JOIN TON ON XUAT.MaVT = TON.MaVT
GROUP BY TON.TenVT

SELECT * FROM BAI3

-- Bài 4 (2đ). Thống kê soluongnhap theo tên vật tư
CREATE VIEW BAI4
AS
SELECT TON.TenVT, SUM(SoLuongN) as 'Tong SL Nhap'
FROM NHAP 
INNER JOIN TON ON NHAP.MaVT = TON.MaVT
GROUP BY TON.TenVT

SELECT * FROM BAI4

-- Bài 5 (2đ). Đưa ra tổng soluong còn trong kho biết còn = nhap – xuất + tồn theo từng nhóm vật tư
CREATE VIEW BAI5
AS
SELECT TON.MaVT, TON.TenVT, SUM(SoLuongN)-SUM(SoLuongX) as 'Con'
FROM NHAP 
INNER JOIN XUAT ON NHAP.MaVT = XUAT.MaVT
INNER JOIN TON ON NHAP.MaVT = TON.MaVT
GROUP BY TON.MaVT, TON.TenVT

SELECT * FROM BAI5




