CREATE DATABASE D09062021_7h45
GO

USE D09062021_7h45
GO

CREATE TABLE Khoa (
	MaKhoa CHAR(15) PRIMARY KEY, 
	TenKhoa NVARCHAR(30) NOT NULL, 
	DiaChi NVARCHAR(30) NOT NULL, 
	SoDT CHAR(15) NOT NULL, 
	Email CHAR(30) NOT NULL
)

GO
CREATE TABLE Lop (
	MaLop CHAR(15) PRIMARY KEY, 
	TenLop NVARCHAR(30) NOT NULL,
	SiSo INT NOT NULL,
	MaKhoa CHAR(15), 
	CONSTRAINT fk_lop_khoa FOREIGN KEY(MaKhoa) REFERENCES Khoa(MaKhoa)
)

GO
CREATE TABLE SinhVien (
	MaSV CHAR(15) PRIMARY KEY, 
	HoTen NVARCHAR(30) NOT NULL,
	NgaySinh DATE  NOT NULL,
	GioiTinh NVARCHAR(15) NOT NULL,
	MaLop CHAR(15), 
	CONSTRAINT fk_sinhVien_lop FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
)

GO
INSERT INTO Khoa (MaKhoa, TenKhoa, DiaChi, SoDT, Email)
VALUES('K01', N'CNTT', N'Cơ Sở Minh Khai', '0123456789', 'khoacntt@mail.com')
INSERT INTO Khoa (MaKhoa, TenKhoa, DiaChi, SoDT, Email)
VALUES('K02', N'Điện Tử', N'Cơ Sở Tây Tựu', '0123456788', 'khoadientu@mail.com')
INSERT INTO Khoa (MaKhoa, TenKhoa, DiaChi, SoDT, Email)
VALUES('K03', N'Kế toán', N'Cơ Sở Minh Khai', '0123456787', 'khoaketoan@mail.com')

GO
INSERT INTO Lop (MaLop, TenLop, SiSo, MaKhoa)
VALUES ('L01', N'CNTT05', 81, 'K01')
INSERT INTO Lop (MaLop, TenLop, SiSo, MaKhoa)
VALUES ('L02', N'DienTu01', 60, 'K02')
INSERT INTO Lop (MaLop, TenLop, SiSo, MaKhoa)
VALUES ('L03', N'KeToan02', 65, 'K03')

GO
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
VALUES ('SV01', N'Đào Thu Phương', '2000-01-01', N'Nữ', 'L01')
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
VALUES ('SV02', N'Nguyễn Đinh Huân', '2001-01-01', N'Nam', 'L01')
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
VALUES ('SV03', N'Nguyễn Thị A', '2002-01-01', N'Nữ', 'L02')
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
VALUES ('SV04', N'Trần Văn A', '2003-01-01', N'Nam', 'L02')
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
VALUES ('SV05', N'Nguyễn Thị B', '2004-01-01', N'Nữ', 'L03')

-- cau 2
create function cau2(@tenkhoa nvarchar(30))
returns @bang table 
(
	masv char(15) primary key,
	hoten nvarchar(30),
	tuoi int
)
as
begin
	insert into @bang 
	select masv, hoten, year(getdate()) - year(ngaysinh) as 'Tuoi'
	from sinhvien sv
	inner join lop l on sv.MaLop = l.MaLop
	inner join khoa k on l.MaKhoa = k.MaKhoa
	where TenKhoa = @tenkhoa

	return
end
-- thuc thi
select * from cau2(N'cntt')

-- cau 3
create proc cau3
(
	@tutuoi int,
	@dentuoi int,
	@tenlop nvarchar(30)
)
as
begin
	select masv, hoten, ngaysinh, tenlop, tenkhoa, year(getdate()) - year(ngaysinh) as 'Tuoi'
	from sinhvien sv
	inner join lop l on sv.malop = l.MaLop
	inner join khoa k on k.MaKhoa = l.MaKhoa
	where year(getdate()) - year(ngaysinh) between @tutuoi and @dentuoi and TenLop = @tenlop
end
	
exec cau3 1, 19, N'DienTu01'

-- cau 4
alter trigger cau4
on sinhvien 
for insert
as
begin
	declare @malop nvarchar(30) = (select malop from inserted)
	declare @sisocu int = (select siso from lop where lop.malop = @malop)
	if(@sisocu > 80) 
		begin
			raiserror('Si so lop lon hon 80 sinh vien', 16, 1)
			rollback transaction
		end
	else 
		begin
			update lop
			set siso = @sisocu + 1
			where lop.MaLop = @malop
		end
end

-- thuc thi that bai
insert into sinhvien values 
('SV100', N'Đào Thu Phương', '2000-01-01', N'Nữ', 'L01')

-- thuc thi thanh cong
insert into sinhvien values 
('SV101', N'Đào Thu Phươngg', '2000-01-01', N'Nữg', 'L02')

select * from sinhvien
select * from lop