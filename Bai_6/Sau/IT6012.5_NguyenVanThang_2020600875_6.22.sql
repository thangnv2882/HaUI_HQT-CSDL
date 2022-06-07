CREATE DATABASE QLKHO_6_22
GO

USE QLKHO_6_22
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
(123, 'vt1', 112, 111.1, '2022-04-20'),
(234, 'vt2', 222, 222.2, '2022-05-21')




select * from ton
select * from nhap
select * from xuat


-- Câu 2 (1đ). đưa ra tên vật tư số lượng tồn nhiều nhất
select TenVT 
from ton
where SoLuongT = ( Select MAX(SoLuongT) 
					from ton)
-- Câu 3 (1đ). đưa ra các vật tư có tổng số lượng xuất lớn hơn 100
select TenVT
from ton t
inner join xuat x on t.MaVT = x.MaVT
group by TenVT
having SUM(SoLuongX) > 100


-- Câu 4 (1đ). Tạo view đưa ra tháng xuất, năm xuất, tổng số lượng xuất thống kê theo tháng và năm xuất

create view vw_1
as
select MONTH(NgayX) as 'thang', YEAR(NgayX) as 'nam', SUM(SoLuongX) as 'Tong'
from xuat 
group by MONTH(NgayX), YEAR(NgayX)

select * from vw_1

-- Câu 5 (2đ). tạo view đưa ra mã vật tư. tên vật tư. số lượng nhập. số lượng xuất. đơn
-- giá N. đơn giá X. ngày nhập. Ngày xuất.
create view vw_cau5
as 
select n.MaVT, TenVT, SoLuongN, SoLuongX, DonGiaN, DonGiaX, NgayN, NgayX
from nhap n
inner join xuat x on n.MaVT = x.MaVT
inner join ton t on t.MaVT = n.MaVT

select * from vw_cau5

-- Câu 6 (2đ). Tạo view đưa ra mã vật tư. tên vật tư và tổng số lượng còn lại trong kho.
-- biết còn lại = SoluongN-SoLuongX+SoLuongT theo từng loại Vật tư trong năm 2015
create view vw_cau6
as
select t.MaVT, TenVT, SUM(SoLuongN) - SUM(SoLuongX) + SUM(SoLuongT) as 'So luong ton'
from ton t
inner join nhap n on t.MaVT = n.MaVT
inner join xuat x on t.MaVT = x.MaVT
where YEAR(NgayX) = 2022
group by t.MaVT, TenVT

select * from vw_cau6
