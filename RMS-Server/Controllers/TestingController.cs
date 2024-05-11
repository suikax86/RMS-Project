using System.Data;
using Microsoft.AspNetCore.Mvc;
using RMS_Server.Interfaces;

namespace RMS_Server.Controllers;

[ApiController]
[Route("controller")]
public class TestingController : ControllerBase
{
    IStoredProcedureService _storedProcedureService;

    public TestingController(IStoredProcedureService storedProcedureService)
    {
        _storedProcedureService = storedProcedureService;
    }

    // GET
    [HttpGet]
    public IActionResult Get(string query)
    {
        var dt = _storedProcedureService.ExecuteQueryWithResults(query);

        var result = new List<Dictionary<string, object>>();
        foreach (DataRow row in dt.Rows)
        {
            var dict = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                dict[col.ColumnName] = row[col];
            }
            result.Add(dict);
        }

        return Ok(result);
    }
}