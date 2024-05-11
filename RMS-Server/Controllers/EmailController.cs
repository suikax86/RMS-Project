using Microsoft.AspNetCore.Mvc;
using RMS_Server.Interfaces;

namespace RMS_Server.Controllers;

[ApiController]
[Route("[controller]")]
public class EmailController(IEmailService emailService) : ControllerBase
{
    IEmailService _emailService = emailService;
    
    [HttpPost]
    public async Task<IActionResult> SendEmailAsync(string to, string subject, string body)
    {
        await _emailService.SendEmailAsync(to, subject, body);
        return Ok();
    }
}