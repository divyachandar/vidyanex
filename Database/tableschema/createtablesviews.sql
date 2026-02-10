CREATE TABLE Departments (
    DepartmentId INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(500) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);
CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE UserRoles (
    UserId INT NOT NULL,
    RoleId INT NOT NULL,
    CONSTRAINT PK_UserRoles PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);
CREATE TABLE UserProfiles (
    ProfileId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL UNIQUE,

    FullName NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(20) NULL,
    DepartmentId INT NULL,
    AvatarUrl NVARCHAR(500) NULL,

    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_UserProfiles_Users
        FOREIGN KEY (UserId) REFERENCES Users(UserId),

    CONSTRAINT FK_UserProfiles_Departments
        FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId)
);
CREATE TABLE StudentProfiles (
    StudentProfileId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL UNIQUE,
    RollNumber NVARCHAR(50) UNIQUE,
    YearOfStudy INT,
    CONSTRAINT FK_StudentProfiles_Users
        FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
CREATE TABLE StaffProfiles (
    StaffProfileId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL UNIQUE,
    Designation NVARCHAR(100),
    CONSTRAINT FK_StaffProfiles_Users
        FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE PROCEDURE sp_GetUserProfile
    @UserId INT
AS
BEGIN
    SELECT
        u.UserId,
        up.FullName,
        u.Email,
        r.RoleName,
        up.Phone,
        d.DepartmentName,
        up.AvatarUrl
    FROM Users u
    JOIN UserProfiles up ON u.UserId = up.UserId
    JOIN UserRoles ur ON u.UserId = ur.UserId
    JOIN Roles r ON ur.RoleId = r.RoleId
    LEFT JOIN Departments d ON up.DepartmentId = d.DepartmentId
    WHERE u.UserId = @UserId;
END;
 
 CREATE TABLE Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Departments (
    DepartmentId INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Students (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentCode NVARCHAR(50) NOT NULL UNIQUE,
    FullName NVARCHAR(150) NOT NULL,
    CourseId INT NOT NULL,
    DepartmentId INT NOT NULL,
    AdmissionDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Students_Course
        FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),

    CONSTRAINT FK_Students_Department
        FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId)
);
CREATE TABLE StudentAttendance (
    AttendanceId BIGINT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT NOT NULL,
    AttendanceDate DATE NOT NULL,
    IsPresent BIT NOT NULL,

    CONSTRAINT UQ_Attendance UNIQUE (StudentId, AttendanceDate),

    CONSTRAINT FK_Attendance_Student
        FOREIGN KEY (StudentId) REFERENCES Students(StudentId)
);
CREATE TABLE Subjects (
    SubjectId INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(100) NOT NULL,
    CourseId INT NOT NULL,

    CONSTRAINT FK_Subjects_Course
        FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE Exams (
    ExamId INT IDENTITY(1,1) PRIMARY KEY,
    ExamName NVARCHAR(150) NOT NULL,
    ExamDate DATE NOT NULL,
    CourseId INT NOT NULL,

    CONSTRAINT FK_Exams_Course
        FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);
CREATE TABLE ExamResults (
    ResultId BIGINT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT NOT NULL,
    ExamId INT NOT NULL,
    SubjectId INT NOT NULL,
    MarksObtained DECIMAL(5,2) NOT NULL,
    MaxMarks DECIMAL(5,2) NOT NULL,

    CONSTRAINT FK_Results_Student
        FOREIGN KEY (StudentId) REFERENCES Students(StudentId),

    CONSTRAINT FK_Results_Exam
        FOREIGN KEY (ExamId) REFERENCES Exams(ExamId),

    CONSTRAINT FK_Results_Subject
        FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId)
);
CREATE TABLE FeeStructures (
    FeeStructureId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_FeeStructure_Course
        FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE VIEW vw_MonthlyAttendance
AS
SELECT
    DATENAME(MONTH, AttendanceDate) AS [Month],
    CAST(
        SUM(CASE WHEN IsPresent = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS DECIMAL(5,2)
    ) AS AttendancePercentage
FROM StudentAttendance
GROUP BY DATENAME(MONTH, AttendanceDate), MONTH(AttendanceDate);

CREATE VIEW vw_StudentDistribution
AS
SELECT
    c.CourseName,
    COUNT(s.StudentId) AS StudentCount
FROM Students s
JOIN Courses c ON s.CourseId = c.CourseId
GROUP BY c.CourseName;

CREATE VIEW vw_MonthlyFeeCollection
AS
SELECT
    DATENAME(MONTH, PaymentDate) AS [Month],
    SUM(AmountPaid) AS CollectedAmount
FROM StudentFeePayments
GROUP BY DATENAME(MONTH, PaymentDate), MONTH(PaymentDate);


CREATE TABLE Students (
    StudentId NVARCHAR(50) NOT NULL PRIMARY KEY,  -- e.g. STU-2024-001
    FullName NVARCHAR(150) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
CREATE TABLE Exams (
    ExamId INT IDENTITY(1,1) PRIMARY KEY,
    ExamName NVARCHAR(150) NOT NULL,   -- e.g. Mid-Term 2024
    ExamDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
CREATE TABLE Subjects (
    SubjectId NVARCHAR(50) NOT NULL PRIMARY KEY, -- e.g. SUB-001
    SubjectName NVARCHAR(100) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
CREATE TABLE StudentResults (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,

    StudentId NVARCHAR(50) NOT NULL,
    ExamId INT NOT NULL,
    SubjectId NVARCHAR(50) NOT NULL,

    MarksObtained DECIMAL(5,2) NOT NULL,
    MaxMarks DECIMAL(5,2) NOT NULL,

    Percentage AS 
        (CASE 
            WHEN MaxMarks = 0 THEN 0 
            ELSE (MarksObtained * 100.0 / MaxMarks) 
         END) PERSISTED,

    Grade NVARCHAR(5) NOT NULL,  -- A+, A, B+, etc.

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Results_Student
        FOREIGN KEY (StudentId) REFERENCES Students(StudentId),

    CONSTRAINT FK_Results_Exam
        FOREIGN KEY (ExamId) REFERENCES Exams(ExamId),

    CONSTRAINT FK_Results_Subject
        FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId),

    CONSTRAINT UQ_Student_Exam_Subject
        UNIQUE (StudentId, ExamId, SubjectId)
);

CREATE VIEW vw_StudentOverallResult
AS
SELECT
    StudentId,
    ExamId,
    CAST(AVG(Percentage) / 10 AS DECIMAL(4,2)) AS GPA,
    CAST(SUM(MarksObtained) * 100.0 / SUM(MaxMarks) AS DECIMAL(5,2)) AS OverallPercentage
FROM StudentResults
GROUP BY StudentId, ExamId;

CREATE VIEW vw_StudentResultDetails
AS
SELECT
    r.ResultId,
    r.StudentId,
    s.FullName,
    r.ExamId,
    e.ExamName,
    r.SubjectId,
    sub.SubjectName,
    r.MarksObtained,
    r.MaxMarks,
    r.Percentage,
    r.Grade
FROM StudentResults r
JOIN Students s ON r.StudentId = s.StudentId
JOIN Exams e ON r.ExamId = e.ExamId
JOIN Subjects sub ON r.SubjectId = sub.SubjectId;

CREATE INDEX IX_Results_Student ON StudentResults(StudentId);
CREATE INDEX IX_Results_Exam ON StudentResults(ExamId);
CREATE INDEX IX_Results_Subject ON StudentResults(SubjectId);

CREATE TABLE InstitutionSettings (
    InstitutionId INT IDENTITY(1,1) PRIMARY KEY,

    InstitutionName NVARCHAR(200) NOT NULL,
    InstitutionCode NVARCHAR(50) NOT NULL UNIQUE,

    Address NVARCHAR(500) NULL,
    Phone NVARCHAR(30) NULL,
    Email NVARCHAR(150) NULL,
    Website NVARCHAR(200) NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL
);
CREATE TABLE SecuritySettings (
    SecuritySettingId INT IDENTITY(1,1) PRIMARY KEY,

    EnableTwoFactorAuth BIT NOT NULL DEFAULT 0,
    RequireStrongPasswords BIT NOT NULL DEFAULT 1,
    EnableSessionTimeout BIT NOT NULL DEFAULT 0,
    SessionTimeoutMinutes INT NOT NULL DEFAULT 30,

    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
CREATE TABLE NotificationSettings (
    NotificationSettingId INT IDENTITY(1,1) PRIMARY KEY,

    EnableNotifications BIT NOT NULL DEFAULT 1,
    EnableEmailNotifications BIT NOT NULL DEFAULT 1,
    EnableSMSNotifications BIT NOT NULL DEFAULT 0,

    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
CREATE TABLE PaymentSettings (
    PaymentSettingId INT IDENTITY(1,1) PRIMARY KEY,

    PaymentGateway NVARCHAR(50) NOT NULL,  -- razorpay, stripe, paypal
    Currency NVARCHAR(10) NOT NULL,        -- INR, USD, EUR

    ApiKey NVARCHAR(200) NULL,
    ApiSecret NVARCHAR(200) NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
CREATE VIEW vw_SystemSettings
AS
SELECT
    i.InstitutionName,
    i.InstitutionCode,
    i.Address,
    i.Phone,
    i.Email,
    i.Website,

    s.EnableTwoFactorAuth,
    s.RequireStrongPasswords,
    s.EnableSessionTimeout,
    s.SessionTimeoutMinutes,

    n.EnableNotifications,
    n.EnableEmailNotifications,
    n.EnableSMSNotifications,

    p.PaymentGateway,
    p.Currency
FROM InstitutionSettings i
CROSS JOIN SecuritySettings s
CROSS JOIN NotificationSettings n
CROSS JOIN PaymentSettings p
WHERE p.IsActive = 1;

INSERT INTO InstitutionSettings
(InstitutionName, InstitutionCode, Address, Phone, Email, Website)
VALUES
('College Management System', 'CMS-001',
 '123 Education Street, City',
 '+1234567890',
 'info@college.edu',
 'www.college.edu');

INSERT INTO SecuritySettings
(EnableTwoFactorAuth, RequireStrongPasswords, EnableSessionTimeout, SessionTimeoutMinutes)
VALUES (1, 1, 0, 30);

INSERT INTO NotificationSettings
(EnableNotifications, EnableEmailNotifications, EnableSMSNotifications)
VALUES (1, 1, 0);

INSERT INTO PaymentSettings
(PaymentGateway, Currency)
VALUES ('razorpay', 'INR');

CREATE TABLE Campuses (
    CampusId INT IDENTITY(1,1) PRIMARY KEY,
    CampusName NVARCHAR(150) NOT NULL,
    Location NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
CREATE TABLE Departments (
    DepartmentId INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(150) NOT NULL,
    CampusId INT NOT NULL,

    CONSTRAINT FK_Departments_Campuses
        FOREIGN KEY (CampusId) REFERENCES Campuses(CampusId)
);
CREATE TABLE Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    CourseName NVARCHAR(150) NOT NULL,
    DepartmentId INT NOT NULL,
    DurationYears INT NOT NULL,

    CONSTRAINT FK_Courses_Departments
        FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId)
);
CREATE TABLE Students (
    Id INT IDENTITY(1,1) PRIMARY KEY,

    StudentId NVARCHAR(30) NOT NULL UNIQUE,     -- STU-2024-001
    FullName NVARCHAR(150) NOT NULL,

    Email NVARCHAR(150) NOT NULL UNIQUE,
    Phone NVARCHAR(30) NULL,

    DateOfBirth DATE NOT NULL,
    Address NVARCHAR(300) NULL,

    CampusId INT NOT NULL,
    DepartmentId INT NOT NULL,
    CourseId INT NOT NULL,

    Batch NVARCHAR(10) NOT NULL,               -- 2024
    AdmissionDate DATE NOT NULL,

    Status NVARCHAR(20) NOT NULL DEFAULT 'active',  -- active, inactive, graduated

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_Students_Campuses
        FOREIGN KEY (CampusId) REFERENCES Campuses(CampusId),

    CONSTRAINT FK_Students_Departments
        FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId),

    CONSTRAINT FK_Students_Courses
        FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);
CREATE TABLE StudentGuardians (
    GuardianId INT IDENTITY(1,1) PRIMARY KEY,

    StudentId INT NOT NULL,
    GuardianName NVARCHAR(150) NOT NULL,
    GuardianPhone NVARCHAR(30) NULL,
    GuardianEmail NVARCHAR(150) NULL,

    CONSTRAINT FK_StudentGuardians_Students
        FOREIGN KEY (StudentId) REFERENCES Students(Id)
        ON DELETE CASCADE
);
CREATE INDEX IX_Students_Search
ON Students (FullName, StudentId, Email);

CREATE VIEW vw_StudentList
AS
SELECT
    s.Id,
    s.StudentId,
    s.FullName,
    s.Email,
    s.Phone,
    c.CourseName,
    s.Batch,
    s.Status
FROM Students s
JOIN Courses c ON s.CourseId = c.CourseId;



CREATE TABLE TransportRoutes (
    RouteId INT IDENTITY(1,1) PRIMARY KEY,

    RouteName NVARCHAR(150) NOT NULL,          -- Route A - North Zone
    VehicleNumber NVARCHAR(50) NOT NULL,       -- ABC-1234

    DriverName NVARCHAR(150) NOT NULL,
    DriverPhone NVARCHAR(30) NOT NULL,

    Capacity INT NOT NULL CHECK (Capacity > 0),
    CurrentStudents INT NOT NULL DEFAULT 0,

    Status NVARCHAR(20) NOT NULL DEFAULT 'active', -- active / inactive

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL
);
CREATE TABLE TransportRouteStops (
    StopId INT IDENTITY(1,1) PRIMARY KEY,

    RouteId INT NOT NULL,
    StopName NVARCHAR(150) NOT NULL,
    StopOrder INT NOT NULL,

    CONSTRAINT FK_RouteStops_Routes
        FOREIGN KEY (RouteId)
        REFERENCES TransportRoutes(RouteId)
        ON DELETE CASCADE,

    CONSTRAINT UQ_Route_StopOrder
        UNIQUE (RouteId, StopOrder)
);
CREATE TABLE StudentTransportAssignments (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,

    StudentId NVARCHAR(30) NOT NULL,   -- STU-2024-001 (FK if Students table exists)
    RouteId INT NOT NULL,

    PickupPoint NVARCHAR(150) NOT NULL,
    Fee DECIMAL(10,2) NOT NULL CHECK (Fee >= 0),

    Status NVARCHAR(20) NOT NULL DEFAULT 'active', -- active / inactive

    AssignedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_StudentTransport_Route
        FOREIGN KEY (RouteId)
        REFERENCES TransportRoutes(RouteId),

    CONSTRAINT UQ_Student_Route
        UNIQUE (StudentId, RouteId)
);
CREATE INDEX IX_TransportRoutes_Status
ON TransportRoutes (Status);

CREATE INDEX IX_StudentTransport_Status
ON StudentTransportAssignments (Status);

CREATE INDEX IX_StudentTransport_Student
ON StudentTransportAssignments (StudentId);
CREATE VIEW vw_TransportRoutes
AS
SELECT
    RouteId,
    RouteName,
    VehicleNumber,
    DriverName,
    DriverPhone,
    Capacity,
    CurrentStudents,
    Status
FROM TransportRoutes;
CREATE VIEW vw_StudentTransport
AS
SELECT
    sta.AssignmentId,
    sta.StudentId,
    tr.RouteName,
    sta.PickupPoint,
    sta.Fee,
    sta.Status
FROM StudentTransportAssignments sta
JOIN TransportRoutes tr ON sta.RouteId = tr.RouteId;
