create database btth
go

/*
on primary(
	name='QLSach98.dat',
	filename='E:\A Year 2 Sophomore\Preiod 4\HeQuanTriCSDL\fileLog\Qlsach.mdf',
	size=10MB,
	maxsize=100MB,
	filegrowth=10MB
)

log on(
	name='QLsach98.log',
	filename='E:\A Year 2 Sophomore\Preiod 4\HeQuanTriCSDL\fileLog\QLsach.ldf',
	size=1MB,
	maxsize=5MB,
	filegrowth=20%
)
*/

use btth
go

create table congty
(
	macongty char(15) not null primary key,
	tencongty nvarchar(30),
	diachi nvarchar(50)
)

create table sanpham
(
	masanpham char(15) not null primary key,
	tensanpham nvarchar(30),
	mausac nvarchar(20),
	soluongco int,
	giaban money
)
create table cungung
(
	macongty char(15) not null,
	masanpham char(15) not null,
	soluongcungung int,
	ngaycungung datetime
	constraint pk_cu primary key(macongty, masanpham),
	constraint fk_cu_ct foreign key(macongty)
	references congty(macongty),
	constraint fk_cu_sp foreign key(masanpham)
	references sanpham(masanpham)
)

insert into congty values
('CT1', 'Ten cong ty 1', N'Hà Nội'),
('CT2', 'Ten cong ty 2', N'Hà Nam'),
('CT3', 'Ten cong ty 3', N'Hà Giang')

insert into sanpham values
('SP1', 'Ten san pham 1', N'Đỏ', 100, 100),
('SP2', 'Ten san pham 2', N'Cam', 110, 110),
('SP3', 'Ten san pham 3', N'Vàng', 120, 120)

insert into cungung values
('CT1', 'SP1', 10, '2022-06-15'),
('CT2', 'SP1', 11, '2022-06-14'),
('CT3', 'SP1', 12, '2022-06-13'),
('CT1', 'SP2', 13, '2022-06-12'),
('CT1', 'SP3', 14, '2022-06-11')

select * from congty
select * from sanpham
select * from cungung


-- cau 2
create function cau2(@tencongty nvarchar(30), @ngaycungung datetime)
returns @bang table
(
	tensanpham nvarchar(30),
	mausac nvarchar(20),
	soluong int,
	giaban money
)
as
begin
	insert into @bang
	select tensanpham, mausac, soluongco, giaban
	from sanpham sp
	inner join cungung cu on cu.masanpham = sp.masanpham
	inner join congty ct on ct.macongty = cu.macongty
	where @tencongty = tencongty and @ngaycungung = ngaycungung

	return
end

-- thuc thi 
select * from cau2('Ten cong ty 2', '2022-06-14')

-- cau 3
alter proc cau3(@macongty char(15), @tencongty nvarchar(30), @diachi nvarchar(50), @output int output)
as
begin
	if(exists(select * from congty where tencongty = @tencongty))
		begin
			set @output = 1
			print('Ten cong ty da ton tai')
		end
	else
		begin
			set @output = 0
			insert into congty values
			(@macongty, @tencongty, @diachi)
		end
	return @output
end

-- thuc thi that bai
declare @output int
exec cau3 'CT10', 'Ten cong ty 1', 'Ha Noi', @output output
select @output

-- thuc thi thanh cong
declare @output int
exec cau3 'CT100', 'Ten cong ty 100', 'Ha Noi', @output output
select @output

-- cau 4
alter trigger cau4
on cungung
for update
as
begin
	declare @masanphammoi char(15) = (select masanpham from inserted)
	declare @soluongcungungcu int = (select soluongcungung from deleted)
	declare @soluongcungungmoi int = (select soluongcungung from inserted)
	declare @soluongco int = (select soluongco from sanpham where masanpham = @masanphammoi)

	if(@soluongcungungmoi - @soluongcungungcu > @soluongco) 
		begin
			raiserror('Khong du so luong', 16, 1)
			rollback transaction
		end
	else
		begin
			update sanpham
			set soluongco = (@soluongco - (@soluongcungungmoi - @soluongcungungcu))
			where masanpham = @masanphammoi
		end
end

-- thuc thi that bai
update cungung set soluongcungung = 250 where masanpham = 'SP2'


-- thuc thi thanh cong
update cungung set soluongcungung = 50 where masanpham = 'SP2'

select * from sanpham
select * from cungung


