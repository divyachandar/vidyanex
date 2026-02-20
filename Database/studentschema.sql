USE [CampusAdmissionDB]
GO

/****** Object:  Table [dbo].[Campuses]    Script Date: 2/17/2026 7:44:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

DELETE FROM  [dbo].[Campuses];

INSERT INTO [dbo].[Campuses]
(
    CampusName,
    IsActive,
    CreatedAt
)
VALUES
('Hyderabad Main Campus', 1, SYSDATETIME()),
('Vijayawada Campus', 1, SYSDATETIME()),
('Guntur Campus', 1, SYSDATETIME()),
('Visakhapatnam Campus', 1, SYSDATETIME()),
('Chennai Campus', 1, SYSDATETIME()),
('Bangalore Campus', 1, SYSDATETIME()),
('Pune Campus', 1, SYSDATETIME()),
('Delhi Campus', 1, SYSDATETIME()),
('Mumbai Campus', 1, SYSDATETIME()),
('Kolkata Campus', 1, SYSDATETIME());


select * from Campuses