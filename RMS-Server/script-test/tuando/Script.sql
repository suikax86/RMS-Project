USE RMS;
GO

DROP TABLE IF EXISTS AdvertisingMethod
DROP TABLE IF EXISTS JobPosting;
DROP TABLE IF EXISTS DetailJobPostingMethod;
DROP PROCEDURE IF EXISTS SaveJobPostingInfo;
DROP PROCEDURE IF EXISTS GetJobPostingDetails;
DROP PROCEDURE IF EXISTS JobPostingReview;
GO

CREATE TABLE AdvertisingMethod
(
	MethodID INT PRIMARY KEY IDENTITY,
	MethodName NVARCHAR(255) NOT NULL,
	Price DECIMAL(13,3) NOT NULL
);

INSERT INTO AdvertisingMethod(MethodName, Price) VALUES ('Đăng tuyển trên báo giấy', 300000);
INSERT INTO AdvertisingMethod(MethodName, Price) VALUES ('Đăng trên các trang mạng', 400000);
INSERT INTO AdvertisingMethod(MethodName, Price) VALUES ('Banner quảng cáo', 500000);

CREATE TABLE JobPosting
(
	JobPostingID INT PRIMARY KEY IDENTITY,
	Position NVARCHAR(255) NOT NULL,
	Quantity INT NOT NULL,
	PostingTime INT NOT NULL,
	StartTime DATE NOT NULL,
	EndTime DATE NOT NULL,
	Requirements NVARCHAR(500) NOT NULL,
	CompanyID INT,
	FeedBack NVARCHAR(300),
	--status la thong tin tuyen dung da duyet (1), khong duoc duyet (0), chua doc (-1)
	Status INT NOT NULL
);

CREATE TABLE DetailJobPostingMethod
(
	JobPostingID INT,
	MethodID INT,
	PRIMARY KEY(JobPostingID, MethodID)
);
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
		VALUES (@Position, @Quantity, @PostingTime, @StartTime, @EndTime, @Requirements, @CompanyID, null,-1); -- Mac dinh Status = -1

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
				ELSE IF @ApproveOrNot = 0
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
