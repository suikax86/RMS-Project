DROP PROCEDURE IF EXISTS RegisterCompany;
DROP PROCEDURE IF EXISTS RegisterApplicant;
DROP PROCEDURE IF EXISTS GetJobPostings;
DROP PROCEDURE IF EXISTS SaveJobPostingInfo;
DROP PROCEDURE IF EXISTS GetJobPostingDetails;
DROP PROCEDURE IF EXISTS JobPostingReview;
DROP FUNCTION IF EXISTS GetCompanyIdByTaxCode;
DROP PROCEDURE IF EXISTS GetJobPostingInfo;
DROP PROCEDURE IF EXISTS  SaveJobPostingInfo;
DROP PROCEDURE IF EXISTS p_getCVList;
DROP PROCEDURE IF EXISTS p_set_status;
DROP PROCEDURE IF EXISTS p_get_req_des;
DROP PROCEDURE IF EXISTS usp_GetNearExpiryCompanies;
DROP PROCEDURE IF EXISTS usp_RenewContract;
GO

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
GO

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
GO

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
GO

CREATE FUNCTION GetCompanyIdByTaxCode (@TaxCode NVARCHAR(255))
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

CREATE PROCEDURE p_getCVList
AS
BEGIN
    SELECT CVID, ApplicantID, JobPostingID, CVStatus
    FROM CV
END
GO


CREATE PROCEDURE p_set_status(@CVID INT, @status NVARCHAR(20))
AS
BEGIN
    IF EXISTS (SELECT CVID FROM CV WHERE CVID = @CVID)
        BEGIN
            UPDATE CV
            SET CVStatus = @status, SentDate = GETDATE()
            WHERE CVID = @CVID
        END
    ELSE
        BEGIN
            ;THROW 51000, 'The CV does not exist.', 1;
        END
END
GO

--mode = 0 lay description tu CV, mode = 1 lay reqs cua CV tu bang JobPosting
CREATE PROCEDURE p_get_req_des(@CVID INT, @mode INT)
AS
BEGIN
    IF EXISTS (SELECT CVID FROM CV WHERE CVID = @CVID)
        IF @mode = 0
            BEGIN
                SELECT CVDescription
                FROM CV
                WHERE CVID = @CVID
            END
        ELSE IF @mode = 1
            BEGIN
                SELECT JobPosting.Requirements
                FROM CV, JobPosting
                WHERE CV.CVID = @CVID AND CV.JobPostingID = JobPosting.JobPostingID
            END
        ELSE
            BEGIN
                ;THROW 51000, 'The CV does not exist.', 1;
            END
END
GO

CREATE OR ALTER PROCEDURE usp_GetNearExpiryCompanies
AS
BEGIN
    DECLARE @Today DATE = GETDATE();

    SELECT CompanyName, ExpiryDate
    FROM Contracts
    WHERE DATEDIFF(DAY, @Today, ExpiryDate) <= 3;
END;
GO

-- Stored procedure gia hạn hợp đồng cho công ty
CREATE OR ALTER PROCEDURE usp_RenewContract
    @CompanyName NVARCHAR(255),
    @AdditionalDays INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ExpiryDateNew DATE;

    -- Tính ngày gia hạn mới
    SELECT @ExpiryDateNew = DATEADD(DAY, @AdditionalDays, ExpiryDate)
    FROM Contracts
    WHERE CompanyName = @CompanyName;

    IF @ExpiryDateNew IS NOT NULL
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;

                -- Ghi nhận thông tin gia hạn vào bảng RenewedContracts
                INSERT INTO RenewedContracts (ContractID, RenewalDate, ExpiryDateNew)
                SELECT ContractID, GETDATE(), @ExpiryDateNew
                FROM Contracts
                WHERE CompanyName = @CompanyName;

                -- Cập nhật ngày hết hạn mới vào bảng Contracts
                UPDATE Contracts
                SET ExpiryDate = @ExpiryDateNew
                WHERE CompanyName = @CompanyName;

                -- Trả về ngày hết hạn mới dưới dạng dd/mm/yy
                SELECT FORMAT(@ExpiryDateNew, 'dd/MM/yy') AS NewExpiryDate;

                COMMIT TRANSACTION;
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;

                THROW;
            END CATCH;
        END
    ELSE
        BEGIN
            -- Ném lỗi nếu không tìm thấy công ty hoặc không thể gia hạn hợp đồng
            THROW 51000, 'Company not found or unable to renew contract.', 1;
        END
END;
GO

-- Tạo stored procedure để lấy danh sách các công ty gần hết hạn tuyển dụng
CREATE OR ALTER PROCEDURE GetNearExpiryCompanies
AS
BEGIN
    SELECT JP.CompanyID, CompanyName, EndTime
    FROM JobPosting JP
             INNER JOIN Companies C ON JP.CompanyID = C.CompanyID
    WHERE DATEDIFF(DAY, GETDATE(), EndTime) <= 3 AND JP.Status = 1; -- Chỉ lấy các công ty đang hoạt động và gần hết hạn
END
GO
-- Tạo stored procedure để gia hạn hợp đồng tuyển dụng cho một công ty cụ thể
CREATE OR ALTER PROCEDURE RenewContract
    @CompanyID INT,
    @AdditionalDays INT
AS
BEGIN
    BEGIN TRY
        DECLARE @NewEndTime DATE;

        -- Lấy thời gian kết thúc hiện tại của hợp đồng
        SELECT @NewEndTime = EndTime
        FROM JobPosting
        WHERE CompanyID = @CompanyID AND Status = 1;

        -- Gia hạn thêm số ngày được chỉ định
        SET @NewEndTime = DATEADD(DAY, @AdditionalDays, @NewEndTime);

        -- Update thời gian kết thúc mới vào hợp đồng
        UPDATE JobPosting
        SET EndTime = @NewEndTime
        WHERE CompanyID = @CompanyID AND Status = 1;

        -- Trả về kết quả thành công
        SELECT 'Gia hạn thành công. Thời gian kết thúc mới là ' + CONVERT(NVARCHAR, @NewEndTime) AS RenewalResult;
    END TRY
    BEGIN CATCH
        -- Trả về lỗi nếu có lỗi xảy ra
        THROW;
    END CATCH
END
GO
