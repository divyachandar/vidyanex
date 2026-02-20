USE [CampusAdmissionDB]
GO

/****** Object:  Table [dbo].[Students]    Script Date: 2/17/2026 7:01:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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


DELETE FROM [dbo].[Students];

INSERT INTO [dbo].[Students]
(
    StudentCode,
    FullName,
    Email,
    Phone,
    DateOfBirth,
    Address,
    CampusId,
    DepartmentId,
    CourseId,
    Batch,
    AdmissionDate,
    Status,
    GuardianName,
    GuardianPhone,
    GuardianEmail,
    CreatedAt,
    UpdatedAt
)
VALUES
('STU001','Rahul Kumar','rahul.kumar1@example.com','9876543210','2002-05-12','Hyderabad',1,1,1,'2023','2023-06-01','Active','Ramesh Kumar','9876500001','ramesh@example.com',SYSDATETIME(),NULL),

('STU002','Anjali Sharma','anjali.sharma@example.com','9876543211','2001-11-22','Vijayawada',1,2,2,'2023','2023-06-02','Active','Suresh Sharma','9876500002','suresh@example.com',SYSDATETIME(),NULL),

('STU003','Kiran Reddy','kiran.reddy@example.com','9876543212','2003-02-10','Guntur',2,1,1,'2024','2024-06-01','Active','Prasad Reddy','9876500003','prasad@example.com',SYSDATETIME(),NULL),

('STU004','Sneha Patel','sneha.patel@example.com','9876543213','2002-07-19','Ahmedabad',1,3,2,'2023','2023-06-03','Active','Mahesh Patel','9876500004','mahesh@example.com',SYSDATETIME(),NULL),

('STU005','Arjun Singh','arjun.singh@example.com','9876543214','2001-09-30','Delhi',2,2,3,'2022','2022-06-01','Active','Raj Singh','9876500005','raj@example.com',SYSDATETIME(),NULL),

('STU006','Meena Nair','meena.nair@example.com','9876543215','2003-03-14','Kochi',1,4,2,'2024','2024-06-05','Active','Suresh Nair','9876500006','suresh.nair@example.com',SYSDATETIME(),NULL),

('STU007','Vikram Joshi','vikram.joshi@example.com','9876543216','2002-12-05','Pune',2,3,1,'2023','2023-06-07','Active','Mohan Joshi','9876500007','mohan@example.com',SYSDATETIME(),NULL),

('STU008','Priya Das','priya.das@example.com','9876543217','2001-04-25','Kolkata',1,1,3,'2022','2022-06-02','Active','Anil Das','9876500008','anil@example.com',SYSDATETIME(),NULL),

('STU009','Rohit Verma','rohit.verma@example.com','9876543218','2003-08-18','Lucknow',2,2,2,'2024','2024-06-10','Active','Sunil Verma','9876500009','sunil@example.com',SYSDATETIME(),NULL),

('STU010','Divya Iyer','divya.iyer@example.com','9876543219','2002-01-11','Chennai',1,4,1,'2023','2023-06-12','Active','Ravi Iyer','9876500010','ravi@example.com',SYSDATETIME(),NULL);
