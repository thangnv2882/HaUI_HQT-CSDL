create database kt2_6_11
go

use kt2_6_11
go

drop table ton
drop table nhap
drop table xuat

create table ton
(
	mavt varchar(20) not null primary key,
	tenvt nvarchar(30),
	soluongt int
)

create table nhap
(
	sohdn varchar(20) not null,
	mavt varchar(20) not null,
	soluongn int,
	dongian float,
	ngayn date
	constraint pk_nhap primary key(sohdn, mavt),
	constraint fk_nhap_ton foreign key(mavt) 
	references ton(mavt)
)

create table xuat
(
	sohdx varchar(20) not null,
	mavt varchar(20) not null,
	soluongx int,
	dongiax float,
	ngayx date
	constraint pk_xuat primary key(sohdx, mavt),
	constraint fk_xuat_ton foreign key(mavt) 
	references ton(mavt)
)

insert into ton values
('vt1', 'vat tu 1', 10),
('vt2', 'vat tu 2', 20),
('vt3', 'vat tu 3', 30),
('vt4', 'vat tu 4', 40),
('vt5', 'vat tu 5', 50)

insert into nhap values
('hdn1', 'vt1', 100, 1000, '2022-04-10'),
('hdn2', 'vt3', 300, 3000, '2022-04-20'),
('hdn3', 'vt5', 500, 5000, '2022-04-30')

insert into xuat values
('hdx1', 'vt3', 30, 3001, '2022-04-21'),
('hdx2', 'vt5', 50, 5001, '2022-05-01')

ALTER TABLE nhap nocheck CONSTRAINT all
ALTER TABLE xuat nocheck CONSTRAINT all

DELETE 
FROM ton
FROM nhap, xuat
WHERE ton.mavt = nhap.mavt
	AND ton.mavt = xuat.mavt
	AND dongiax > dongian

ALTER TABLE nhap check CONSTRAINT all
ALTER TABLE xuat check CONSTRAINT all

select * from nhap
select * from xuat
select * from ton

update xuat set ngayx = ngayn
from nhap
where xuat.mavt = nhap.mavt and ngayx < ngayn

select tenvt, soluongt
from ton
where soluongt = (select max(soluongt) from ton)

create view vw4
as
select MONTH(ngayx) as 'thang', YEAR(ngayx) as 'nam', SUM(soluongx) as 'sum'
from xuat
group by MONTH(ngayx), YEAR(ngayx)

select * from vw4

create view vw5
as
select t.mavt, tenvt, soluongn, soluongx, dongian, dongiax, ngayn, ngayx
from nhap n
inner join xuat x on n.mavt = x.mavt
inner join ton t on t.mavt = n.mavt

select * from vw5

create view vw_cau6
as
select t.MaVT, TenVT, SUM(SoLuongN) - SUM(SoLuongX) + SUM(SoLuongT) as 'So luong ton'
from ton t
inner join nhap n on t.MaVT = n.MaVT
inner join xuat x on t.MaVT = x.MaVT
where YEAR(NgayX) = 2022
group by t.MaVT, TenVT

select * from vw_cau6

