create database QLSACH
on primary(
	name='QLSACH.dat',
	filename='D:\QLSACH.mdf',
	size = 10MB,
	maxsize = 100MB,
	filegrowth=10MB
)

log on(
	name='QLSACH.log',
	filename='D:\QLSACH.ldf',
	size = 1MB,
	maxsize = 5MB,
	filegrowth=20%
)
use qlsach
go

create table tacgia
(
	matg char(15) not null primary key,
	tentg nvarchar(30),
	soluongco int
)
create table nhaxb
(
	manxb char(15) not null primary key,
	tennxb nvarchar(30),
	soluongco int
)
create table sach
(
	masach char(15) not null primary key,
	tensach nvarchar(30),
	manxb char(15) not null,
	matg char(15) not null,
	namxb int,
	soluong int, 
	dongia float
)

insert into tacgia values
('TG1', 'Tac gia 1', 10),
('TG2', 'Tac gia 2', 20),
('TG3', 'Tac gia 3', 30)

insert into nhaxb values
('NXB1', 'Nha xuat ban 1', 10),
('NXB2', 'Nha xuat ban 2', 20),
('NXB3', 'Nha xuat ban 3', 30)

insert into sach values
('MS1', 'Ten sach 1', 'NXB1', 'TG1', 2020, 110, 10),
('MS2', 'Ten sach 2', 'NXB1', 'TG2', 2021, 120, 11),
('MS3', 'Ten sach 3', 'NXB1', 'TG3', 2022, 130, 12),
('MS4', 'Ten sach 4', 'NXB2', 'TG1', 2020, 140, 13),
('MS5', 'Ten sach 5', 'NXB2', 'TG2', 2021, 150, 14),
('MS6', 'Ten sach 6', 'NXB3', 'TG1', 2022, 160, 15)

-- cau 2
create proc cau2(@tentg nvarchar(30), @tennxb nvarchar(30))
as
begin
	if(not exists(select * from tacgia where @tentg = tentg)) 
		print(N'Khong co ten tg')
	else if(not exists(select * from nhaxb where @tennxb = tennxb)) 
		print(N'Khong co ten nxb')
	else
		select masach, tensach, tentg, sum(soluong*dongia)
		from sach
		inner join tacgia tg on sach.matg = tg.matg
		where tentg = @tentg
		group by masach, tensach, tentg
end

exec cau2 'Tac gia 2', 'Nha xuat ban 2'

create trigger cau3
on sach
for insert 
as
begin
	declare @matg char(15)
	declare @soluongthem int

	set @matg = (select matg from inserted)
	set @soluongthem = (select soluong from inserted)

	if(not exists(select * from tacgia where matg = @matg))
	begin
		raiserror(N'Khong co tg nay', 16, 1)
		rollback transaction
	end
	else
	update tacgia set soluongco = soluongco + @soluongthem where matg = @matg
end

select * from sach
select * from tacgia

	 
insert into sach values ('MS22', 'SACH 100', 'NXB1', 'TG1', 2022, 1000000, 10)
