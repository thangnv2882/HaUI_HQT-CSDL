CREATE DATABASE QLNV1
GO

USE QLNV1
GO

DROP TABLE ton
DROP TABLE nhap
DROP TABLE xuat

select * from nhap

CREATE TABLE LOP (
	MaLop int PRIMARY KEY not null,
	TenLop nvarchar(20),
	Phong int
)
CREATE TABLE SV(
	MaSV int PRIMARY KEY not null,
	TenSV nvarchar(30),
	MaLop int,
	CONSTRAINT fk_sv_lop FOREIGN KEY(MaLop)
	REFERENCES LOP(MaLop)
)

insert into LOP values
(1, N'CD', 1),
(2, N'DH', 2),
(3, N'LT', 2),
(4, N'CH', 4)

insert into SV values
(1, N'A', 1),
(2, N'B', 2),
(3, N'C', 1),
(4, N'D', 3)

-- 1. Viết hàm thống kê xem mỗi lớp có bao nhiêu sinh viên với malop là tham số truyền vào từ bàn phím
CREATE FUNCTION thongke(@MaLop int)
returns int
as 
	begin
		declare @sl int
		select @sl = count(SV.MaSV)
		from SV, LOP
		WHERE SV.MaLop = LOP.MaLop AND LOP.MaLop = @MaLop
		GROUP BY LOP.TenLop
		return @sl
	end

SELECT DBO.THONGKE('2')

--2 Đưa ra danh sách sinh viên(masv,tensv) học lớp với tenlop được truyền vào từ bàn phím.
CREATE FUNCTION dssv(@tenlop nvarchar(30))
returns @thongke table (
					masv int,
					tensv nvarchar(30)
					)
as 
	begin
		insert into @thongke
		select masv, tensv
		from lop, sv
		where lop.malop = sv.malop and lop.tenlop = @tenlop
		return
	end

SELECT * FROM DBO.dssv('CD')

-- 3. Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp, với tên lớp
-- được nhập từ bàn phím. Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp, ngược lại nếu
-- lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó.

CREATE FUNCTION thongkesv(@tenlop nvarchar(30))
returns @thongke table (
					malop int,
					tenlop nvarchar(20),
					soluongsv int
					)
as 
	begin
	if(not exists(select malop from lop where tenlop=@tenlop))
		insert into @thongke
		select lop.malop,lop.tenlop,count(sv.masv)
		from lop,sv
		where lop.malop=sv.malop
		group by lop.malop,lop.tenlop
	else
		insert into @thongke
		select lop.malop, lop.tenlop, count(sv.masv)
		from lop, sv
		where lop.malop = sv.malop and lop.tenlop = @tenlop
		group by lop.malop, lop.tenlop
	return
	end
SELECT * FROM DBO.THONGKESV('CD')

--4. Đưa ra phòng học của tên sinh viên nhập từ bàn phím
CREATE FUNCTION phonghoc(@tensv nvarchar(30))
returns int
as 
	begin
		declare @phong int
		select @phong = Phong
		from SV, LOP
		WHERE SV.MaLop = LOP.MaLop AND TenSV = @tensv
		return @phong
	end
SELECT DBO.phonghoc('D')

--5. Đưa ra thống kê masv,tensv, tenlop với tham biến nhập từ bàn phím là phòng. Nếu phòng
-- không tồn tại thì đưa ra tất cả các sinh viên và các phòng. Neu phòng tồn tại thì đưa ra các
-- sinh vien của các lớp học phòng đó (Nhiều lớp học cùng phòng)

CREATE FUNCTION thongkesv5(@phong int)
returns @thongke table (
					masv int,
					tensv nvarchar(30),
					tenlop nvarchar(20)
					)
as 
	begin
	if(not exists(select phong from lop where phong=@phong))
		insert into @thongke
		select masv, tensv, lop.tenlop
		from lop,sv
		where lop.malop=sv.malop
	else
		insert into @thongke
		select masv, tensv, lop.tenlop
		from lop, sv
		where lop.malop = sv.malop and phong=@phong
	return
	end
SELECT * FROM DBO.THONGKESV5('1')

--6.  Viết hàm thống kê xem mỗi phòng có bao nhiêu lớp học. Nếu phòng không tồn tại trả
-- về giá trị 0.
CREATE FUNCTION phonghoc6(@phong int)
returns @thongke table (
					Phong int,
					SoLop int
					)
as 
	begin
	
	if(not exists(select phong from lop where phong=@phong))
		insert into @thongke values
		(0,0)
	else
		declare @sophong int
		insert into @thongke
		select Phong, count(MaLop) 
		from LOP
		WHERE Phong = @phong
		group by Phong
		return
	end

SELECT * FROM DBO.phonghoc6(4)
