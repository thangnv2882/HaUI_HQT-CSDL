CREATE DATABASE QLSach2
GO

USE QLSach2
GO

CREATE TABLE TacGia (
	MaTG CHAR(15) PRIMARY KEY, 
	TenTG NVARCHAR(30), 
	SoLuongCo INT
)

CREATE TABLE NhaXB (
	MaNXB CHAR(15) PRIMARY KEY, 
	TenNXB NVARCHAR(30), 
	SoLuongCo INT
)

CREATE TABLE Sach (
	MaSach CHAR(15) PRIMARY KEY, 
	TenSach NVARCHAR(30), 
	MaNXB CHAR(15), 
	MaTG CHAR(15), 
	NamXB INT, 
	SoLuong INT, 
	DonGia MONEY, 
	CONSTRAINT fk_nxb FOREIGN KEY (MaNXB) REFERENCES NhaXB(MaNXB),
	CONSTRAINT fk_tg FOREIGN KEY (MaTG) REFERENCES TacGia(MaTG)
)

INSERT INTO TacGia VALUES
('TG01', N'Tác giả 1', 20),
('TG02', N'Tác giả  2', 30),
('TG03', N'Tác giả  3 ', 40)

INSERT INTO NhaXB VALUES
('NXB01', N'Nhi Đồng', 10),
('NXB02', N'Thiếu niên', 15),
('NXB03', N'Tin tức', 20)

INSERT INTO Sach VALUES
('S01', N'Sách 01', 'NXB01', 'TG01', 2020, 11, 20000),
('S02', N'Sách 02', 'NXB02', 'TG01', 2019, 10, 21000),
('S03', N'Sách 03', 'NXB02', 'TG02', 2018, 9, 22000),
('S04', N'Sách 04', 'NXB02', 'TG02', 2021, 8, 23000),
('S05', N'Sách 05', 'NXB03', 'TG03', 2020, 7, 24000)

SELECT * FROM TacGia
SELECT * FROM NhaXB
SELECT * FROM Sach

-- CAU 2
alter proc insSach(
	@masach char(15),
	@tensach nvarchar(30), 
	@tennxb nvarchar(30),
	@matg char(15),
	@namxb int,
	@soluong int,
	@dongia money
)
as
begin
	if(not exists(select * from nhaxb where tennxb = @tennxb))
		begin
			print('Khong co nha xb')
			return
		end
	else
		declare @manxb char(15)
		set @manxb = (select manxb from nhaxb where tennxb = @tennxb)
		insert into sach values
		(@masach, @tensach, @manxb, @matg, @namxb, @soluong, @dongia)
end

-- thuc thi khong thanh cong
exec insSach 'S10', N'Sách 10', N'Nhi Đồnggg', 'TG01', 2020, 11, 20000

-- thuc thi thanh cong
exec insSach 'S10', N'Sách 10', N'Nhi Đồng', 'TG01', 2020, 11, 20000

-- cau 3
create function tong(@tentg nvarchar(30))
returns money
as
begin
	declare @tongtien money
	set @tongtien = (select sum(soluong * DonGia) from sach 
					where matg = (select matg from tacgia
									where @tentg = tentg))
	return @tongtien
end

select dbo.tong(N'Tác giả 1')

-- cau 4
alter trigger cau4
on sach
for insert 
as
begin
	if(not exists(select * from inserted 
					inner join nhaxb ON nhaxb.MaNXB = inserted.MaNXB))
		begin
			raiserror('Ma nxb khong ton tai', 16, 1)
			rollback transaction
		end
	else
		begin
			update nhaxb
			set soluongco = soluongco + 
				(select soluong from inserted)
			where manxb = (select manxb from inserted)
		end
end

alter table sach nocheck constraint all
insert into sach values
('S00', N'Sách 00', 'NXB100', 'TG01', 2020, 11, 20000)
