create database QLThuVien

on primary(
	name='QLThuVien.dat',
	filename='D:\Mon hoc tren truong\Ky4\HQTCSDL\Ktratx2\QLThuVien.mdf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth=10MB
)

log on(
	name='QLThuVien.log',
	filename='D:\Mon hoc tren truong\Ky4\HQTCSDL\Ktratx2\QLThuVien.ldf',
	size = 1MB,
	maxsize = 5MB,
	filegrowth=20%
)

use QLThuVien
go

create table docgia(
	madg nchar(10) not null primary key,
	tendg nvarchar(30),
	diachi nvarchar(30),
	sdt varchar(30)
)

create table sach(
	mas nchar(10) not null primary key,
	tens nvarchar(30),
	soluong int,
	nhaxb nvarchar(30),
	namxb int
)

create table phieumuon(
	mapm nchar(10) not null primary key,
	mas nchar(10) not null,
	madg nchar(10) not null,
	soluongm int,
	ngaym datetime
	constraint fk_pm_mas foreign key(mas) references sach(mas),
	constraint fk_pm_madg foreign key(madg) references docgia(madg)
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

/* cau 2 */
create function fn_thongkeslsach(@madg nchar(10))
returns int
as
begin
	declare @tongsl int
	select @tongsl = sum(soluongm)
	from phieumuon where madg = @madg
	return @tongsl
end

select dbo.fn_thongkeslsach('DG01')

/* cau 3 */
create proc sp_insPhieumuon (@mapm nchar(10), @tensach nvarchar(30), @tendg nvarchar(30), @soluongm int, @ngaym datetime)
as
begin
	declare @madg nchar(10)
	declare @masach nchar(10)
	set @madg = (select madg from docgia where tendg = @tendg)
	set @masach = (select mas from sach where tens = @tensach)
	if(not exists (select madg from docgia where madg = @madg))
		print(N'Không tồn tại tên độc giả')
	else
		if(not exists (select mas from sach where mas = @masach))
			print(N'Không tồn tại tên sách')
		else
			insert into phieumuon values(@mapm,@masach,@madg,@soluongm,@ngaym)
end

exec sp_insPhieumuon 'PM06','TenSach3','TenDG3',3,'2/4/2022'

/* Cau 4 */
create trigger trg_deletePM
on phieumuon
for delete
as 
begin
	declare @mas nchar(10)
	declare @soluongm int
	declare @mapm nchar(10)
	select @mapm = mapm from deleted
	select @soluongm = soluongm from deleted
	select @mas = mas from deleted
	
	update sach set soluong = soluong + @soluongm where mas = @mas
end


delete from phieumuon where mapm ='PM07'
