DROP PROCEDURE IF EXISTS SaveJobPostingInfo;
DROP PROCEDURE IF EXISTS GetJobPostingDetails;
DROP PROCEDURE IF EXISTS JobPostingReview;
DROP FUNCTION IF EXISTS GetCompanyIdByTaxCode;
DROP PROCEDURE IF EXISTS GetJobPostingInfo;
GO

--Luu thong tin JobPosting duoc doanh nghiep cung cap
CREATE OR ALTER PROCEDURE SaveJobPostingInfo
    @Position NVARCHAR(255),
    @Quantity INT,
    @PostingTime NVARCHAR(255),
    @StartTime DATE,
    @EndTime DATE,
	@Requirements NVARCHAR(500),
	@CompanyID INT,
	@AdvertisingMethod NVARCHAR(255)
AS
BEGIN
	BEGIN TRY
		DECLARE @JobPostingID INT;


		INSERT INTO JobPosting (Position, Quantity, PostingTime, StartTime, EndTime, Requirements, CompanyID, FeedBack,Status)
		VALUES (@Position, @Quantity, @PostingTime, @StartTime, @EndTime, @Requirements, @CompanyID, null,0); -- Mac dinh Status = 0

		SET @JobPostingID = SCOPE_IDENTITY();


		INSERT INTO DetailJobPostingMethod (JobPostingID, MethodID)
		SELECT @JobPostingID, MethodID
		FROM AdvertisingMethod
		WHERE CHARINDEX(CONVERT(NVARCHAR, MethodID), @AdvertisingMethod) > 0;
	END TRY
    BEGIN CATCH
        THROW 51000, 'Error when inserting, try again', 1;
    END CATCH;
END;
GO
--DROP PROCEDURE JobPostingReview;
--DROP PROCEDURE SaveJobPostingInfo;

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
GO;

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
    
