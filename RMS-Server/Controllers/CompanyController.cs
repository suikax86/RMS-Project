using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using RMS_Server.Interfaces;
using RMS_Server.Models.Dtos;

namespace RMS_Server.Controllers;

[ApiController]
[Route("[controller]")]
public class CompanyController : ControllerBase
{
    private readonly IStoredProcedureService _storedProcedureService;
    
    public CompanyController(IStoredProcedureService storedProcedureService)
    {
        _storedProcedureService = storedProcedureService;
    }
    
    [HttpPost("register")]
    public IActionResult Register(CompanyRegisterRequest company)
    {
        var parameters = new SqlParameter[]
        {
            new ("@CompanyName", company.CompanyName),
            new ("@TaxIdentificationNumber", company.TaxIdentificationNumber),
            new ("@Representative", company.Representative),
            new ("@Address", company.Address),
            new ("@Email", company.Email)
        };

        try
        {
            _storedProcedureService.ExecuteStoredProcedure("RegisterCompany", parameters);
            return Ok("Company registered successfully!");
        }
        catch (SqlException ex)
        {
            if (ex.Number == 51000)
            {
                return Conflict(new { message = ex.Message });
            }
            else
            {
                throw;
            }
        }
    }
    
    [HttpPost("create-account")]
    public IActionResult CreateAccountForCompany(CompanyAccountRequest companyAccount)
    {
        var parameters = new SqlParameter[]
        {
            new ("@Username", companyAccount.Username),
            new ("@Password", companyAccount.Password),
            new ("@CompanyName", companyAccount.CompanyName),
            new ("@TaxIdentificationNumber", companyAccount.TaxIdentificationNumber)
        };

        try
        {
            _storedProcedureService.ExecuteStoredProcedure("CreateAccountForCompany", parameters);
            return Ok("Account created successfully!");
        }
        catch (SqlException ex)
        {
            if (ex.Number == 51000)
            {
                return Conflict(new { message = ex.Message });
            }
            else
            {
                throw;
            }
        }
    }
    
    [HttpPost("login")]
    public IActionResult Login(LogInRequest account)
    {
        var parameters = new SqlParameter[]
        {
            new ("@Username", account.Username),
            new ("@Password", account.Password)
        };

        try
        {
            var result = _storedProcedureService.ExecuteStoredProcedureWithResults("LoginUser", parameters);

            if (result.Rows.Count > 0)
            {
                return Ok(new { companyId = result.Rows[0]["CompanyID"], roleId = result.Rows[0]["RoleID"] });
            }
            else
            {
                return Unauthorized();
            }
        }
        catch (SqlException ex)
        {
            if (ex.Number == 51000)
            {
                return BadRequest(new { message = ex.Message });
            }
            else
            {
                throw;
            }
        }
    }
}
