create database KTra2_Triggerr
on primary(
	name='KTra2_Trigger.dat',
	filename='D:\KTra2_Trigger.mdf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth=10MB
)

log on(
	name='KTra2_Trigger.log',
	filename='D:\KTra2_Trigger.ldf',
	size = 1MB,
	maxsize = 5MB,
	filegrowth=20%
)

use KTra2_Trigger
go

create table docgia
(
	madg char(15) not null primary key,
	tendg nvarchar(30),
	diachi nvarchar(50),
	sodt char(15)
)
create table sach
(
	mas char(15) not null primary key,
	tensach nvarchar(30),
	soluong int,
	nhaxb nvarchar(30),
	namxb int
)
create table phieumuon
(
	mapm char(15) not null primary key,
	mas char(15) not null,
	madg char(15) not null,
	soluongmuon int,
	ngayM datetime,
	constraint fk_pm_dg foreign key(madg)
	references docgia(madg),
	constraint fk_pm_s foreign key(mas)
	references sach(mas)
)

insert into docgia values('DG01','TenDG1','DiaChi1','SDT1')
insert into docgia values('DG02','TenDG2','DiaChi2','SDT2')
insert into docgia values('DG03','TenDG3','DiaChi3','SDT3')

insert into sach values('S01','TenSach1',11,'NXB1',2022)
insert into sach values('S02','TenSach2',12,'NXB2',2022)
insert into sach values('S03','TenSach3',13,'NXB3',2022)
					
insert into phieumuon values('PM01','S01','DG01',10,'2/4/2022')
insert into phieumuon values('PM02','S02','DG01',10,'2/4/2022')
insert into phieumuon values('PM03','S01','DG02',10,'2/4/2022')
insert into phieumuon values('PM04','S03','DG01',10,'2/4/2022')
insert into phieumuon values('PM05','S02','DG02',10,'2/4/2022')

select * from docgia
select*from sach
select * from phieumuon



-- Tạo hàm thống kê tổng số lượng sách mượn của 1 độc giả 
-- với mã dg được nhập từ bàn phím
create function fn_cau2(@madg char(15))
returns int
as
begin 
	declare @tong int
	set @tong = (select sum(soluongmuon)
				from phieumuon 
				where madg = @madg)
	return @tong
end

select dbo.fn_cau2('DG02')

-- cau 3
create proc cau3_insPM (
	@mapm nchar(10), 
	@tensach nvarchar(30), 
	@tendg nvarchar(30),
	@soluongm int,
	@ngaym datetime
)
as
begin 
	declare @madg nchar(10)
	declare @mas nchar(10)
	set @madg = (select madg from docgia where tendg = @tendg)
	set @mas = (select mas from sach where tensach = @tensach)
	if(not exists(select * from docgia where @madg = madg))
		print(N'Mã DG không tồn tại')
	else if(not exists(select * from sach where @mas = mas))
		print(N'Mã sách không tồn tại')
	else
		insert into phieumuon values(@mapm,@mas,@madg,@soluongm,@ngaym)
end

exec cau3_insPM 'PM07','TenSach3','TenDG3',3,'2/4/2022'



-- cau 4
create trigger trg_deletePM
on phieumuon
for delete
as 
begin
	declare @mas nchar(10)
	declare @soluongm int
	declare @mapm nchar(10)

	select @mapm = mapm from deleted
	select @soluongm = soluongmuon from deleted
	select @mas = mas from deleted
	
	update sach set soluong = soluong + @soluongm where mas = @mas
end

delete from phieumuon where mapm ='PM03'
