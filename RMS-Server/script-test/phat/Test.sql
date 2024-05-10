
-- Test procedure usp_GetNearExpiryCompanies
EXEC usp_GetNearExpiryCompanies;

-- Test procedure usp_RenewContract
DECLARE @NewExpiryDate NVARCHAR(10);
EXEC usp_RenewContract @CompanyName = 'Company A', @AdditionalDays = 7;
