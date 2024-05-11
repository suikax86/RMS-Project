using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using RMS_Server.Interfaces;
using RMS_Server.Models;
using RMS_Server.Models.Enums;

namespace RMS_Server.Controllers;

[ApiController]
[Route("[controller]")]
public class JobPostingController(IStoredProcedureService storedProcedureService) : ControllerBase
{
    [HttpGet]
    public IActionResult GetJobPostingDetails(int jobPostingId)
    {
        var parameters = new SqlParameter[]
        {
            new ("@JobPostingId", jobPostingId)
        };
        try
        {
            var dataTable = storedProcedureService.ExecuteStoredProcedureWithResults("GetJobPostingDetails", parameters);
            var result = storedProcedureService.ConvertDataTableToList(dataTable);
            return Ok(result);
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
    
    [HttpPost]
    public IActionResult CreateJobPosting([FromBody] JobPosting jobPosting)
    {
        var parameters = new SqlParameter[]
        {
            new ("@Position", jobPosting.Position),
            new ("@Quantity", jobPosting.Quantity),
            new ("@PostingTime", jobPosting.PostingTime),
            new ("@StartTime", jobPosting.StartTime),
            new ("@EndTime", jobPosting.EndTime),
            new ("@Requirements", jobPosting.Requirements),
            new ("@CompanyID", jobPosting.CompanyID),
            new ("@FeedBack", jobPosting.FeedBack),
            new ("@Status", jobPosting.Status)
        };
        try
        {
            storedProcedureService.ExecuteStoredProcedure("CreateJobPosting", parameters);
            return Ok();
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
    
    [HttpPut]
    public IActionResult ApproveJobPosting(int jobPostingId, 
        [SwaggerParameter(Description = "Status: Pending = 0, Approved = 1, Rejected = 2")] Status status, 
        String feedback)
    {
        var parameters = new SqlParameter[]
        {
            new ("@JobPostingId", jobPostingId),
            new ("@ApproveOrNot", (int) status),
            new("@FeedBack", feedback)
        };
        try
        {
            storedProcedureService.ExecuteStoredProcedure("JobPostingReview", parameters);
            return Ok();
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