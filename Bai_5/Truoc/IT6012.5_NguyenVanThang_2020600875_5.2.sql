use TRUONGHOC
go

create table HOCSINH
(
	MAHS CHAR(50),
	TEN NVARCHAR(30),
	NAM BIT, --Colum giới tính Nam: 1- đúng, 0- sai
	NGAYSINH DATETIME,
	DIACHI VARCHAR(20),
	DIEMTB FLOAT
)

create table GIAOVIEN 
(
	MAGV CHAR(50),
	TEN NVARCHAR(30),
	NAM BIT, --Colum giới tính Nam: 1- đúng, 0- sai
	NGAYSINH DATETIME,
	DIACHI VARCHAR(20),
	LUONG MONEY
)


create table LOPHOC
(
	MALOP CHAR(5),
	TENLOP NVARCHAR(30),
	SOLUONG INT
)

-- Them du lieu vao table
INSERT dbo.HOCSINH VALUES
('hs2', N'Nguyen Van B', 1, '2002-08-28', 'Dan Phuong', 9.9),
('hs3', N'Nguyen Thi C', 1, '2002-07-28', 'Dan Phuong', 9.3),
('hs4', N'Nguyen Van D', 1, '2002-06-28', 'Dan Phuong', 9.1)

-- Xoa du lieu
DELETE dbo.HOCSINH WHERE DIEMTB = 9.9

-- Cap nhat du lieu
UPDATE dbo.HOCSINH SET MAHS = 'hs11' WHERE MAHS = 'hs1'

