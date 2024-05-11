USE RMS
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'CV')
    BEGIN
          ALTER TABLE CV DROP CONSTRAINT IF EXISTS FK_CV_JobPosting;
		  ALTER TABLE CV DROP CONSTRAINT IF EXISTS FK_CV_Applicant;
    END

	
DROP PROCEDURE IF EXISTS p_getCVList
DROP PROCEDURE IF EXISTS p_set_status
DRop PROCEDure IF EXists p_get_req_des
GO



--Lay cac cv 
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



INSERT INTO CV VALUES(1, 1, 1, 'p1','1 Năm kinh nghiệm', 'pending', NULL, NULL)