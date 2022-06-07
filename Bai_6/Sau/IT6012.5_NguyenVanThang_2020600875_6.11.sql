CREATE DATABASE QLKHO_6_11
GO

USE QLKHO_6_11
GO

DROP TABLE nhap
DROP TABLE xuat
DROP TABLE ton


CREATE TABLE ton(
	MaVT char(15) PRIMARY KEY NOT NULL,
	TenVT nvarchar(30) NULL,
	SoLuongT int NULL
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
(123, 'vt1', 11, 11.1, '2022-04-10'),
(234, 'vt2', 22, 22.2, '2022-04-11'),
(345, 'vt3', 33, 33.3, '2022-04-12')

insert into xuat values
(123, 'vt1', 111, 111.1, '2022-04-20'),
(234, 'vt2', 222, 222.2, '2022-05-21')



-- d. Xóa các vật tư có DonGiaX < DonGiaN
ALTER TABLE nhap nocheck CONSTRAINT all
ALTER TABLE xuat nocheck CONSTRAINT all

DELETE 
FROM ton
FROM nhap, xuat
WHERE ton.MaVT = nhap.MaVT
	AND ton.MaVT = xuat.MaVT
	AND DonGiaX < DonGiaN

ALTER TABLE nhap check CONSTRAINT all
ALTER TABLE xuat check CONSTRAINT all

-- e. Cập nhật NgayX = NgayN nếu NgayX < NgayN của các mặt hàng có MaVT giống nhau

UPDATE xuat SET NgayX = NgayN
FROM nhap
WHERE nhap.MaVT = xuat.MaVT AND NgayX > NgayN

select * from ton
select * from nhap
select * from xuat

