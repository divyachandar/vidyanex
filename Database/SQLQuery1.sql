create table doctor(id int not null primary key,name varchar(50),experience int,contactnumber int,specialization varchar(50),patientid int,foreign key(patientid) references patient(id));
select * from patient;
select * from doctor;
alter table patient add primary key(id);