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
DROP TABLE IF EXISTS AdvertisingMethod
DROP PROCEDURE IF EXISTS RegisterCompany;
DROP PROCEDURE IF EXISTS RegisterApplicant;
DROP PROCEDURE IF EXISTS CreateAccountForCompany;
DROP PROCEDURE IF EXISTS LoginUser;
DROP PROCEDURE IF EXISTS HashPassword;
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


