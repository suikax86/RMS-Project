USE RMS;
GO

-- Script drop
IF OBJECT_ID('usp_GetNearExpiryCompanies', 'P') IS NOT NULL
    DROP PROCEDURE usp_GetNearExpiryCompanies;
IF OBJECT_ID('usp_RenewContract', 'P') IS NOT NULL
    DROP PROCEDURE usp_RenewContract;
IF OBJECT_ID('Contracts', 'U') IS NOT NULL
BEGIN
    -- Drop foreign key constraint
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = 'RenewedContracts')
    BEGIN
        ALTER TABLE RenewedContracts DROP CONSTRAINT FK_ContractID;
    END
    
    -- Drop the Contracts table
    DROP TABLE Contracts;
END
IF OBJECT_ID('RenewedContracts', 'U') IS NOT NULL
BEGIN
    -- Drop the RenewedContracts table
    DROP TABLE RenewedContracts;
END
GO

-- Tạo bảng Contracts nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Contracts')
BEGIN
    CREATE TABLE Contracts (
        ContractID INT PRIMARY KEY IDENTITY,
        CompanyName NVARCHAR(255) NOT NULL,
        ExpiryDate DATE NOT NULL
    );
END
GO

-- Tạo bảng RenewedContracts
CREATE TABLE RenewedContracts (
    RenewalID INT PRIMARY KEY IDENTITY,
    ContractID INT NOT NULL,
    RenewalDate DATE NOT NULL,
    ExpiryDateNew DATE NOT NULL,
    CONSTRAINT FK_ContractID FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID)
);
GO

-- Stored procedure lấy danh sách các công ty gần hết hạn hợp đồng tuyển dụng
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
