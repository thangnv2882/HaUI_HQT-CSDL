create database D12062021_15h15
go

use D12062021_15h15
go

create table ban
(
	maban char(15) not null primary key,
	vitri nvarchar(20),
	sochongoi int
)
create table mon
(
	mamon char(15) not null primary key,
	tenmon nvarchar(50),
	mausac nvarchar(20),
	soluong int,
	giaban money,
	mota nvarchar(50)
)
create table hoadon
(
	sohd char(15) not null primary key,
	maban char(15) not null,
	mamon char(15) not null,
	soluongdat int,
	ngaydat datetime,
	constraint fk_hd_ban foreign key(maban)
	references ban(maban),
	constraint fk_hd_ma foreign key(mamon)
	references mon(mamon)
)

insert into ban values
('B1', 'VT1', 11),
('B2', 'VT2', 12),
('B3', 'VT3', 13)

insert into mon values
('M1', 'Mon an 1', N'Đỏ', 10, 1000, N'Ăn ngon'),
('M2', 'Mon an 2', N'Cam', 20, 2000, N'Ăn khá ngon'),
('M3', 'Mon an 3', N'Vàng', 30, 3000, N'Ăn rất ngon')

insert into hoadon values
('HD1', 'B1', 'M1', 1, '2022-06-16'),
('HD2', 'B2', 'M1', 2, '2022-06-15'),
('HD3', 'B3', 'M1', 3, '2022-06-14'),
('HD4', 'B1', 'M2', 4, '2022-06-13'),
('HD5', 'B1', 'M3', 5, '2022-06-12')

select * from ban
select * from mon
select * from hoadon

-- cau 2
create function cau2(@vitri nvarchar(20), @ngaydat datetime)
returns money
as
begin
	declare @tong money
	set @tong = (select sum(giaban*soluongdat)
					from hoadon hd
					inner join mon m on m.mamon = hd.mamon
					inner join ban b on b.maban = hd.maban
					where vitri = @vitri and ngaydat = @ngaydat)

	return @tong
end

-- thuc thi
select dbo.cau2('VT2', '2022-06-15') as 'Tong tien'

-- cau 3
create proc cau3
(
	@sohd char(15),
	@maban char(15),
	@mamon char(15),
	@soluongdat int,
	@ngaydat datetime,
	@output int output
)
as
begin
	if(not exists(select * from ban where maban = @maban))
		begin
			set @output = 1
		end
	else if(not exists(select * from mon where mamon = @mamon))
		begin
			set @output = 2
		end
	else
		begin
			set @output = 0
			insert into hoadon values
			(@sohd, @maban, @mamon, @soluongdat, @ngaydat)
		end
end

-- thuc thi truong hop ma ban khong ton tai
declare @output int
exec cau3 'HD5', 'B10', 'M3', 5, '2022-06-12', @output output
select @output as 'Trang thai'

-- thuc thi truong hop ma mon khong ton tai
declare @output int
exec cau3 'HD5', 'B1', 'M30', 5, '2022-06-12', @output output
select @output as 'Trang thai'

-- thuc thi thanh cong
declare @output int
exec cau3 'HD6', 'B1', 'M3', 5, '2022-06-12', @output output
select @output as 'Trang thai'
select * from hoadon

-- cau 4
alter trigger cau4
on hoadon
for insert
as
begin
	declare @soluongdat int = (select soluongdat from inserted)
	declare @soluong int = (select soluong from mon inner join inserted on inserted.mamon = mon.mamon)
	if(@soluongdat > @soluong)
		begin
			raiserror('Khong du so luong dat hang', 16, 1)
			rollback transaction
		end
	else
		begin
			update mon
			set soluong = @soluong - @soluongdat
			where mamon = (select mamon from inserted)
		end
end

-- thuc thi that bai
insert into hoadon values ('HD100', 'B1', 'M3', 500, '2022-06-16')
	
	
-- thuc thi thanh cong
insert into hoadon values ('HD100', 'B1', 'M1', 3, '2022-06-16')

select * from mon
select * from hoadon


