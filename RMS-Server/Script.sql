-- Script drop
-- ALTER TABLE Accounts DROP CONSTRAINT IF EXISTS FK_Accounts_Roles;
-- ALTER TABLE Roles DROP CONSTRAINT IF EXISTS FK_Companies_Accounts;
-- ALTER TABLE Companies DROP CONSTRAINT IF EXISTS FK_Companies_Accounts;
-- ALTER TABLE Applicant DROP CONSTRAINT IF EXISTS FK_Applicant_Accounts;
--ALTER TABLE PostForm DROP CONSTRAINT IF EXISTS FK_PostForm_Company;
--ALTER TABLE JobPosting DROP CONSTRAINT IF EXISTS FK_JobPosting_PostForm;
--ALTER TABLE JobPosting DROP CONSTRAINT IF EXISTS FK_JobPosting_NV;

DROP TABLE IF EXISTS Accounts
DROP TABLE IF EXISTS Companies;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Applicant;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS PostForm;
DROP TABLE IF EXISTS JobPosting;
DROP PROCEDURE IF EXISTS RegisterCompany;
DROP PROCEDURE IF EXISTS RegisterApplicant;
DROP PROCEDURE IF EXISTS CreateAccountForCompany;
DROP PROCEDURE IF EXISTS LoginUser;
DROP PROCEDURE IF EXISTS HashPassword;
GO;
CREATE TABLE Roles
(
    RoleID INT PRIMARY KEY ,
    RoleName NVARCHAR(50) NOT NULL
)

INSERT INTO Roles(RoleID, RoleName) VALUES (1, 'Admin');
INSERT INTO Roles(RoleID, RoleName) VALUES (2, 'Employee');
INSERT INTO Roles(RoleID, RoleName) VALUES (3, 'Company');
INSERT INTO Roles(RoleID, RoleName) VALUES (4, 'Candidate');
GO;

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY,
    Username NVARCHAR(255) NOT NULL,
    PasswordHash NVARCHAR(128) NOT NULL,
    PasswordSalt NVARCHAR(128) NOT NULL,
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

GO;
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY,
    AccountID INT,
    CompanyName NVARCHAR(255) NOT NULL,
    TaxIdentificationNumber NVARCHAR(255) NOT NULL,
    Representative NVARCHAR(255) NOT NULL,
    Address NVARCHAR(255),
    Email NVARCHAR(255),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
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
    AccountID INT,
    ApplicantName NVARCHAR(24) NOT NULL,
    IdentityCardNumber NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    ApplicantAddress NVARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    UNIQUE (IdentityCardNumber)
);
GO;

-- Tạo bảng phiếu đăng tuyển
CREATE TABLE PostForm (
    FormID INT PRIMARY KEY IDENTITY,
    CompanyID INT NOT NULL,
    Position NVARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    StartTime DATE NOT NULL,
    EndTime DATE NOT NULL,
    Requirements NVARCHAR(255)
    CONSTRAINT FK_PostForm_Company FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);
GO;


--- Tạo bảng phiếu quảng cáo
CREATE TABLE JobPosting (
    JobPostingID INT PRIMARY KEY IDENTITY,
    NV_ID INT NOT NULL,
    PostTime DATE NOT NULL,PostingMethod NVARCHAR(255) NOT NULL,
    PostFormID INT NOT NULL,
    PostStatus NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_JobPosting_PostForm FOREIGN KEY (PostFormID) REFERENCES PostForm(FormID),
    CONSTRAINT FK_JobPosting_NV FOREIGN KEY (NV_ID) REFERENCES Employees(EmployeeID)
);
GO;

CREATE OR ALTER PROCEDURE RegisterApplicant
    @ApplicantName NVARCHAR(24),
    @IdentityCardNumber NVARCHAR(255),
    @Gender NVARCHAR(255),
    @Email NVARCHAR(255),
    @ApplicantAddress NVARCHAR(255),
    @DOB DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Applicant WHERE IdentityCardNumber = @IdentityCardNumber)
        BEGIN
            INSERT INTO Applicant(ApplicantName, IdentityCardNumber, Gender, Email, ApplicantAddress, DOB)
            VALUES (@ApplicantName, @IdentityCardNumber, @Gender, @Email, @ApplicantAddress, @DOB);
        END
    ELSE
        BEGIN
            THROW 51000, 'An applicant with the same identity card number already exists.', 1;
        END
END
GO;



CREATE OR ALTER PROCEDURE RegisterCompany
    @CompanyName NVARCHAR(255),
    @TaxIdentificationNumber NVARCHAR(255),
    @Representative NVARCHAR(255),
    @Address NVARCHAR(255),
    @Email NVARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Companies WHERE CompanyName = @CompanyName AND TaxIdentificationNumber = @TaxIdentificationNumber)
        BEGIN
            INSERT INTO Companies(CompanyName, TaxIdentificationNumber, Representative, Address, Email)
            VALUES (@CompanyName, @TaxIdentificationNumber, @Representative, @Address, @Email);
        END
    ELSE
        BEGIN
            THROW 51000, 'A company with the same name and tax identification number already exists.', 1;
        END
END
GO;

CREATE OR ALTER PROCEDURE HashPassword
    @Password NVARCHAR(128),
    @Salt UNIQUEIDENTIFIER = NULL OUTPUT,
    @HashedPassword NVARCHAR(64) OUTPUT
AS
BEGIN
    IF @Salt IS NULL
        SET @Salt = NEWID();

    SET @HashedPassword = CONVERT(NVARCHAR(64), HASHBYTES('SHA2_256', CONCAT(@Password, CAST(@Salt AS NVARCHAR(36)))), 2);
END
GO;

CREATE OR ALTER PROCEDURE CreateAccountForCompany
    @Username NVARCHAR(255),
    @Password NVARCHAR(128),
    @CompanyName NVARCHAR(255),
    @TaxIdentificationNumber NVARCHAR(255)
AS
BEGIN
    DECLARE @CompanyID INT;
    DECLARE @Salt UNIQUEIDENTIFIER;
    DECLARE @HashedPassword NVARCHAR(64);

    EXEC HashPassword @Password, @Salt OUTPUT, @HashedPassword OUTPUT;

    SELECT @CompanyID = CompanyID FROM Companies
    WHERE CompanyName = @CompanyName AND TaxIdentificationNumber = @TaxIdentificationNumber;

    IF @CompanyID IS NOT NULL
        BEGIN
            INSERT INTO Accounts(Username, PasswordHash, PasswordSalt, RoleID)
            VALUES (@Username, @HashedPassword, CAST(@Salt AS NVARCHAR(36)), 3);

            UPDATE Companies SET AccountID = SCOPE_IDENTITY() WHERE CompanyID = @CompanyID;
        END
    ELSE
        BEGIN
            THROW 51000, 'The company does not exist.', 1;
        END
END
GO;

CREATE OR ALTER PROCEDURE LoginUser
    @Username NVARCHAR(255),
    @Password NVARCHAR(128)
AS
BEGIN
    DECLARE @Salt UNIQUEIDENTIFIER;
    DECLARE @StoredHashedPassword NVARCHAR(64);
    DECLARE @ProvidedHashedPassword NVARCHAR(64);

    SELECT @Salt = CAST(PasswordSalt AS UNIQUEIDENTIFIER), @StoredHashedPassword = PasswordHash FROM Accounts WHERE Username = @Username;

    IF @Salt IS NULL
        BEGIN
            THROW 51000, 'The username does not exist.', 1;
            RETURN;
        END

    EXEC HashPassword @Password, @Salt OUTPUT, @ProvidedHashedPassword OUTPUT;

    IF @StoredHashedPassword != @ProvidedHashedPassword
        BEGIN
            THROW 51000, 'The password is incorrect.', 1;
            RETURN;
        END

    SELECT A.AccountID, A.RoleID, C.CompanyID FROM Accounts A
                                                       LEFT JOIN Companies C ON A.AccountID = C.AccountID
    WHERE A.Username = @Username;
END
GO;


