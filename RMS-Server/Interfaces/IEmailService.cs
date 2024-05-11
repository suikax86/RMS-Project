namespace RMS_Server.Interfaces;

public interface IEmailService
{
    Task SendEmailAsync(string to, string subject, string body);

}