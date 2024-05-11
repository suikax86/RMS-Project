-- Script drop
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'JobPosting')
    BEGIN
          ALTER TABLE JobPosting DROP CONSTRAINT IF EXISTS FK_JobPosting_Companies;
    END
GO;

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'CV')
    BEGIN
        ALTER TABLE CV DROP CONSTRAINT IF EXISTS FK_CV_PostForm;
    END       
GO;

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'DetailJobPostingMethod')
    BEGIN
        ALTER TABLE DetailJobPostingMethod DROP CONSTRAINT IF EXISTS FK_DetailJobPostingMethod_AdvertisingMethod;
        ALTER TABLE DetailJobPostingMethod DROP CONSTRAINT IF EXISTS FK_DetailJobPostingMethod_JobPosting;
    END
GO;

DROP TABLE IF EXISTS Applicant;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS DetailJobPostingMethod;
DROP TABLE IF EXISTS AdvertisingMethod;
DROP TABLE IF EXISTS JobPosting;
DROP TABLE IF EXISTS Companies;

GO;

CREATE TABLE Roles
(
    RoleID INT PRIMARY KEY ,
    RoleName NVARCHAR(50) NOT NULL
)
GO;

INSERT INTO Roles(RoleID, RoleName) VALUES (1, 'Admin');
INSERT INTO Roles(RoleID, RoleName) VALUES (2, 'Employee');
INSERT INTO Roles(RoleID, RoleName) VALUES (3, 'Company');
INSERT INTO Roles(RoleID, RoleName) VALUES (4, 'Candidate');
GO;


CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY,
    CompanyName NVARCHAR(255) NOT NULL,
    TaxIdentificationNumber NVARCHAR(255) NOT NULL,
    Representative NVARCHAR(255) NOT NULL,
    Address NVARCHAR(255),
    Email NVARCHAR(255),
    UNIQUE (CompanyName, TaxIdentificationNumber)
);
GO;

CREATE TABLE Employees (
     EmployeeID INT PRIMARY KEY IDENTITY,
     EmployeeName NVARCHAR(255) NOT NULL,
     Address NVARCHAR(255) NOT NULL,
     DOB DATE NOT NULL,
     Email NVARCHAR(255),
     Phone NVARCHAR(10)
);
GO;

CREATE TABLE Applicant (
    ApplicantID INT PRIMARY KEY IDENTITY,
    ApplicantName NVARCHAR(24) NOT NULL,
    IdentityCardNumber NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    ApplicantAddress NVARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    UNIQUE (IdentityCardNumber)
);
GO;


CREATE TABLE AdvertisingMethod
(
    MethodID INT PRIMARY KEY IDENTITY,
    MethodName NVARCHAR(255) NOT NULL,
    Price DECIMAL(13,3) NOT NULL
);
GO;

INSERT INTO AdvertisingMethod(MethodName, Price) VALUES (N'Đăng tuyển trên báo giấy', 300000);
INSERT INTO AdvertisingMethod(MethodName, Price) VALUES (N'Đăng trên các trang mạng', 400000);
INSERT INTO AdvertisingMethod(MethodName, Price) VALUES (N'Banner quảng cáo', 500000);
GO;

CREATE TABLE JobPosting
(
    JobPostingID INT PRIMARY KEY IDENTITY,
    CompanyID INT,
    Position NVARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    PostingTime INT NOT NULL,
    StartTime DATE NOT NULL,
    EndTime DATE NOT NULL,
    Requirements NVARCHAR(500) NOT NULL,
    FeedBack NVARCHAR(300),
    --status la thong tin tuyen dung da duyet (1), khong duoc duyet (0), chua doc (-1)
    Status INT NOT NULL
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);
GO;

CREATE TABLE DetailJobPostingMethod
(
    JobPostingID INT,
    MethodID INT,
    PRIMARY KEY(JobPostingID, MethodID),
    FOREIGN KEY (JobPostingID) REFERENCES JobPosting(JobPostingID),
    FOREIGN KEY (MethodID) REFERENCES AdvertisingMethod(MethodID)
);
GO


