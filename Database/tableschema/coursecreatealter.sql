USE [CampusAdmissionDB]
GO

/****** Object:  Table [dbo].[Courses]    Script Date: 12/29/2025 9:08:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Courses](
	[CourseId] [int] IDENTITY(100,1) NOT NULL,
	[CourseName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[Courses] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO

DBCC CHECKIDENT ('dbo.Courses', RESEED, 99);
GO

DBCC CHECKIDENT ('dbo.Courses', NORESEED);
GO

INSERT INTO dbo.Courses (CourseName)
VALUES
('Computer Science'),
('Information Technology'),
('Mechanical Engineering'),
('Electrical Engineering'),
('Civil Engineering');
GO

select *from dbo.Courses;
