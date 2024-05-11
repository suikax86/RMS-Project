using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using RMS_Server.Interfaces;
using RMS_Server.Models.Dtos;

namespace RMS_Server.Controllers;

[ApiController]
[Route("[controller]")]
public class CompanyController(IStoredProcedureService storedProcedureService) : ControllerBase
{
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
            storedProcedureService.ExecuteStoredProcedure("RegisterCompany", parameters);
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
}
