use RMS

 IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'PostForm')
    BEGIN
        ALTER TABLE PostForm DROP CONSTRAINT FK_PostForm_Company;
    END

 IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'Check_CV')
    BEGIN
        ALTER TABLE Check_CV DROP CONSTRAINT FK_CheckCV_CV;
    END

 IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'CV')
    BEGIN
        ALTER TABLE CV DROP CONSTRAINT FK_CV_PostForm;
    END

DROP TABLE IF EXISTS Company
DROP TABLE IF EXISTS PostForm
DROP TABLE IF EXISTS CV
DROP TABLE IF EXISTS Check_CV
DROP PROCEDURE IF EXISTS p_getCVList;
DROP PROCEDURE IF EXISTS p_process_cv;
DROP PROCEDURE IF EXISTS p_getcvlist_company;
DROP PROCEDURE IF EXISTS p_getcv_description;
DROP PROCEDURE IF EXISTS p_getaprroved_company;
DROP PROCEDURE IF EXISTS p_update_status;
GO


CREATE TABLE Company (
	CompanyID INT PRIMARY KEY,
	CompanyName NVARCHAR(255) NOT NULL,
	TaxCode INT NOT NULL,
	Representative NVARCHAR(255) NOT NULL,
	CompanyAddress NVARCHAR(255) NOT NULL,
	Email NVARCHAR(255) NOT NULL
)
GO

CREATE TABLE PostForm (
	FormID INT PRIMARY KEY,
	CompanyID INT NOT NULL,
	Position NVARCHAR(255) NOT NULL,
	Quantity INT NOT NULL,
	StartTime DATE NOT NULL,
	EndTime DATE NOT NULL,
	Requirements NVARCHAR(255)
	CONSTRAINT FK_PostForm_Company FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
)
GO

CREATE TABLE CV (
	CV_ID INT PRIMARY KEY,
	ApplicantID INT NOT NULL,
	Position NVARCHAR(255) NOT NULL,
	Describe NVARCHAR(255),
	FormID INT
	CONSTRAINT FK_CV_PostForm FOREIGN KEY (FormID) REFERENCES PostForm(FormID)
)
GO

--- Tạo bảng check CV ứng viên
CREATE TABLE Check_CV (
	Check_ID INT PRIMARY KEY,
	CV_ID INT NOT NULL,
	NV_ID INT NOT NULL,
	CV_Priority NVARCHAR(255) NOT NULL,
	CV_Feedback NVARCHAR(255),
	CV_Status NVARCHAR(255),
	SentDate DATE
	CONSTRAINT FK_CheckCV_CV FOREIGN KEY (CV_ID) REFERENCES CV(CV_ID),
)
GO



CREATE PROCEDURE p_getCVList
(
	@status VARCHAR(20)
)
AS
BEGIN
	IF @status IS NOT NULL
		BEGIN
			SELECT DISTINCT CV.CV_ID, CV.ApplicantID, CV.Position, CV.Describe, CV.FormID, Check_CV.CV_Status, Check_CV.CV_Feedback, Check_CV.CV_Priority
			FROM Check_CV, CV
			WHERE CV_Status = @status AND CV.CV_ID = Check_CV.CV_ID;
		END
	ELSE
		BEGIN
			;THROW 51000, 'This status does not exist', 1;
		END
END
GO


--UPDATE trang thai CV sau khi duoc gui boi nhan vien
CREATE PROCEDURE p_process_cv
(
	@CVID INT,
	@status varchar(255)
)
AS
BEGIN
	IF EXISTS (SELECT CV_ID FROM Check_CV WHERE CV_ID = @CVID)
		BEGIN
			UPDATE Check_CV
			SET CV_Status = @status, SentDate = GETDATE()
			WHERE CV_ID = @CVID
		END
	ELSE
		BEGIN
			;THROW 51000, 'The CV does not exist.', 1;
		END
END
GO

--Lay danh sach CV can duyet cua doanh nghiep

CREATE PROCEDURE p_getcvlist_company
(
	@CompanyID INT
)
AS
BEGIN
	IF EXISTS(SELECT CompanyID FROM Company WHERE CompanyID = @CompanyID)
		BEGIN
			SELECT DISTINCT CV.CV_ID, CV.ApplicantID, CV.Position, CV.Describe, CV.FormID, Check_CV.CV_Status, Check_CV.CV_Feedback, Check_CV.CV_Priority
			FROM Check_CV, CV, PostForm
			WHERE DATEDIFF(DAY, Check_CV.SentDate, GETDATE()) <= 10 and Check_CV.CV_Status = 'Da xu ly' 
				and CV.FormID = PostForm.FormID and PostForm.CompanyID = @CompanyID
		END
	ELSE
		BEGIN
			;THROW 51000, 'The company does not exist.', 1;
		END
END
GO

--Lay requirements cua 1 cv



--Lay describe/requirements cua 1 cv

CREATE PROCEDURE p_getcv_description
(
	@CVID INT,
	@mode INT
)
AS
BEGIN
	IF EXISTS(SELECT CV_ID FROM CV WHERE CV_ID = @CVID)
		BEGIN
			IF @mode = 0
				BEGIN
					SELECT Describe
					FROM CV
					WHERE CV.CV_ID = @CVID
				END
			ELSE IF @mode = 1
				BEGIN
					SELECT Requirements
					FROM PostForm, CV
					WHERE CV.FormID = PostForm.FormID AND CV.CV_ID = @CVID
				END
		END
	ELSE
		BEGIN
			;THROW 51000, 'The CV does not exist.', 1;
		END
END
GO

--UPDATE trang thai ho so khi duyet

CREATE PROCEDURE p_update_status
(
	@CVID INT,
	@status NVARCHAR(255),
	@feedback NVARCHAR(255)
)
AS
BEGIN
	IF EXISTS(SELECT CV_ID FROM Check_CV WHERE CV_ID = @CVID)
		BEGIN
			UPDATE Check_CV
			SET CV_Status = @status, CV_Feedback = @feedback
			WHERE CV_ID = @CVID
		END
	ELSE
		BEGIN
			;THROW 51000, 'The CV does not exist.', 1;
		END
END
GO

--Lay danh sanh cac ho so duoc phan hoi
CREATE PROCEDURE p_getaprroved_company
(
	@CompanyID INT
)
AS
BEGIN
	IF EXISTS(SELECT CompanyID FROM Company WHERE CompanyID = @CompanyID)
		BEGIN
			SELECT DISTINCT CV.CV_ID, CV.ApplicantID, CV.Position, CV.Describe, CV.FormID, Check_CV.CV_Status, Check_CV.CV_Feedback, Check_CV.CV_Priority
			FROM Check_CV, CV, PostForm
			WHERE Check_CV.CV_Status = 'Da phan hoi' 
				and CV.FormID = PostForm.FormID and PostForm.CompanyID = @CompanyID
		END
	ELSE
		BEGIN
			;THROW 51000, 'The company does not exist.', 1;
		END
END
GO


INSERT INTO Company (CompanyID, CompanyName, TaxCode, Representative, CompanyAddress, Email)
VALUES (1, 'Company A', 123456, 'John Doe', '123 Street, City', 'companyA@example.com'),
       (2, 'Company B', 789012, 'Jane Smith', '456 Avenue, City', 'companyB@example.com');

-- Insert data into PostForm
INSERT INTO PostForm (FormID, CompanyID, Position, Quantity, StartTime, EndTime, Requirements)
VALUES (1, 1, 'Software Developer', 3, '2024-05-01', '2024-06-01', 'C#, SQL, .NET'),
       (2, 2, 'Data Analyst', 2, '2024-05-15', '2024-06-15', 'SQL, Python, R');
-- Insert data into CV
INSERT INTO CV (CV_ID, ApplicantID, Position, Describe, FormID)
VALUES (1, 1, 'Software Developer', 'Experienced in C# and SQL', 1),
       (2, 2, 'Data Analyst', 'Proficient in SQL and Python', 2);

-- Insert data into Check_CV
INSERT INTO Check_CV (Check_ID,CV_ID, NV_ID, CV_Priority, CV_Feedback, CV_Status, SentDate)
VALUES (1, 1, 1, 'High', 'Great skills', 'Dang xu ly', '2024-05-10'),
       (2, 2, 2, 'Medium', 'Good potential', 'Dang xu ly', '2024-05-11');



