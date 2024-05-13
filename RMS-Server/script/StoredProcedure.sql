-- A: Quy trình đăng ký công ty


--B: Quy trình đăng tuyển dụng
--lay ra thong tin chi tiet cua thong tin tuyen dung
CREATE OR ALTER PROCEDURE GetJobPostingDetails
@JobPostingID INT
AS
BEGIN
    SELECT jpt.*, am.MethodName, am.Price * jpt.PostingTime AS TotalPrice
    FROM JobPosting jpt
             INNER JOIN DetailJobPostingMethod djpt ON jpt.JobPostingID = djpt.JobPostingID
             INNER JOIN AdvertisingMethod am ON djpt.MethodID = am.MethodID
    WHERE jpt.JobPostingID = @JobPostingID;
END;
GO

--Duyet JobPosting - nhan vien
CREATE OR ALTER PROCEDURE JobPostingReview
    @JobPostingID INT,
    @ApproveOrNot INT,
    @FeedBack NVARCHAR(300) = null
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM JobPosting WHERE JobPostingID = @JobPostingID)
            BEGIN
                IF @ApproveOrNot = 1
                    UPDATE JobPosting SET Status = @ApproveOrNot WHERE JobPostingID = @JobPostingID;
                ELSE IF @ApproveOrNot = 2
                    UPDATE JobPosting SET Status = @ApproveOrNot, FeedBack = @FeedBack  WHERE JobPostingID = @JobPostingID;
            END
        ELSE
            BEGIN
                THROW 51000, 'Invalid JobPostingID. The JobPostingID does not exist.', 1;
            END
    END TRY
    BEGIN CATCH
        THROW 51000, 'Error when updating, try again', 1;
    END CATCH;
END;
GO;

CREATE OR ALTER FUNCTION GetCompanyIdByTaxCode (@TaxCode NVARCHAR(255))
    RETURNS INT
AS
BEGIN
    DECLARE @CompanyId INT

    SELECT @CompanyId = CompanyID
    FROM Companies
    WHERE TaxIdentificationNumber = @TaxCode

    IF @CompanyId IS NULL
        BEGIN
            -- Không tìm thấy mã số thuế, trả về giá trị NULL
            SET @CompanyId = NULL
        END

    RETURN @CompanyId
END;
GO
CREATE OR ALTER PROCEDURE GetJobPostingInfo
@TaxCode NVARCHAR(255)
AS
BEGIN
    DECLARE @CompanyId INT

    SET @CompanyId = dbo.GetCompanyIdByTaxCode(@TaxCode)

    IF @CompanyId IS NULL
        BEGIN
            THROW 51000, 'Company not found for Tax Code', 1;
        END
    ELSE
        BEGIN
            BEGIN TRY
                SELECT * FROM JobPosting jpt WHERE jpt.CompanyID = @CompanyId
            END TRY
            BEGIN CATCH
                THROW 51000, 'Error when querying data, please try again', 1;
            END CATCH;
        END
END;
GO
--Luu thong tin job posting
CREATE OR ALTER PROCEDURE SaveJobPostingInfo
    @Position NVARCHAR(255),
    @Quantity INT,
    @PostingTime NVARCHAR(255),
    @StartTime DATE,
    @EndTime DATE,
    @Requirements NVARCHAR(500),
    @TaxCode NVARCHAR(255),
    @AdvertisingMethod NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        DECLARE @JobPostingID INT;
        DECLARE @CompanyID INT;

        SET @CompanyID = dbo.GetCompanyIdByTaxCode(@TaxCode)

        IF @CompanyID IS NULL
            BEGIN
                THROW 51000, 'Company not found for Tax Code ', 1;
                return;
            END
        ELSE
            BEGIN
                INSERT INTO JobPosting (Position, Quantity, PostingTime, StartTime, EndTime, Requirements, CompanyID, FeedBack, Status)
                VALUES (@Position, @Quantity, @PostingTime, @StartTime, @EndTime, @Requirements, @CompanyID, NULL, 0); -- Mặc định Status = 0

                SET @JobPostingID = SCOPE_IDENTITY();

                INSERT INTO DetailJobPostingMethod (JobPostingID, MethodID)
                SELECT @JobPostingID, MethodID
                FROM AdvertisingMethod
                WHERE CHARINDEX(CONVERT(NVARCHAR, MethodID), @AdvertisingMethod) > 0;
            END
    END TRY
    BEGIN CATCH
        THROW 51000, 'Error when inserting, try again', 1;
    END CATCH;
END;
GO
--C: Quy trình nộp hồ sơ tuyển dụng
-- Đăng ký ứng viên
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
GO
--
CREATE OR ALTER PROCEDURE CheckApplicantExists
@IdentityCardNumber NVARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Applicant WHERE IdentityCardNumber = @IdentityCardNumber)
        BEGIN
            THROW 51000, 'No applicant with the provided identity card number exists in the system.', 1;
        END
END;
GO
-- Lấy thông tin ứng viên
CREATE OR ALTER PROCEDURE GetApplicantInfo
@IdentityCardNumber NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Applicant WHERE IdentityCardNumber = @IdentityCardNumber)
        BEGIN
            SELECT ApplicantName, IdentityCardNumber, Gender, Email, ApplicantAddress, DOB FROM Applicant WHERE IdentityCardNumber = @IdentityCardNumber;
        END
    ELSE
        BEGIN
            THROW 51000, 'No applicant with the provided identity card number exists in the system.', 1;
        END
END;
GO
-- Lấy thông tin job và company
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

-- Lưu thông tin Form của ứng viên
CREATE OR ALTER PROCEDURE InsertFormSubmission
    @ApplicantID INT,
    @JobPostingID INT,
    @DocumentName NVARCHAR(255),
    @Url NVARCHAR(255),
    @SubmissionDate DATE
AS
BEGIN
    -- Check if ApplicantID exists
    IF NOT EXISTS (SELECT 1 FROM Applicant WHERE ApplicantID = @ApplicantID)
        BEGIN
            THROW 51000, 'Applicant ID does not exist in the system.', 1;
        END

    -- Check if JobPostingID exists
    IF NOT EXISTS (SELECT 1 FROM JobPosting WHERE JobPostingID = @JobPostingID)
        BEGIN
            THROW 51000, 'Job Posting ID does not exist in the system.', 1;
        END

    
    INSERT INTO Form (ApplicantID, JobPostingID, DocumentName, Url, SubmissionDate)
    VALUES (@ApplicantID, @JobPostingID, @DocumentName, @Url, @SubmissionDate)
END;
