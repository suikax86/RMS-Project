using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using RMS_Server.Interfaces;
using RMS_Server.Models.Dtos;

namespace RMS_Server.Controllers;

[ApiController]
[Route("[controller]")]
public class ApplicantController(IStoredProcedureService storedProcedureService) : ControllerBase
{
    [HttpPost("register")]
    public IActionResult Register(ApplicantRegisterRequest applicant)
    {
        var parameters = new SqlParameter[]
        {
            new("@ApplicantName", applicant.ApplicantName),
            new("@IdentityCardNumber", applicant.IdentityCardNumber),
            new("@Gender", applicant.Gender),
            new("@Email", applicant.Email),
            new("@ApplicantAddress", applicant.ApplicantAddress),
            new("@DOB", applicant.DOB)
        };
        try
        {
            storedProcedureService.ExecuteStoredProcedure("RegisterApplicant", parameters);
            return Ok("Applicant registered successfully!");
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
    
    [HttpGet("check")]
    public IActionResult CheckApplicantExists(string identityCardNumber)
    {
        var parameters = new SqlParameter[]
        {
            new("@IdentityCardNumber", identityCardNumber)
        };
        try
        {
            storedProcedureService.ExecuteStoredProcedure("CheckApplicantExists", parameters);
            return Ok("Applicant exists!");
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
    
    [HttpGet]
    public IActionResult GetApplicant(string identityCardNumber)
    {
        var parameters = new SqlParameter[]
        {
            new("@IdentityCardNumber", identityCardNumber)
        };
        try
        {
            var db = storedProcedureService.ExecuteStoredProcedureWithResults("GetApplicantInfo", parameters);
            var result = storedProcedureService.ConvertDataTableToList(db);
            return Ok(result);
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