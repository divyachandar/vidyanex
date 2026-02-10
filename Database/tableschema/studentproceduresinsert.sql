CREATE TABLE Students (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentCode NVARCHAR(30) NOT NULL UNIQUE, -- STU-2024-001
    FullName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NOT NULL,

    DateOfBirth DATE NOT NULL,
    Address NVARCHAR(300),

    CampusId INT NOT NULL,
    DepartmentId INT NOT NULL,
    CourseId INT NOT NULL,

    Batch NVARCHAR(10) NOT NULL,
    AdmissionDate DATE NOT NULL,

    Status NVARCHAR(20) NOT NULL DEFAULT 'Active', -- Active / Inactive / Suspended

    GuardianName NVARCHAR(150),
    GuardianPhone NVARCHAR(20),
    GuardianEmail NVARCHAR(150),

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL
);

CREATE PROCEDURE sp_Student_Insert
(
    @StudentCode NVARCHAR(30),
    @FullName NVARCHAR(150),
    @Email NVARCHAR(150),
    @Phone NVARCHAR(20),
    @DateOfBirth DATE,
    @Address NVARCHAR(300),
    @CampusId INT,
    @DepartmentId INT,
    @CourseId INT,
    @Batch NVARCHAR(10),
    @AdmissionDate DATE,
    @GuardianName NVARCHAR(150) = NULL,
    @GuardianPhone NVARCHAR(20) = NULL,
    @GuardianEmail NVARCHAR(150) = NULL
)
AS
BEGIN
    INSERT INTO Students
    (
        StudentCode, FullName, Email, Phone, DateOfBirth, Address,
        CampusId, DepartmentId, CourseId, Batch, AdmissionDate,
        GuardianName, GuardianPhone, GuardianEmail
    )
    VALUES
    (
        @StudentCode, @FullName, @Email, @Phone, @DateOfBirth, @Address,
        @CampusId, @DepartmentId, @CourseId, @Batch, @AdmissionDate,
        @GuardianName, @GuardianPhone, @GuardianEmail
    );
END

CREATE PROCEDURE sp_Student_Update
(
    @StudentId INT,
    @FullName NVARCHAR(150),
    @Phone NVARCHAR(20),
    @Address NVARCHAR(300),
    @DepartmentId INT,
    @CourseId INT,
    @GuardianName NVARCHAR(150),
    @GuardianPhone NVARCHAR(20),
    @GuardianEmail NVARCHAR(150)
)
AS
BEGIN
    UPDATE Students
    SET
        FullName = @FullName,
        Phone = @Phone,
        Address = @Address,
        DepartmentId = @DepartmentId,
        CourseId = @CourseId,
        GuardianName = @GuardianName,
        GuardianPhone = @GuardianPhone,
        GuardianEmail = @GuardianEmail,
        UpdatedAt = SYSDATETIME()
    WHERE StudentId = @StudentId;
END

CREATE PROCEDURE sp_Student_GetAll
AS
BEGIN
    SELECT * FROM Students ORDER BY CreatedAt DESC;
END

CREATE PROCEDURE sp_Student_GetById
(
    @StudentId INT
)
AS
BEGIN
    SELECT * FROM Students WHERE StudentId = @StudentId;
END


CREATE PROCEDURE sp_Student_ChangeStatus
(
    @StudentId INT,
    @Status NVARCHAR(20)
)
AS
BEGIN
    UPDATE Students
    SET Status = @Status, UpdatedAt = SYSDATETIME()
    WHERE StudentId = @StudentId;
END

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-001',
    @FullName = 'Aarav Sharma',
    @Email = 'aarav.sharma@example.com',
    @Phone = '9876543210',
    @DateOfBirth = '2003-04-15',
    @Address = 'Hyderabad, Telangana',
    @CampusId = 1,
    @DepartmentId = 1,
    @CourseId = 101,
    @Batch = '2024',
    @AdmissionDate = '2024-07-01',
    @GuardianName = 'Rajesh Sharma',
    @GuardianPhone = '9876500001',
    @GuardianEmail = 'rajesh.sharma@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-002',
    @FullName = 'Ananya Reddy',
    @Email = 'ananya.reddy@example.com',
    @Phone = '9876543211',
    @DateOfBirth = '2002-11-20',
    @Address = 'Bangalore, Karnataka',
    @CampusId = 1,
    @DepartmentId = 2,
    @CourseId = 102,
    @Batch = '2024',
    @AdmissionDate = '2024-07-01',
    @GuardianName = 'Suresh Reddy',
    @GuardianPhone = '9876500002',
    @GuardianEmail = 'suresh.reddy@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-003',
    @FullName = 'Rohan Verma',
    @Email = 'rohan.verma@example.com',
    @Phone = '9876543212',
    @DateOfBirth = '2003-02-05',
    @Address = 'Pune, Maharashtra',
    @CampusId = 2,
    @DepartmentId = 1,
    @CourseId = 101,
    @Batch = '2024',
    @AdmissionDate = '2024-07-02',
    @GuardianName = 'Manoj Verma',
    @GuardianPhone = '9876500003',
    @GuardianEmail = 'manoj.verma@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-004',
    @FullName = 'Sneha Iyer',
    @Email = 'sneha.iyer@example.com',
    @Phone = '9876543213',
    @DateOfBirth = '2003-08-18',
    @Address = 'Chennai, Tamil Nadu',
    @CampusId = 2,
    @DepartmentId = 3,
    @CourseId = 103,
    @Batch = '2024',
    @AdmissionDate = '2024-07-02',
    @GuardianName = 'Ramesh Iyer',
    @GuardianPhone = '9876500004',
    @GuardianEmail = 'ramesh.iyer@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-005',
    @FullName = 'Karthik Naidu',
    @Email = 'karthik.naidu@example.com',
    @Phone = '9876543214',
    @DateOfBirth = '2002-12-30',
    @Address = 'Visakhapatnam, Andhra Pradesh',
    @CampusId = 1,
    @DepartmentId = 2,
    @CourseId = 102,
    @Batch = '2024',
    @AdmissionDate = '2024-07-03',
    @GuardianName = 'Srinivas Naidu',
    @GuardianPhone = '9876500005',
    @GuardianEmail = 'srinivas.naidu@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-006',
    @FullName = 'Priya Mehta',
    @Email = 'priya.mehta@example.com',
    @Phone = '9876543215',
    @DateOfBirth = '2003-01-12',
    @Address = 'Ahmedabad, Gujarat',
    @CampusId = 3,
    @DepartmentId = 4,
    @CourseId = 104,
    @Batch = '2024',
    @AdmissionDate = '2024-07-03',
    @GuardianName = 'Vijay Mehta',
    @GuardianPhone = '9876500006',
    @GuardianEmail = 'vijay.mehta@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-007',
    @FullName = 'Mohammed Faizan',
    @Email = 'mohammed.faizan@example.com',
    @Phone = '9876543216',
    @DateOfBirth = '2002-09-25',
    @Address = 'Hyderabad, Telangana',
    @CampusId = 1,
    @DepartmentId = 5,
    @CourseId = 105,
    @Batch = '2024',
    @AdmissionDate = '2024-07-04',
    @GuardianName = 'Abdul Rahman',
    @GuardianPhone = '9876500007',
    @GuardianEmail = 'abdul.rahman@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-008',
    @FullName = 'Neha Kapoor',
    @Email = 'neha.kapoor@example.com',
    @Phone = '9876543217',
    @DateOfBirth = '2003-05-09',
    @Address = 'Delhi',
    @CampusId = 2,
    @DepartmentId = 1,
    @CourseId = 101,
    @Batch = '2024',
    @AdmissionDate = '2024-07-04',
    @GuardianName = 'Amit Kapoor',
    @GuardianPhone = '9876500008',
    @GuardianEmail = 'amit.kapoor@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-009',
    @FullName = 'Sanjay Patel',
    @Email = 'sanjay.patel@example.com',
    @Phone = '9876543218',
    @DateOfBirth = '2002-10-14',
    @Address = 'Surat, Gujarat',
    @CampusId = 3,
    @DepartmentId = 4,
    @CourseId = 104,
    @Batch = '2024',
    @AdmissionDate = '2024-07-05',
    @GuardianName = 'Mahesh Patel',
    @GuardianPhone = '9876500009',
    @GuardianEmail = 'mahesh.patel@example.com';
GO

EXEC sp_Student_Insert
    @StudentCode = 'STU-2024-010',
    @FullName = 'Divya Nair',
    @Email = 'divya.nair@example.com',
    @Phone = '9876543219',
    @DateOfBirth = '2003-03-22',
    @Address = 'Kochi, Kerala',
    @CampusId = 2,
    @DepartmentId = 3,
    @CourseId = 103,
    @Batch = '2024',
    @AdmissionDate = '2024-07-05',
    @GuardianName = 'Suresh Nair',
    @GuardianPhone = '9876500010',
    @GuardianEmail = 'suresh.nair@example.com';
GO


SELECT StudentId, StudentCode, FullName, Email, Status, CreatedAt
FROM Students
ORDER BY StudentId;

ALTER TABLE dbo.Students
ADD CONSTRAINT FK_Students_Campuses
FOREIGN KEY (CampusId)
REFERENCES dbo.Campuses (CampusId)
ON UPDATE CASCADE
ON DELETE NO ACTION;
GO

SELECT DISTINCT CampusId
FROM Students
WHERE CampusId NOT IN (SELECT CampusId FROM Campuses);

INSERT INTO Campuses (CampusName)
SELECT 'Gayatri Campus ' + CAST(CampusId AS NVARCHAR)
FROM Students
WHERE CampusId NOT IN (SELECT CampusId FROM Campuses)
GROUP BY CampusId;

ALTER TABLE dbo.Students
ADD CONSTRAINT FK_Students_Campuses
FOREIGN KEY (CampusId)
REFERENCES dbo.Campuses (CampusId)
ON UPDATE CASCADE
ON DELETE NO ACTION;
GO

INSERT INTO dbo.Campuses (CampusName)
VALUES
    (3,'Main Campus','True'),
    (4,'North Campus','True');
   
DELETE FROM dbo.Campuses
WHERE CampusId NOT IN (
    SELECT DISTINCT CampusId FROM dbo.Students
);

select *from dbo.Campuses;
INSERT INTO dbo.Campuses (CampusName, IsActive)
VALUES
('City Campus', 1),
('Rural Campus', 1);

SET IDENTITY_INSERT dbo.Campuses ON;

INSERT INTO dbo.Campuses (CampusId, CampusName, IsActive, CreatedAt)
VALUES (3, 'Gayatri Campus', 1, SYSDATETIME());

SET IDENTITY_INSERT dbo.Campuses OFF

ALTER TABLE dbo.Students
ADD CONSTRAINT FK_Students_Courses
FOREIGN KEY (CourseId)
REFERENCES dbo.Courses (CourseId)
ON UPDATE CASCADE
ON DELETE NO ACTION;
GO


ALTER TABLE dbo.Students
ADD CONSTRAINT FK_Students_Courses
FOREIGN KEY (CourseId)
REFERENCES dbo.Courses (CourseId)
ON UPDATE CASCADE
ON DELETE NO ACTION;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create sp_Student_Delete
CREATE OR ALTER PROCEDURE [dbo].[sp_Student_Delete]
    @StudentId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM [dbo].[Students]
    WHERE StudentId = @StudentId
END
GO