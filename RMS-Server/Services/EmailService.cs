using System.Net;
using System.Net.Mail;
using RMS_Server.Interfaces;

namespace RMS_Server.Services;

public class EmailService : IEmailService
{
    public async Task SendEmailAsync(string to, string subject, string body)
    {
        using (SmtpClient smtpClient = new SmtpClient("smtp.gmail.com"))
        {
            smtpClient.UseDefaultCredentials = false;
            smtpClient.Credentials = new NetworkCredential("mpfitus@gmail.com", "wanifirqpvshynqg");
            smtpClient.EnableSsl = true;
            smtpClient.Port = 587;
            using (MailMessage mailMessage = new MailMessage())
            {
                mailMessage.From = new MailAddress("mpfitus@gmail.com");
                mailMessage.To.Add(to);
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = true;
                await smtpClient.SendMailAsync(mailMessage);
            }
        }
    }
}