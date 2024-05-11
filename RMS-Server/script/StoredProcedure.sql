-- A: Quy trình đăng ký thành viên
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

--B: Quy trình đăng tuyển dụng