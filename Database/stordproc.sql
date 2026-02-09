select *from Patients
create procedure selctAllPatient @Gender nvarchar(30) 
as
select * from Patients where Gender=@Gender
go
exec selctAllPatient @Gender='F';
create procedure UpSetPatient @PatientID int output,@FirstName nvarchar(30),@LastName nvarchar(30),@DateOfBirth date,@Gender nvarchar(20),@ContactNo nvarchar(20)
as
set nocount on
begin
if not exists(select @PatientID from Patients where PatientID=@PatientID)
begin
insert into Patients(FirstName,LastName,DateOfBirth,Gender,ContactNo) 
values(@FirstName,@LastName,@DateOfBirth,@Gender,@ContactNo)
set @PatientID=SCOPE_IDENTITY()
end
else begin
update Patients
set 
FirstName=@FirstName,
LastName=@LastName,
DateOfBirth=@DateOfBirth,
Gender=@Gender,
ContactNo=@ContactNo
where PatientID=@PatientID
end
end
end