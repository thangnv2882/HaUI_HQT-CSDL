create database qlbanhang
go

use qlbanhang
go

create table khoa
(
	makhoa char(15) not null primary key,
	tenkhoa nvarchar(30),
	diadiem nvarchar(50)
)

create table lop
(
	malop char(15) not null primary key,
	tenlop nvarchar(30),
	siso int,
	makhoa char(15),
	constraint fk_lop_khoa foreign key(makhoa)
	references khoa(makhoa)
)

create table sinhvien
(
	masv char(15),
	hoten nvarchar(30),
	ns datetime,
	gioitinh bit,
	malop char(15),
	constraint fk_sv_lop foreign key(malop)
	references lop(malop)
)

insert into khoa values
('MK1', 'Ten khoa 1', 'Nha 1'),
('MK2', 'Ten khoa 2', 'Nha 2'),
('MK3', 'Ten khoa 3', 'Nha 3')

insert into lop values 
('ML1', 'Ten lop 1', 50, 'MK1'), 
('ML2', 'Ten lop 2', 51, 'MK1'), 
('ML3', 'Ten lop 3', 52, 'MK2')

insert into sinhvien values
('SV1', 'Sinh Vien 1', '01-01-2002', 0, 'ML1'),
('SV2', 'Sinh Vien 2', '02-01-2002', 1, 'ML2'),
('SV3', 'Sinh Vien 3', '03-01-2002', 0, 'ML3'),
('SV4', 'Sinh Vien 4', '04-01-2002', 1, 'ML1'),
('SV5', 'Sinh Vien 5', '05-01-2002', 0, 'ML2'),
('SV6', 'Sinh Vien 6', '06-01-2002', 1, 'ML1')

select * from khoa
select * from lop
select * from sinhvien

alter proc cau2 (
	@masv char(15), @hoten nvarchar(30), @ns datetime, @gioitinh bit, @malop char(15), @bien int output
)
as
begin 
	if(GETDATE() < @ns)
	begin
		print(N'Ngày sinh không hợp lệ')
		set @bien = 1
	end
	else
	begin
		insert into sinhvien values(@masv, @hoten, @ns, @gioitinh, @malop)
		set @bien = 0
	end
	return @bien
end

declare @bien int
exec cau2 'SV10','Sinh Vien 10','10-01-2025',0,'ML1', @bien output
select @bien


create trigger trg_CapNhatSV
on SinhVien 
for update as
begin 
	if UPDATE(MaSV)
		begin 
			raiserror(N'Không cho phép cập nhật ở cột mã sv' , 16 , 1)
			rollback transaction
		end
	else
	if UPDATE(MaLop)
		begin
			declare @MalopTruoc nchar(10) 
			declare @MalopSau nchar(10)
			declare @sisotruoc int 
			declare @sisosau int 
			set @MalopTruoc = (select MaLop from deleted)
			set @MalopSau = (select Malop from inserted )
			if(not exists(select Malop from Lop where MaLop = @MalopSau))
				begin
				raiserror(N'Không tồn tại mã lớp này' , 16 , 1)
				rollback transaction
				end
			else
			begin
				set @sisotruoc = (select Siso from Lop where MaLop = @MalopTruoc)
				set @sisosau = (select Siso from Lop where MaLop = @MalopSau)
				update Lop set Siso =	@sisotruoc - 1 where MaLop = @MalopTruoc
				update Lop set Siso =	@sisosau + 1 where MaLop = @MalopSau
			end
		end
end 

select*from SinhVien
update SinhVien set MaLop = 'L1'
select*from Lop