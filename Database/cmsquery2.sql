use CampusAdmissionDB

CREATE TABLE Books (
    BookId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),

    Title NVARCHAR(200) NOT NULL,
    Author NVARCHAR(150) NOT NULL,
    ISBN NVARCHAR(20) NOT NULL,
    Category NVARCHAR(100) NOT NULL,

    TotalCopies INT NOT NULL CHECK (TotalCopies >= 0),
    AvailableCopies INT NOT NULL CHECK (AvailableCopies >= 0),

    Status NVARCHAR(20) NOT NULL
        CHECK (Status IN ('available', 'issued', 'reserved')),

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT PK_Books PRIMARY KEY (BookId),
    CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN),
    CONSTRAINT CK_Books_Copies CHECK (AvailableCopies <= TotalCopies)
);
CREATE TABLE BookIssues (
    BookIssueId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),

    BookId UNIQUEIDENTIFIER NOT NULL,
    StudentId NVARCHAR(50) NOT NULL,

    IssueDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,

    Status NVARCHAR(20) NOT NULL
        CHECK (Status IN ('issued', 'returned', 'overdue')),

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_BookIssues PRIMARY KEY (BookIssueId),

    CONSTRAINT FK_BookIssues_Book
        FOREIGN KEY (BookId)
        REFERENCES Books(BookId),

    CONSTRAINT CK_BookIssues_Dates CHECK (DueDate >= IssueDate)
);

CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO Roles (RoleName)
VALUES ('Admin'), ('Staff'), ('Student');

CREATE TABLE Users (
    UserId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),

    FullName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,

    RoleId INT NOT NULL,

    IsActive BIT NOT NULL DEFAULT 1,
    LastLoginAt DATETIME2 NULL,

    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT PK_Users PRIMARY KEY (UserId),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),

    CONSTRAINT FK_Users_Role
        FOREIGN KEY (RoleId)
        REFERENCES Roles(RoleId)
);
CREATE TABLE UserLoginHistory (
    LoginHistoryId BIGINT IDENTITY(1,1) PRIMARY KEY,

    UserId UNIQUEIDENTIFIER NOT NULL,
    LoginTime DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    IpAddress NVARCHAR(45) NULL,
    IsSuccess BIT NOT NULL,

    CONSTRAINT FK_LoginHistory_User
        FOREIGN KEY (UserId)
        REFERENCES Users(UserId)
);
CREATE TABLE UserTokens (
    TokenId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,

    Token NVARCHAR(255) NOT NULL,
    TokenType NVARCHAR(50) NOT NULL, -- ResetPassword, RefreshToken
    ExpiresAt DATETIME2 NOT NULL,

    IsUsed BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_UserTokens PRIMARY KEY (TokenId),

    CONSTRAINT FK_UserTokens_User
        FOREIGN KEY (UserId)
        REFERENCES Users(UserId)
);

SELECT *
INTO CampusAdmissionDB.dbo.BookIssues
FROM master.dbo.BookIssues;
