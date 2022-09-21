CREATE DATABASE QLKhachSan 
GO
USE QLKhachSan 
GO

CREATE TABLE Khach (
	MaKhach CHAR(15) PRIMARY KEY,
	TenKhach NVARCHAR(30), 
	SoDT CHAR(15),  
	Email CHAR(30), 
	Diachi NVARCHAR(30)
)

CREATE TABLE Phong (
	MaPhong CHAR(15) PRIMARY KEY, 
	TenPhong NVARCHAR(30), 
	LoaiPhong NVARCHAR(30),  
	DonGia MONEY, 
	SoNguoi INT
)

CREATE TABLE HoaDon (
	SoHD CHAR(15) PRIMARY KEY, 
	MaKhach CHAR(15), 
	MaPhong CHAR(15), 
	SoNgay INT, 
	CONSTRAINT fk_hoaDon_khach FOREIGN KEY(MaKhach) REFERENCES Khach(MaKhach), 
	CONSTRAINT fk_hoaDon_phong FOREIGN KEY(MaPhong) REFERENCES Phong(MaPhong)
)

INSERT INTO Khach VALUES
('K01', N'Khách 1', '0987654321', 'huannd0101@gmail.com', N'Điện Biên'),
('K02', N'Khách 2', '0987654322', 'huannd01012@gmail.com', N'Hà Nội'),
('K03', N'Khách 3', '0987654323', 'huannd01013@gmail.com', N'Hải Dương')

INSERT INTO Phong VALUES
('P01', N'Phòng 1', N'VIP 1', 2000000, 2),
('P02', N'Phòng 2', N'VIP 1', 3000000, 3),
('P03', N'Phòng 3', N'VIP 2', 4000000, 2)

INSERT INTO HoaDon VALUES
('HD01', 'K01', 'P01', 2),
('HD02', 'K02', 'P01', 3),
('HD03', 'K03', 'P01', 4),
('HD04', 'K01', 'P02', 5),
('HD05', 'K01', 'P03', 6)

--XEM DỮ LIỆU
SELECT * FROM Khach
SELECT * FROM Phong
SELECT * FROM HoaDon

-- CAU 2
create function cau2(@loaiphong nvarchar(30), @songay int)
returns @bang table
(
	makhach char(15) primary key,
	tenkhach nvarchar(30),
	maphong char(15),
	tenphong nvarchar(30)
)
as
begin
	insert into @bang 
	select hd.makhach, tenkhach, hd.maphong, tenphong
	from hoadon hd
	inner join phong p on hd.MaPhong = p.MaPhong
	inner join khach k on hd.MaKhach = k.MaKhach
	where LoaiPhong = @loaiphong and SoNgay = @songay
	return
end

-- thuc thi
select * from cau2(N'VIP 1', 2)

-- cau 3
create proc cau3
(
	@SoHD CHAR(15), 
	@MaKhach CHAR(15), 
	@TenPhong NVARCHAR(30),
	@SoNgay INT
)
as
begin
	if(not exists(select * from phong where TenPhong = @TenPhong))
		begin
			print('Ten phong chua ton tai')
		end
	else
		begin
			declare @maphong char(15) = (select maphong from phong where TenPhong = @TenPhong)
			insert into hoadon values
			(@SoHD, @MaKhach, @maphong, @SoNgay)
		end
end

-- thuc thi that bai
exec cau3 'HD010', 'K01', N'Phòng 10', 2

-- thuc thi thanh cong
exec cau3 'HD010', 'K01', N'Phòng 1', 2


-- cau 4
alter trigger cau4
on hoadon
for insert
as
begin
	if(not exists(select * from inserted inner join khach on inserted.MaKhach = khach.MaKhach))
		begin
			raiserror('Khach khong ton tai', 16, 1)
			rollback transaction
		end
	else if(not exists(select * from inserted inner join phong on inserted.MaPhong = phong.MaPhong))
		begin
			raiserror('Phong khong ton tai', 16, 1)
			rollback transaction
		end
	else
		begin
			update phong 
			set songuoi = songuoi + 1
			where maphong = (select maphong from inserted)
		end
end

alter table hoadon nocheck constraint all
insert into HoaDon values ('HD0100', 'K01', 'P03', 6)

