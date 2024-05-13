DROP PROCEDURE IF EXISTS RegisterCompany;
DROP PROCEDURE IF EXISTS RegisterApplicant;
DROP PROCEDURE IF EXISTS GetJobPostings;
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

CREATE OR ALTER PROCEDURE GetJobPostings
AS
BEGIN
    BEGIN TRY
        SELECT jp.JobPostingID, c.CompanyName, jp.Position, jp.Quantity, jp.PostingTime, jp.StartTime, jp.EndTime, jp.Requirements, c.Address
        FROM JobPosting jp
                 JOIN Companies c ON jp.CompanyID = c.CompanyID
        WHERE jp.Status = 1
    END TRY
    BEGIN CATCH
        THROW 51000, 'Error when querying data, please try again', 1;
    END CATCH;
END;
GO;


