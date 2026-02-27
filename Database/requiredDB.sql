/****** Object:  Table [dbo].[AdmissionApplications]    Script Date: 2/26/2026 3:45:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AdmissionApplications](
	[Id] [uniqueidentifier] NOT NULL,
	[ApplicationNumber] [nvarchar](50) NOT NULL,
	[StudentName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[CourseId] [int] NOT NULL,
	[CampusId] [int] NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[AppliedDate] [date] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
 CONSTRAINT [PK_AdmissionApplications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ApplicationNumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AdmissionApplications] ADD  DEFAULT (newid()) FOR [Id]
GO

ALTER TABLE [dbo].[AdmissionApplications] ADD  DEFAULT (CONVERT([date],getdate())) FOR [AppliedDate]
GO

ALTER TABLE [dbo].[AdmissionApplications] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[AdmissionApplications]  WITH CHECK ADD CHECK  (([Status]='rejected' OR [Status]='admitted' OR [Status]='shortlisted' OR [Status]='verified' OR [Status]='applied'))
GO

CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Role] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Users] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO


CREATE TABLE [dbo].[StudentProfiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[RollNumber] [nvarchar](50) NULL,
	[YearOfStudy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RollNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StudentProfiles]  WITH CHECK ADD  CONSTRAINT [FK_StudentProfiles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO

ALTER TABLE [dbo].[StudentProfiles] CHECK CONSTRAINT [FK_StudentProfiles_Users]
GO

CREATE TABLE [dbo].[StaffProfiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Designation] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StaffProfiles]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfiles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO

ALTER TABLE [dbo].[StaffProfiles] CHECK CONSTRAINT [FK_StaffProfiles_Users]
GO

CREATE TABLE [dbo].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DepartmentName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Departments] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Departments] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO

CREATE TABLE [dbo].[StaffProfiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Designation] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StaffProfiles]  WITH CHECK ADD  CONSTRAINT [FK_StaffProfiles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO

ALTER TABLE [dbo].[StaffProfiles] CHECK CONSTRAINT [FK_StaffProfiles_Users]
GO

CREATE TABLE [dbo].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DepartmentName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Departments] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Departments] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO

INSERT INTO dbo.Departments (DepartmentName, IsActive, CreatedAt) VALUES
('Computer Science', 1, GETDATE()),
('Mechanical Engineering', 1, GETDATE()),
('Electrical Engineering', 1, GETDATE()),
('Civil Engineering', 1, GETDATE()),
('Business Administration', 1, GETDATE()),
('Commerce', 1, GETDATE()),
('Mathematics', 1, GETDATE()),
('Physics', 1, GETDATE()),
('Chemistry', 1, GETDATE()),
('Biotechnology', 1, GETDATE());

CREATE TABLE [dbo].[Courses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CourseName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO

INSERT INTO dbo.Courses (CourseName, IsActive, CreatedAt) VALUES
('B.Tech', 1, SYSDATETIME()),
('M.Tech', 1, SYSDATETIME()),
('MBA', 1, SYSDATETIME()),
('BBA', 1, SYSDATETIME()),
('B.Com', 1, SYSDATETIME()),
('M.Com', 1, SYSDATETIME()),
('B.Sc', 1, SYSDATETIME()),
('M.Sc', 1, SYSDATETIME()),
('PhD', 1, SYSDATETIME()),
('Diploma', 1, SYSDATETIME());

CREATE TABLE [dbo].[Students](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentCode] [nvarchar](30) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Address] [nvarchar](300) NULL,
	[CampusId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[Batch] [nvarchar](10) NOT NULL,
	[AdmissionDate] [date] NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[GuardianName] [nvarchar](150) NULL,
	[GuardianPhone] [nvarchar](20) NULL,
	[GuardianEmail] [nvarchar](150) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[StudentCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Students] ADD  DEFAULT ('Active') FOR [Status]
GO

ALTER TABLE [dbo].[Students] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Campuses] FOREIGN KEY([CampusId])
REFERENCES [dbo].[Campuses] ([Id])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Campuses]
GO

ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Courses] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([Id])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Courses]
GO




CREATE TABLE [dbo].[Campuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CampusName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Campuses] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Campuses] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO

INSERT INTO dbo.Campuses (CampusName, IsActive, CreatedAt) VALUES
('Main Campus', 1, SYSDATETIME()),
('North Campus', 1, SYSDATETIME()),
('South Campus', 1, SYSDATETIME()),
('East Campus', 1, SYSDATETIME()),
('West Campus', 1, SYSDATETIME()),
('City Campus', 1, SYSDATETIME()),
('Tech Park Campus', 1, SYSDATETIME()),
('Medical Campus', 1, SYSDATETIME()),
('Research Campus', 1, SYSDATETIME()),
('International Campus', 1, SYSDATETIME());



CREATE TABLE [dbo].[Courses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CourseName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO

CREATE TABLE [dbo].[Students](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentCode] [nvarchar](30) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Address] [nvarchar](300) NULL,
	[CampusId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[Batch] [nvarchar](10) NOT NULL,
	[AdmissionDate] [date] NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[GuardianName] [nvarchar](150) NULL,
	[GuardianPhone] [nvarchar](20) NULL,
	[GuardianEmail] [nvarchar](150) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[StudentCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Students] ADD  DEFAULT ('Active') FOR [Status]
GO

ALTER TABLE [dbo].[Students] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Campuses] FOREIGN KEY([CampusId])
REFERENCES [dbo].[Campuses] ([Id])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Campuses]
GO

ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Courses] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([Id])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Courses]
GO

INSERT INTO dbo.Students
(StudentCode, FullName, Email, Phone, DateOfBirth, Address, CampusId, DepartmentId, CourseId, Batch, AdmissionDate, Status, GuardianName, GuardianPhone, GuardianEmail, CreatedAt)
VALUES
('STU001','Arun Kumar','arun1@email.com','9876543210','2002-05-12','Chennai',1,1,1,'2022','2022-06-01','Active','Ravi Kumar','9876500001','ravi@email.com',SYSDATETIME()),
('STU002','Priya Sharma','priya2@email.com','9876543211','2001-03-18','Delhi',2,2,2,'2021','2021-06-01','Active','Anil Sharma','9876500002','anil@email.com',SYSDATETIME()),
('STU003','Rahul Verma','rahul3@email.com','9876543212','2003-01-22','Mumbai',3,3,3,'2023','2023-06-01','Active','Suresh Verma','9876500003','suresh@email.com',SYSDATETIME()),
('STU004','Sneha Reddy','sneha4@email.com','9876543213','2002-07-10','Hyderabad',4,4,4,'2022','2022-06-01','Active','Ramesh Reddy','9876500004','ramesh@email.com',SYSDATETIME()),
('STU005','Vikram Singh','vikram5@email.com','9876543214','2001-11-09','Pune',5,5,5,'2021','2021-06-01','Active','Harish Singh','9876500005','harish@email.com',SYSDATETIME()),
('STU006','Meena Iyer','meena6@email.com','9876543215','2002-08-15','Bangalore',6,6,6,'2022','2022-06-01','Active','Sundar Iyer','9876500006','sundar@email.com',SYSDATETIME()),
('STU007','Karan Mehta','karan7@email.com','9876543216','2003-02-28','Ahmedabad',7,7,7,'2023','2023-06-01','Active','Raj Mehta','9876500007','raj@email.com',SYSDATETIME()),
('STU008','Anjali Das','anjali8@email.com','9876543217','2002-09-19','Kolkata',8,8,8,'2022','2022-06-01','Active','Subhash Das','9876500008','subhash@email.com',SYSDATETIME()),
('STU009','Rohit Nair','rohit9@email.com','9876543218','2001-12-05','Kerala',9,9,9,'2021','2021-06-01','Active','Manoj Nair','9876500009','manoj@email.com',SYSDATETIME()),
('STU010','Divya Patel','divya10@email.com','9876543219','2002-04-30','Surat',10,10,10,'2022','2022-06-01','Active','Kishore Patel','9876500010','kishore@email.com',SYSDATETIME());


CREATE TABLE [dbo].[Campuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CampusName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Campuses] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Campuses] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO



SELECT COUNT(*) FROM dbo.Students;
SELECT COUNT(*) FROM dbo.Departments;
SELECT COUNT(*) FROM dbo.Courses;
SELECT COUNT(*) FROM dbo.Campuses;