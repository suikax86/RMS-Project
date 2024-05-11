using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using RMS_Server.Interfaces;
using RMS_Server.Models.Dtos;

namespace RMS_Server.Controllers;

[ApiController]
[Route("[controller]")]
public class ApplicantController : ControllerBase
{
    private readonly IStoredProcedureService _storedProcedureService;

    public ApplicantController(IStoredProcedureService storedProcedureService)
    {
        _storedProcedureService = storedProcedureService;
    }

    [HttpPost]
    public IActionResult register(ApplicantRegisterRequest applicant)
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
            _storedProcedureService.ExecuteStoredProcedure("RegisterApplicant", parameters);
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
    
}