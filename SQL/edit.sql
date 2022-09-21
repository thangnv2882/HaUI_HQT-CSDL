Alter table Xuat
add constraint pka primary key(SoHDX, MaSP)

ALTER TABLE Xuat
ALTER COLUMN MaSP nchar(10) NOT NULL

ALTER TABLE Xuat
DROP CONSTRAINT SoHDX;