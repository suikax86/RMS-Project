namespace RMS_Server.Models.Dtos;

public class CompanyAccountRequest
{
    public string Username { get; set; }
    public string Password { get; set; }
    public string CompanyName { get; set; }
    public string TaxIdentificationNumber { get; set; }
}