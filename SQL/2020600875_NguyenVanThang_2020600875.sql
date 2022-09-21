create database QLSV
on primary (
	name=QLSV,
	filename='D:\Fighting\Ky_4\4. HeQT-CSDL\SQL\QLSV.mdf',
	size=15MB,
	maxsize=50MB,
	filegrowth=20%

)
Log on(
	name=BH_log,
	filename='D:\Fighting\Ky_4\4. HeQT-CSDL\SQL\QLSV.ldf',
	size=5MB,
	maxsize=10MB,
	filegrowth=1MB
)
use QLSV
go

create table SV (
	MaSV nchar(15) not null primary key,
	TenSV nvarchar(30) not null,
	Que nvarchar(20) not null
)
create table MON (
	MaMH nchar(15) not null primary key,
	TenMH nvarchar(30) not null,
	Sotc int not null,
	constraint chk_sotc CHECK(Sotc >= 2 AND Sotc <= 5),
	constraint unique_tenmh UNIQUE(TenMH)

)

